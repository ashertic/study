#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

ip=$1
if [ -z $ip ]; then
  echo "please provide registry IP" 1>&2
  exit 1
fi

data_root=$2
if [ -z $data_root ]; then
  data_root=/data1
fi

registryAuthDir=$3
if [ -z $registryAuthDir ]; then
    registryAuthDir=$data_root/minerva/setup/registry
fi

registryImageDir=$4
if [ -z $registryImageDir ]; then
    registryImageDir=$data_root/minerva/setup/registry-images
fi

echo "ip=$ip"
echo "data_root=$data_root"
echo "registryAuthDir=$registryAuthDir"
echo -e "registryImageDir=$registryImageDir\n"

workdir=`pwd`

echo -e "\nclose and disable firewall"
firewall-cmd --state
systemctl stop firewalld
systemctl disable firewalld
systemctl mask --now firewalld

echo -e "\ndisable swap"
swapoff -a

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
registry=$ip:5001
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

sed -i "s/192.168.200.211:8000/$registry/g" /etc/docker/daemon.json

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

echo -e "\ninstall kubernetes"
cd $workdir/packages/kubernetes-packages
rpm -ivh --replacefiles --replacepkgs *.rpm

echo -e "\nchange config to make kubernetes work correctly"
update-alternatives --set iptables /usr/sbin/iptables-legacy

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
vm.swappiness=0
EOF
cat /etc/sysctl.d/k8s.conf
sysctl --system
systemctl enable --now kubelet

echo -e "\nkubeadm version"
kubeadm version

echo -e "\nload kubernetes related docker images"
cd $workdir/kubernetes/kubernetes-images
gunzip -c ./calico-cni-v3.10.1.tgz | docker load
gunzip -c ./calico-pod2daemon-flexvol-v3.10.1.tgz | docker load
gunzip -c ./k8s.gcr.io-kube-apiserver-v1.16.3.tgz | docker load
gunzip -c ./k8s.gcr.io-kube-scheduler-v1.16.3.tgz | docker load
gunzip -c ./nvidia-k8s-device-plugin-1.0.0-beta4.tgz | docker load
gunzip -c ./calico-kube-controllers-v3.10.1.tgz | docker load
gunzip -c ./k8s.gcr.io-coredns-1.6.2.tgz | docker load
gunzip -c ./k8s.gcr.io-kube-controller-manager-v1.16.3.tgz | docker load
gunzip -c ./k8s.gcr.io-pause-3.1.tgz | docker load
gunzip -c ./calico-node-v3.10.1.tgz | docker load
gunzip -c ./k8s.gcr.io-etcd-3.3.15-0.tgz | docker load
gunzip -c ./k8s.gcr.io-kube-proxy-v1.16.3.tgz | docker load
gunzip -c ./nginx-ingress-controller.tgz | docker load

echo -e "\nkubernetes images are:"
docker images

echo -e "\nsetup kubernetes cluster master node"
cd $workdir/kubernetes/kubernetes-config
POD_CIDR="10.96.0.0/12"
sed -i -e "s?192.168.0.0/16?$POD_CIDR?g" calico.yaml

kubeadm init --apiserver-advertise-address $ip --apiserver-bind-port 6443 --kubernetes-version 1.16.3 --pod-network-cidr $POD_CIDR

export KUBECONFIG=/etc/kubernetes/admin.conf
sleep 5
kubectl get nodes

echo -e "\napply kubernetes network addon: calico"
kubectl apply -f calico.yaml
sleep 120
echo -e "\nkubernetes information as below:"
kubectl get nodes
kubectl get pods --all-namespaces

echo -e "\nconfigure cluster to allow assign Pod to master node"
kubectl taint nodes --all node-role.kubernetes.io/master-
sleep 30

echo -e "\ninstall nginx ingress"
kubectl apply -f ingress-mandatory.yaml
kubectl apply -f ingress-service-nodeport.yaml
sleep 30
kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx
kubectl get svc -n ingress-nginx

echo -e "\ninstall nvidia-device-plugin"
kubectl apply -f nvidia-device-plugin.yaml
sleep 30
kubectl get pods --all-namespaces -l name=nvidia-device-plugin-ds
kubectl get nodes "-o=custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu"


echo -e "\nsetup local docker images registry"
registryTarFile=$workdir/registry-docker-image/registry-2.7.1.tgz
registryImage="registry:2.7.1"
mkdir -p $registryAuthDir
gunzip -c $registryTarFile | docker load
docker run --rm --entrypoint htpasswd $registryImage -Bbn testuser minerva > $registryAuthDir/htpasswd

docker run -d \
  -p 5001:5000 \
  --restart=always \
  --name registry \
  -v $registryAuthDir:/auth \
  -v $registryImageDir:/var/lib/registry \
  -e "REGISTRY_AUTH=htpasswd" \
  -e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
  -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
  $registryImage

sleep 15
echo -e "\ntry to docker login to local private docker registry"
docker login --username='testuser' --password='minerva' $registry

echo -e "\ndocker, nvidia docker runtime, kubernetes has been installed and kubernetes cluster also setuped, please execute next script to install Minerva services"
