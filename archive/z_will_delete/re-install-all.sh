#!/usr/bin/env bash

ip=$1
registry=${ip}:5001

if [ -z $ip ]; then
  echo "please provide local machine IP as parameter"
  exit -1
fi

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run with sudo" 1>&2
  exit 1
fi

echocolor()
{
  log=$1
  echo -e "\n\e[40;31;1m$log\e[0m\n"
}

export KUBECONFIG=/etc/kubernetes/admin.conf

kubeadm reset -f
rm -r -f $HOME/.kube

docker container stop $(docker ps -q)
docker container rm $(docker ps -a -q)
docker ps -a

docker image rm -f $(docker images -q)
docker images
docker volume prune -f
docker volume ls

rm -r -f /etc/sysctl.d/k8s.conf

echocolor "uninstall all service, wait 30 seconds before reinstall them"
sleep 30

workdir=`pwd`
cd centos

echocolor "change docker config to enable nvidia runtime"
./change-docker-config.sh $ip gpu

echocolor "install kubeadm, kubelet, kubectl, kubernetes docker images"
./install-kubernetes-tools.sh $ip

echocolor "node type is: master, so will setup kubernetes cluster and local registry"
echocolor "create kubernetes cluster control plane"
./install-kubernetes-cluster.sh $ip

echocolor "install local registry"
./install-local-registry.sh $ip

cd $workdir
cd minerva-kubernetes
./install-all.sh $ip

