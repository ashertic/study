#!/usr/bin/env bash

ip=$1
type=$2

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

if [ -z $ip ]; then
  echo "please provide machine IP as parameter"
  exit 1
fi

if [ -z $type ]; then
  echo "please provide node type as parameter, its value must be: master or worker"
  exit 1
fi

# if [ -z $mode ]; then
#   echo "please provide mode parameter, its value must be: gpu or cpu"
#   exit 1
# fi

echocolor()
{
  log=$1
  echo -e "\n\e[40;31;1m$log\e[0m\n"
}

echoArguments()
{
  echo ""
  echo -e "\e[40;31;1mHere are input parameters：\e[0m"
  echo -e "\e[40;31;1m    ip=$ip\e[0m"
  echo -e "\e[40;31;1m    type=$type\e[0m"
  echo ""
}

echoArguments

echocolor "install docker"
./install-docker.sh

echocolor "install nvidia-docker2"
./install-nvidia-docker2.sh

echocolor "change docker config to enable nvidia runtime"
./change-docker-config.sh $ip gpu

echocolor "install kubeadm, kubelet, kubectl, kubernetes docker images"
./install-kubernetes-tools.sh


if [ $type = "master" ]
then

echo "node type is: master, so will setup kubernetes cluster and local registry"
echocolor "create kubernetes cluster control plane"
./install-kubernetes-cluster.sh $ip

echocolor "install local registry"
./install-local-registry.sh $ip "/minerva/registryauth" "/data/registry"

fi
