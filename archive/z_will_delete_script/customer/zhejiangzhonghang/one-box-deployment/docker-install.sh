#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi


workdir=`pwd`

echo -e "\nclose and disable firewall"
firewall-cmd --state
systemctl stop firewalld
systemctl disable firewalld
systemctl mask --now firewalld



echo -e "\ndisable SELinux"
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

echo -e "\nContent of file /etc/selinux/config"
cat /etc/selinux/config

echo -e "\ninstall docker packages"
cd $workdir/packages/docker-1809-packages
rpm -ivh --replacefiles --replacepkgs *.rpm

echo -e "\nstart docker service"
systemctl enable docker.service
systemctl start docker
echo -e "\nbelow is docker information"
docker info

echo -e "\ninstall nvidia docker runtime"
cd $workdir/packages/nvidia-docker2-packages
rpm -ivh --replacefiles --replacepkgs *.rpm

echo -e "\nchange docker config to use nvidia docker runtime by default"
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "default-runtime": "nvidia",
  "runtimes": {
      "nvidia": {
          "path": "/usr/bin/nvidia-container-runtime",
          "runtimeArgs": []
      }
  },
}
EOF


echo -e "\nconfigure docker as below"
cat /etc/docker/daemon.json

echo -e "\nrestart docker service"
systemctl daemon-reload
systemctl restart docker
echo -e "\ndocker service status"
systemctl status docker.service
sleep 5
echo -e "\ndocker info"
docker info

echo -e "\nrun cuda docker image to verify nvidia docker runtime"
cd $workdir
gunzip -c ./cuda-test-image/cuda_9_0_base.tgz | docker load
docker run --rm nvidia/cuda:9.0-base nvidia-smi
docker image rm -f nvidia/cuda:9.0-base



