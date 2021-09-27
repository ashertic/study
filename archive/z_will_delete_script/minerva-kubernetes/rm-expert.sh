#!/usr/bin/env bash

targetEnv=$1

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl delete -f ./expert-config/information-extraction-backend/mt-node-port.yaml
kubectl delete -f ./expert-config/information-extraction-backend/mt-cluster-ip.yaml
kubectl delete -f ./expert-config/information-extraction-backend/mt-deployment.yaml
kubectl delete -f ./expert-config/information-extraction-backend/gpu0-deployment.yaml
kubectl delete -f ./expert-config/information-extraction-backend/cpu0-deployment.yaml
if [[ $targetEnv = 'pwc' ]]
then
  kubectl delete -f ./expert-config/information-extraction-backend/cpu1-deployment.yaml
  kubectl delete -f ./expert-config/information-extraction-backend/cpu2-deployment.yaml
  kubectl delete -f ./expert-config/information-extraction-backend/cpu3-deployment.yaml
  kubectl delete -f ./expert-config/information-extraction-backend/cpu4-deployment.yaml
  kubectl delete -f ./expert-config/information-extraction-backend/cpu5-deployment.yaml
  kubectl delete -f ./expert-config/information-extraction-backend/cpu6-deployment.yaml
  kubectl delete -f ./expert-config/information-extraction-backend/cpu7-deployment.yaml
  kubectl delete -f ./expert-config/information-extraction-backend/gpu1-deployment.yaml
  kubectl delete -f ./expert-config/information-extraction-backend/gpu2-deployment.yaml
  kubectl delete -f ./expert-config/information-extraction-backend/gpu3-deployment.yaml
fi
kubectl delete -f ./expert-config/information-extraction-backend/volume.yaml
sleep 5

kubectl delete -f ./expert-config/intelligence-backend/worker-deployment.yaml
kubectl delete -f ./expert-config/intelligence-backend/mt-node-port.yaml
kubectl delete -f ./expert-config/intelligence-backend/mt-cluster-ip.yaml
kubectl delete -f ./expert-config/intelligence-backend/mt-deployment.yaml
kubectl delete -f ./expert-config/intelligence-backend/volume.yaml
sleep 5

kubectl delete -f ./expert-config/expert-ui/ingress.yaml
kubectl delete -f ./expert-config/expert-ui/node-port.yaml
kubectl delete -f ./expert-config/expert-ui/cluster-ip.yaml
kubectl delete -f ./expert-config/expert-ui/deployment.yaml
sleep 5

kubectl delete -f ./expert-config/labeling-ui/ingress.yaml
kubectl delete -f ./expert-config/labeling-ui/node-port.yaml
kubectl delete -f ./expert-config/labeling-ui/cluster-ip.yaml
kubectl delete -f ./expert-config/labeling-ui/deployment.yaml
sleep 5

kubectl delete -f ./expert-config/expert-api/ingress.yaml
kubectl delete -f ./expert-config/expert-api/node-port.yaml
kubectl delete -f ./expert-config/expert-api/cluster-ip.yaml
kubectl delete -f ./expert-config/expert-api/deployment.yaml
sleep 5

kubectl delete -f ./expert-config/postgres/node-port.yaml
kubectl delete -f ./expert-config/postgres/cluster-ip.yaml
kubectl delete -f ./expert-config/postgres/deployment.yaml
kubectl delete -f ./expert-config/postgres/volume.yaml
sleep 5

kubectl delete -f ./expert-config/rabbitmq/node-port.yaml
kubectl delete -f ./expert-config/rabbitmq/cluster-ip.yaml
kubectl delete -f ./expert-config/rabbitmq/deployment.yaml
sleep 5

kubectl delete -f ./expert-config/redis/cluster-ip.yaml
kubectl delete -f ./expert-config/redis/deployment.yaml
sleep 5

kubectl delete -f ./expert-config/config.yaml
sleep 5
