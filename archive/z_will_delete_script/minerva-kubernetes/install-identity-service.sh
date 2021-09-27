#!/usr/bin/env bash

targetMode=$1
if [ -z $targetMode ]
then
  echo "Please provide targetMode parameter to execute this script" 1>&2
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

export KUBECONFIG=/etc/kubernetes/admin.conf

deployOnCondition(){
  condition=$1
  yamlFile=$2
  if [ $targetMode = $condition ]
  then
    kubectl apply -f $yamlFile
  fi
}

kubectl apply -f ./identity-config/config.yaml
sleep 10

kubectl apply -f ./identity-config/postgres/volume.yaml
kubectl apply -f ./identity-config/postgres/deployment.yaml
kubectl apply -f ./identity-config/postgres/cluster-ip.yaml
kubectl apply -f ./identity-config/postgres/node-port.yaml
sleep 10

kubectl apply -f ./identity-config/homepage-ui/deployment.yaml
kubectl apply -f ./identity-config/homepage-ui/cluster-ip.yaml
deployOnCondition "development" ./identity-config/homepage-ui/node-port.yaml
deployOnCondition "production-private" ./identity-config/homepage-ui/node-port.yaml
deployOnCondition "production-public" ./identity-config/homepage-ui/ingress.yaml
sleep 10

kubectl apply -f ./identity-config/identity-ui/deployment.yaml
kubectl apply -f ./identity-config/identity-ui/cluster-ip.yaml
deployOnCondition "development" ./identity-config/identity-ui/node-port.yaml
deployOnCondition "production-private" ./identity-config/identity-ui/node-port.yaml
deployOnCondition "production-public" ./identity-config/identity-ui/ingress.yaml
sleep 10

kubectl apply -f ./identity-config/token-mt/deployment.yaml
kubectl apply -f ./identity-config/token-mt/cluster-ip.yaml
deployOnCondition "development" ./identity-config/token-mt/node-port.yaml
sleep 10

kubectl apply -f ./identity-config/identity-api/deployment.yaml
kubectl apply -f ./identity-config/identity-api/cluster-ip.yaml
deployOnCondition "development" ./identity-config/identity-api/node-port.yaml
deployOnCondition "production-private" ./identity-config/identity-api/node-port.yaml
deployOnCondition "production-public" ./identity-config/identity-api/ingress.yaml
sleep 10
