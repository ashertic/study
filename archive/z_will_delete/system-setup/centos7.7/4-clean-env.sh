#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echo -e "\ndelete kubernetes cluster and delete configuration, it may take several minutes, please wait"
kubeadm reset -f
rm -r -f /etc/sysctl.d/k8s.conf

echo -e "\nremove running docker containers and images"
docker container stop $(sudo docker ps -q)
docker ps -a
docker container rm $(sudo docker ps -a -q)
docker ps -a
docker image rm -f $(sudo docker images -q)
docker volume prune -f
docker system df

echo -e "\nsystem is clean now"