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

targetEnv=$2

export KUBECONFIG=/etc/kubernetes/admin.conf

deployOnCondition(){
  condition=$1
  yamlFile=$2
  if [[ $targetMode = $condition ]]
  then
    kubectl apply -f $yamlFile
  fi
}

kubectl apply -f ./expert-config/config.yaml
sleep 10

kubectl apply -f ./expert-config/postgres/volume.yaml
kubectl apply -f ./expert-config/postgres/deployment.yaml
kubectl apply -f ./expert-config/postgres/cluster-ip.yaml
kubectl apply -f ./expert-config/postgres/node-port.yaml
sleep 10

kubectl apply -f ./expert-config/rabbitmq/deployment.yaml
kubectl apply -f ./expert-config/rabbitmq/cluster-ip.yaml
deployOnCondition "development" ./expert-config/rabbitmq/node-port.yaml
sleep 10

kubectl apply -f ./expert-config/redis/deployment.yaml
kubectl apply -f ./expert-config/redis/cluster-ip.yaml
sleep 10

kubectl apply -f ./expert-config/expert-ui/deployment.yaml
kubectl apply -f ./expert-config/expert-ui/cluster-ip.yaml
deployOnCondition "development" ./expert-config/expert-ui/node-port.yaml
deployOnCondition "production-private" ./expert-config/expert-ui/node-port.yaml
deployOnCondition "production-public" ./expert-config/expert-ui/ingress.yaml
sleep 10

kubectl apply -f ./expert-config/labeling-ui/deployment.yaml
kubectl apply -f ./expert-config/labeling-ui/cluster-ip.yaml
deployOnCondition "development" ./expert-config/labeling-ui/node-port.yaml
deployOnCondition "production-private" ./expert-config/labeling-ui/node-port.yaml
deployOnCondition "production-public" ./expert-config/labeling-ui/ingress.yaml
sleep 10

kubectl apply -f ./expert-config/expert-api/deployment.yaml
kubectl apply -f ./expert-config/expert-api/cluster-ip.yaml
deployOnCondition "development" ./expert-config/expert-api/node-port.yaml
deployOnCondition "production-private" ./expert-config/expert-api/node-port.yaml
deployOnCondition "production-public" ./expert-config/expert-api/ingress.yaml
sleep 10

kubectl apply -f ./expert-config/intelligence-backend/volume.yaml
kubectl apply -f ./expert-config/intelligence-backend/worker-deployment.yaml
kubectl apply -f ./expert-config/intelligence-backend/mt-deployment.yaml
kubectl apply -f ./expert-config/intelligence-backend/mt-cluster-ip.yaml
deployOnCondition "development" ./expert-config/intelligence-backend/mt-node-port.yaml
sleep 10

kubectl apply -f ./expert-config/information-extraction-backend/volume.yaml
kubectl apply -f ./expert-config/information-extraction-backend/cpu0-deployment.yaml
sleep 30

kubectl apply -f ./expert-config/information-extraction-backend/gpu0-deployment.yaml
sleep 30

if [[ $targetEnv = 'pwc' ]]
then
  kubectl apply -f ./expert-config/information-extraction-backend/cpu1-deployment.yaml
  sleep 30
  kubectl apply -f ./expert-config/information-extraction-backend/cpu2-deployment.yaml
  sleep 30
  kubectl apply -f ./expert-config/information-extraction-backend/cpu3-deployment.yaml
  sleep 30
  kubectl apply -f ./expert-config/information-extraction-backend/cpu4-deployment.yaml
  sleep 30
  kubectl apply -f ./expert-config/information-extraction-backend/cpu5-deployment.yaml
  sleep 30
  kubectl apply -f ./expert-config/information-extraction-backend/cpu6-deployment.yaml
  sleep 30
  kubectl apply -f ./expert-config/information-extraction-backend/cpu7-deployment.yaml
  sleep 30  
  kubectl apply -f ./expert-config/information-extraction-backend/gpu1-deployment.yaml
  sleep 30
  kubectl apply -f ./expert-config/information-extraction-backend/gpu2-deployment.yaml
  sleep 30
  kubectl apply -f ./expert-config/information-extraction-backend/gpu3-deployment.yaml
  sleep 30
fi

kubectl apply -f ./expert-config/information-extraction-backend/mt-deployment.yaml
sleep 30

kubectl apply -f ./expert-config/information-extraction-backend/mt-cluster-ip.yaml
deployOnCondition "development" ./expert-config/information-extraction-backend/mt-node-port.yaml
deployOnCondition "production-private" ./expert-config/information-extraction-backend/mt-node-port.yaml
# need to assign an ingress to this service in production
# deployOnCondition "production-public" ./expert-config/information-extraction-backend/mt-ingress.yaml
sleep 10
