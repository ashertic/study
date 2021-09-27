#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

workdir=`pwd`

kernel_version=$(uname -r)
target_package_dir=../../centos-packages/$kernel_version/nvidia-docker
cd $target_package_dir
rpm -ivh --replacefiles --replacepkgs *.rpm

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
  "insecure-registries" : ["192.168.200.211:8000"]
}
EOF

echo -e "configure docker as below"
cat /etc/docker/daemon.json

echo -e "\nrestart docker"
systemctl daemon-reload
systemctl restart docker
sleep 5
systemctl status docker.service
echo -e "docker version"
docker info
sleep 10

echo -e "test docker container can use nvidia gpu"
cd $workdir
cd ../../os-setup-common-files/common-docker-images
gunzip -c ./cuda_9_0_base.tgz | docker load
docker run --rm nvidia/cuda:9.0-base nvidia-smi
docker image rm -f nvidia/cuda:9.0-base
docker images
docker ps -a
