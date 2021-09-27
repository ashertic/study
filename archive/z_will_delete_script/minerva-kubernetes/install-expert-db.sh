#!/usr/bin/env bash

ip=$1
registry=${ip}:5001

if [ -z $ip ]; then
  echo "please provide local machine IP as parameter"
  exit -1
fi

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

export KUBECONFIG=/etc/kubernetes/admin.conf

docker run -e POSTGRES=postgres:GiM6G53ZsnSQ@$ip:30003 $registry/expert/expert_db:latest
