#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl apply -f ./logging-config/efk-elasticsearch/deployment.yaml
kubectl apply -f ./logging-config/efk-elasticsearch/cluster-ip.yaml
sleep 10

kubectl apply -f ./logging-config/efk-kibana/deployment.yaml
kubectl apply -f ./logging-config/efk-kibana/cluster-ip.yaml
kubectl apply -f ./logging-config/efk-kibana/node-port.yaml
sleep 10

kubectl apply -f ./logging-config/efk-fluent-bit/fluent-bit-service-account.yaml
kubectl apply -f ./logging-config/efk-fluent-bit/fluent-bit-role.yaml
kubectl apply -f ./logging-config/efk-fluent-bit/fluent-bit-role-binding.yaml
kubectl apply -f ./logging-config/efk-fluent-bit/fluent-bit-configmap.yaml
kubectl apply -f ./logging-config/efk-fluent-bit/fluent-bit-ds.yaml
sleep 10