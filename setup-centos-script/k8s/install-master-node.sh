#!/usr/bin/env bash

ip=$1

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

if [ -z $ip ]; then
  echo "please provide cluster master node machine IP"
  exit 1
fi

echocolor()
{
  log=$1
  echo -e "\e[40;31;1m$log\e[0m"
}

workdir=`pwd`

echo -e "create kubernetes cluster"
cd ../../os-setup-common-files/k8s-1.16.3-config
POD_CIDR="10.96.0.0/12"
sed -i -e "s?192.168.0.0/16?$POD_CIDR?g" calico.yaml

kubeadm init --apiserver-advertise-address $ip --apiserver-bind-port 6443 --kubernetes-version 1.16.3 --pod-network-cidr $POD_CIDR
sleep 5

export KUBECONFIG=/etc/kubernetes/admin.conf

echo -e "get nodes:"
kubectl get nodes

echo -e "apply kubernetes network addon: calico"
kubectl apply -f calico.yaml
sleep 120

echo -e "kubernetes information as below:"
kubectl get nodes
kubectl get pods --all-namespaces

echo -e "configure cluster to allow assign Pod to master node"
kubectl taint nodes --all node-role.kubernetes.io/master-
sleep 10

echo -e "install nginx ingress"
kubectl apply -f ingress-mandatory.yaml
kubectl apply -f ingress-service-nodeport.yaml
sleep 30
kubectl get pods --all-namespaces -l app.kubernetes.io/name=ingress-nginx
kubectl get svc -n ingress-nginx

echo -e "install nvidia-device-plugin"
kubectl apply -f nvidia-device-plugin.yaml
sleep 30
kubectl get pods --all-namespaces -l name=nvidia-device-plugin-ds
kubectl get nodes "-o=custom-columns=NAME:.metadata.name,GPU:.status.allocatable.nvidia\.com/gpu"

sleep 10
echocolor "To make kubectl work for your non-root user, run these commands as regular user:"
echocolor 'mkdir -p $HOME/.kube'
echocolor 'sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config'
echocolor 'sudo chown $(id -u):$(id -g) $HOME/.kube/config'
echo -e "\n"

echocolor "please use below command to add other node to this cluster:"
echocolor "sudo kubeadm join $ip:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>"
echo -e "\n"

echocolor "you can get token with command: "
echocolor "kubeadm token list"
echo -e "\n"

echocolor "you can get hash with command: "
echocolor "openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'"
echo -e "\n"

sudo rm -r -f $HOME/.kube
