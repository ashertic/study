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

docker run --rm \
-e POSTGRES_DB_IDENTITY_MANAGEMENT_HOST=$ip \
-e POSTGRES_DB_IDENTITY_MANAGEMENT_PORT=30001 \
-e POSTGRES_DB_IDENTITY_MANAGEMENT_DATABASE=identity-management \
-e POSTGRES_DB_IDENTITY_MANAGEMENT_USERNAME=postgres \
-e POSTGRES_DB_IDENTITY_MANAGEMENT_PASSWORD=pyq5qaog3O00QeESDx6x \
-e DB_EXECUTION_CONTEXT=default \
$registry/identity/identity_db:latest
