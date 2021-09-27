#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl delete -f ./dialog-config/css-client-ui/ingress.yaml
kubectl delete -f ./dialog-config/css-client-ui/node-port.yaml
kubectl delete -f ./dialog-config/css-client-ui/cluster-ip.yaml
kubectl delete -f ./dialog-config/css-client-ui/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/css-admin-ui/ingress.yaml
kubectl delete -f ./dialog-config/css-admin-ui/node-port.yaml
kubectl delete -f ./dialog-config/css-admin-ui/cluster-ip.yaml
kubectl delete -f ./dialog-config/css-admin-ui/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/customer-service-api/ingress.yaml
kubectl delete -f ./dialog-config/customer-service-api/node-port.yaml
kubectl delete -f ./dialog-config/customer-service-api/cluster-ip.yaml
kubectl delete -f ./dialog-config/customer-service-api/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/customer-service-admin-api/ingress.yaml
kubectl delete -f ./dialog-config/customer-service-admin-api/node-port.yaml
kubectl delete -f ./dialog-config/customer-service-admin-api/cluster-ip.yaml
kubectl delete -f ./dialog-config/customer-service-admin-api/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/client-gateway/ingress.yaml
kubectl delete -f ./dialog-config/client-gateway/node-port.yaml
kubectl delete -f ./dialog-config/client-gateway/cluster-ip.yaml
kubectl delete -f ./dialog-config/client-gateway/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/nlp-pipeline-proxy/cluster-ip.yaml
kubectl delete -f ./dialog-config/nlp-pipeline-proxy/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/nlp-mrtv/cluster-ip.yaml
kubectl delete -f ./dialog-config/nlp-mrtv/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/nlp-mla/cluster-ip.yaml
kubectl delete -f ./dialog-config/nlp-mla/deployment.yaml
kubectl delete -f ./dialog-config/nlp-mla/volume.yaml
sleep 5

kubectl delete -f ./dialog-config/nlp-elasticsearch/cluster-ip.yaml
kubectl delete -f ./dialog-config/nlp-elasticsearch/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/nlp-service-pipeline/cluster-ip.yaml
kubectl delete -f ./dialog-config/nlp-service-pipeline/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/nlp-ehic-contextual-faq/node-port.yaml
kubectl delete -f ./dialog-config/nlp-ehic-contextual-faq/cluster-ip.yaml
kubectl delete -f ./dialog-config/nlp-ehic-contextual-faq/deployment.yaml
kubectl delete -f ./dialog-config/nlp-ehic-contextual-faq/volume.yaml
sleep 5

kubectl delete -f ./dialog-config/nlp-ehic-contextual-faq-http-proxy/node-port.yaml
kubectl delete -f ./dialog-config/nlp-ehic-contextual-faq-http-proxy/cluster-ip.yaml
kubectl delete -f ./dialog-config/nlp-ehic-contextual-faq-http-proxy/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/dialog-report-pipeline/cluster-ip.yaml
kubectl delete -f ./dialog-config/dialog-report-pipeline/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/task-dialog-poc-ms/cluster-ip.yaml
kubectl delete -f ./dialog-config/task-dialog-poc-ms/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/exp-ms/cluster-ip.yaml
kubectl delete -f ./dialog-config/exp-ms/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/dialog-report-ms/cluster-ip.yaml
kubectl delete -f ./dialog-config/dialog-report-ms/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/dialog-message-ms/cluster-ip.yaml
kubectl delete -f ./dialog-config/dialog-message-ms/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/dialog-engine-ms/cluster-ip.yaml
kubectl delete -f ./dialog-config/dialog-engine-ms/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/agent-gateway/ingress.yaml
kubectl delete -f ./dialog-config/agent-gateway/node-port.yaml
kubectl delete -f ./dialog-config/agent-gateway/cluster-ip.yaml
kubectl delete -f ./dialog-config/agent-gateway/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/client-management-ms/cluster-ip.yaml
kubectl delete -f ./dialog-config/client-management-ms/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/bot-management-ms/cluster-ip.yaml
kubectl delete -f ./dialog-config/bot-management-ms/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/bot-dialog-ms/cluster-ip.yaml
kubectl delete -f ./dialog-config/bot-dialog-ms/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/agent-management-ms/cluster-ip.yaml
kubectl delete -f ./dialog-config/agent-management-ms/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/redis/cluster-ip.yaml
kubectl delete -f ./dialog-config/redis/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/rabbitmq/node-port.yaml
kubectl delete -f ./dialog-config/rabbitmq/cluster-ip.yaml
kubectl delete -f ./dialog-config/rabbitmq/deployment.yaml
sleep 5

kubectl delete -f ./dialog-config/postgres/node-port.yaml
kubectl delete -f ./dialog-config/postgres/cluster-ip.yaml
kubectl delete -f ./dialog-config/postgres/deployment.yaml
kubectl delete -f ./dialog-config/postgres/volume.yaml
sleep 5

kubectl delete -f ./dialog-config/log-volume.yaml

kubectl delete -f ./dialog-config/config.yaml