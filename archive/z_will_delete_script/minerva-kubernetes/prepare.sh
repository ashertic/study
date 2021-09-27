#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

targetMode=$1
if [ -z $targetMode ]
then
  echo "Please provide targetMode parameter to execute this script" 1>&2
  exit 1
fi

if [[ $targetMode = "development" || $targetMode = "production-private" ]]
then
  ip=$2
  if [ -z $ip ]
  then
    echo "please provide registry IP parameter to execute this script" 1>&2
    exit 1
  fi
fi

echocolor()
{
  log=$1
  echo -e "\n\e[40;31;1m$log\e[0m\n"
}

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl create namespace identity
kubectl create namespace expert
kubectl create namespace dialog
# create this namespace for EFK usage
kubectl create namespace logging

echocolor "namespace list:"
kubectl get namespace

if [[ $targetMode = "development" || $targetMode = "production-private" ]]
then
  kubectl create secret docker-registry meinenghua \
    --docker-server=$ip:5001 --docker-username=testuser --docker-password=minerva --namespace=identity

  kubectl create secret docker-registry meinenghua \
    --docker-server=$ip:5001 --docker-username=testuser --docker-password=minerva --namespace=expert

  kubectl create secret docker-registry meinenghua \
    --docker-server=$ip:5001 --docker-username=testuser --docker-password=minerva --namespace=dialog

  kubectl create secret docker-registry meinenghua \
    --docker-server=$ip:5001 --docker-username=testuser --docker-password=minerva --namespace=logging
fi

if [ $targetMode = "production-public" ]
then
  kubectl create secret tls meinenghua-com --key ../cert/meinenghua.com/2_meinenghua.com.key \
    --cert ../cert/meinenghua.com/1_meinenghua.com_bundle.crt --namespace=identity

  kubectl create secret tls meinenghua-com --key ../cert/meinenghua.com/2_meinenghua.com.key \
    --cert ../cert/meinenghua.com/1_meinenghua.com_bundle.crt --namespace=expert

  kubectl create secret tls meinenghua-com --key ../cert/meinenghua.com/2_meinenghua.com.key \
    --cert ../cert/meinenghua.com/1_meinenghua.com_bundle.crt --namespace=dialog
fi


# kubectl create secret tls local-mnv --key ../cert/local.mnv/tls.key --cert \
#   ../cert/local.mnv/tls.crt --namespace=identity

# kubectl create secret tls local-mnv --key ../cert/local.mnv/tls.key --cert \
#   ../cert/local.mnv/tls.crt --namespace=dialog

# kubectl create secret tls local-mnv --key ../cert/local.mnv/tls.key --cert \
#   ../cert/local.mnv/tls.crt --namespace=expert