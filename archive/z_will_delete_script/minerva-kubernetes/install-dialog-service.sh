#!/usr/bin/env bash

targetMode=$1
if [ -z $targetMode ]
then
  echo "Please provide targetMode parameter to execute this script" 1>&2
  exit 1
fi

if [[ $EUID -ne 0 ]]
then
  echo "This script must be run with sudo" 1>&2
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

kubectl apply -f ./dialog-config/config.yaml
kubectl apply -f ./dialog-config/log-volume.yaml

kubectl apply -f ./dialog-config/postgres/volume.yaml
kubectl apply -f ./dialog-config/postgres/deployment.yaml
kubectl apply -f ./dialog-config/postgres/cluster-ip.yaml
kubectl apply -f ./dialog-config/postgres/node-port.yaml
sleep 10

kubectl apply -f ./dialog-config/rabbitmq/deployment.yaml
kubectl apply -f ./dialog-config/rabbitmq/cluster-ip.yaml
deployOnCondition "development" ./dialog-config/rabbitmq/node-port.yaml
sleep 10

kubectl apply -f ./dialog-config/redis/deployment.yaml
kubectl apply -f ./dialog-config/redis/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/agent-management-ms/deployment.yaml
kubectl apply -f ./dialog-config/agent-management-ms/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/bot-dialog-ms/deployment.yaml
kubectl apply -f ./dialog-config/bot-dialog-ms/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/bot-management-ms/deployment.yaml
kubectl apply -f ./dialog-config/bot-management-ms/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/client-management-ms/deployment.yaml
kubectl apply -f ./dialog-config/client-management-ms/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/dialog-engine-ms/deployment.yaml
kubectl apply -f ./dialog-config/dialog-engine-ms/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/dialog-message-ms/deployment.yaml
kubectl apply -f ./dialog-config/dialog-message-ms/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/dialog-report-ms/deployment.yaml
kubectl apply -f ./dialog-config/dialog-report-ms/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/exp-ms/deployment.yaml
kubectl apply -f ./dialog-config/exp-ms/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/task-dialog-poc-ms/deployment.yaml
kubectl apply -f ./dialog-config/task-dialog-poc-ms/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/dialog-report-pipeline/deployment.yaml
kubectl apply -f ./dialog-config/dialog-report-pipeline/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/nlp-service-pipeline/deployment.yaml
kubectl apply -f ./dialog-config/nlp-service-pipeline/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/nlp-elasticsearch/deployment.yaml
kubectl apply -f ./dialog-config/nlp-elasticsearch/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/nlp-mla/volume.yaml
kubectl apply -f ./dialog-config/nlp-mla/deployment.yaml
kubectl apply -f ./dialog-config/nlp-mla/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/nlp-mrtv/deployment.yaml
kubectl apply -f ./dialog-config/nlp-mrtv/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/nlp-pipeline-proxy/deployment.yaml
kubectl apply -f ./dialog-config/nlp-pipeline-proxy/cluster-ip.yaml
sleep 10

kubectl apply -f ./dialog-config/nlp-ehic-contextual-faq/volume.yaml
kubectl apply -f ./dialog-config/nlp-ehic-contextual-faq/deployment.yaml
kubectl apply -f ./dialog-config/nlp-ehic-contextual-faq/cluster-ip.yaml
deployOnCondition "development" ./dialog-config/nlp-ehic-contextual-faq/node-port.yaml
sleep 10

kubectl apply -f ./dialog-config/nlp-ehic-contextual-faq-http-proxy/deployment.yaml
kubectl apply -f ./dialog-config/nlp-ehic-contextual-faq-http-proxy/cluster-ip.yaml
deployOnCondition "development" ./dialog-config/nlp-ehic-contextual-faq-http-proxy/node-port.yaml
sleep 10

kubectl apply -f ./dialog-config/agent-gateway/deployment.yaml
kubectl apply -f ./dialog-config/agent-gateway/cluster-ip.yaml
deployOnCondition "development" ./dialog-config/agent-gateway/node-port.yaml
deployOnCondition "production-private" ./dialog-config/agent-gateway/node-port.yaml
deployOnCondition "production-public" ./dialog-config/agent-gateway/ingress.yaml
sleep 10

kubectl apply -f ./dialog-config/client-gateway/deployment.yaml
kubectl apply -f ./dialog-config/client-gateway/cluster-ip.yaml
deployOnCondition "development"  ./dialog-config/client-gateway/node-port.yaml
deployOnCondition "production-private"  ./dialog-config/client-gateway/node-port.yaml
deployOnCondition "production-public"  ./dialog-config/client-gateway/ingress.yaml
sleep 10

kubectl apply -f ./dialog-config/customer-service-admin-api/deployment.yaml
kubectl apply -f ./dialog-config/customer-service-admin-api/cluster-ip.yaml
deployOnCondition "development" ./dialog-config/customer-service-admin-api/node-port.yaml
deployOnCondition "production-private" ./dialog-config/customer-service-admin-api/node-port.yaml
deployOnCondition "production-public" ./dialog-config/customer-service-admin-api/ingress.yaml
sleep 10

kubectl apply -f ./dialog-config/customer-service-api/deployment.yaml
kubectl apply -f ./dialog-config/customer-service-api/cluster-ip.yaml
deployOnCondition "development" ./dialog-config/customer-service-api/node-port.yaml
deployOnCondition "production-private" ./dialog-config/customer-service-api/node-port.yaml
deployOnCondition "production-public" ./dialog-config/customer-service-api/ingress.yaml
sleep 10

kubectl apply -f ./dialog-config/css-admin-ui/deployment.yaml
kubectl apply -f ./dialog-config/css-admin-ui/cluster-ip.yaml
deployOnCondition "development" ./dialog-config/css-admin-ui/node-port.yaml
deployOnCondition "production-private" ./dialog-config/css-admin-ui/node-port.yaml
deployOnCondition "production-public" ./dialog-config/css-admin-ui/ingress.yaml
sleep 10

kubectl apply -f ./dialog-config/css-client-ui/deployment.yaml
kubectl apply -f ./dialog-config/css-client-ui/cluster-ip.yaml
deployOnCondition "development" ./dialog-config/css-client-ui/node-port.yaml
deployOnCondition "production-private" ./dialog-config/css-client-ui/node-port.yaml
deployOnCondition "production-public" ./dialog-config/css-client-ui/ingress.yaml
sleep 10
