#!/usr/bin/env bash

ip=$1
imageListFile=$2

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

if [ -z $imageListFile ]; then
  echo "please provide image list file"
  exit -1
fi

if [ -z $ip ]; then
  echo "please provide machine IP as parameter"
  exit 1
fi

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
  echo -e "\e[40;31;1m    imageListFile=$imageListFile\e[0m"
  echo ""
}

echoArguments

export KUBECONFIG=/etc/kubernetes/admin.conf

echocolor "pull and save minerva images"
./save-minerva-images.sh $imageListFile

echocolor "load minerva images"
./install-minerva-images.sh $ip $imageListFile



echocolor "re-deploy minerva identity services"
./rm-identity.sh
sleep 60

echocolor "identity deployment state:"
kubectl get deployments.apps -n identity

./install-identity-service.sh $ip
sleep 60

echocolor "identity deployment state:"
kubectl get deployments.apps -n identity



echocolor "re-deploy minerva expert services"
./rm-expert.sh
sleep 60

echocolor "expert deployment state:"
kubectl get deployments.apps -n expert

./install-expert-service.sh $ip
sleep 60

echocolor "expert deployment state:"
kubectl get deployments.apps -n expert
