#!/usr/bin/env bash

ip=$1

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
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
  echo ""
}

echoArguments

export KUBECONFIG=/etc/kubernetes/admin.conf

echocolor "prepare registry config and certificate"
./prepare.sh $ip

echocolor "load thirdparty images"
./install-thirdparty-images.sh $ip

echocolor "load minerva images"
./install-minerva-images.sh $ip ./image-list/minerva-all-images.txt

echocolr "deploy logging services"
./install-logging-service.sh $ip

echocolor "deploy minerva identity services"
./install-identity-service.sh $ip
./install-identity-db.sh $ip

echocolor "deploy minerva expert services"
./install-expert-service.sh $ip
./install-expert-db.sh $ip

echocolor "deploy minerva dialog services"
./install-dialog-service.sh $ip
./install-dialog-db.sh $ip