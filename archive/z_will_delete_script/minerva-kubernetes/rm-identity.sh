#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

export KUBECONFIG=/etc/kubernetes/admin.conf

kubectl delete -f ./identity-config/homepage-ui/ingress.yaml
kubectl delete -f ./identity-config/homepage-ui/node-port.yaml
kubectl delete -f ./identity-config/homepage-ui/cluster-ip.yaml
kubectl delete -f ./identity-config/homepage-ui/deployment.yaml
sleep 5

kubectl delete -f ./identity-config/identity-ui/ingress.yaml
kubectl delete -f ./identity-config/identity-ui/node-port.yaml
kubectl delete -f ./identity-config/identity-ui/cluster-ip.yaml
kubectl delete -f ./identity-config/identity-ui/deployment.yaml
sleep 5

kubectl delete -f ./identity-config/identity-api/ingress.yaml
kubectl delete -f ./identity-config/identity-api/node-port.yaml
kubectl delete -f ./identity-config/identity-api/cluster-ip.yaml
kubectl delete -f ./identity-config/identity-api/deployment.yaml
sleep 5

kubectl delete -f ./identity-config/token-mt/node-port.yaml
kubectl delete -f ./identity-config/token-mt/cluster-ip.yaml
kubectl delete -f ./identity-config/token-mt/deployment.yaml
sleep 5

kubectl delete -f ./identity-config/postgres/node-port.yaml
kubectl delete -f ./identity-config/postgres/cluster-ip.yaml
kubectl delete -f ./identity-config/postgres/deployment.yaml
kubectl delete -f ./identity-config/postgres/volume.yaml
sleep 5

kubectl delete -f ./identity-config/config.yaml
sleep 5
