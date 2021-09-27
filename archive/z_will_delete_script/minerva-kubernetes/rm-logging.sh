#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl delete -f ./logging-config/efk-fluent-bit/fluent-bit-ds.yaml
kubectl delete -f ./logging-config/efk-fluent-bit/fluent-bit-configmap.yaml
kubectl delete -f ./logging-config/efk-fluent-bit/fluent-bit-role-binding.yaml
kubectl delete -f ./logging-config/efk-fluent-bit/fluent-bit-role.yaml
kubectl delete -f ./logging-config/efk-fluent-bit/fluent-bit-service-account.yaml
sleep 10

kubectl delete -f ./logging-config/efk-kibana/node-port.yaml
kubectl delete -f ./logging-config/efk-kibana/cluster-ip.yaml
kubectl delete -f ./logging-config/efk-kibana/deployment.yaml
sleep 5

kubectl delete -f ./logging-config/efk-elasticsearch/cluster-ip.ya
kubectl delete -f ./logging-config/efk-elasticsearch/deployment.yaml
sleep 5




