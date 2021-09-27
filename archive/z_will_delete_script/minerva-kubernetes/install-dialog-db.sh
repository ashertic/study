#!/usr/bin/env bash

ip=$1
registry=${ip}:5001

if [ -z $ip ]; then
  echo "please provide local machine IP as parameter" 1>&2
  exit -1
fi

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

export KUBECONFIG=/etc/kubernetes/admin.conf

docker run \
-e PG_BOT_MANAGEMENT_HOST=$ip \
-e PG_BOT_MANAGEMENT_PORT=30002 \
-e PG_BOT_MANAGEMENT_DATABASE=bot-management \
-e PG_BOT_MANAGEMENT_USERNAME=postgres \
-e PG_BOT_MANAGEMENT_PASSWORD=W3n9JdFMUPYz \
-e DB_EXECUTION_CONTEXT=default \
$registry/dialog/db_bot_management:latest

docker run \
-e PG_CUSTOMER_SERVICE_HOST=$ip \
-e PG_CUSTOMER_SERVICE_PORT=30002 \
-e PG_CUSTOMER_SERVICE_DATABASE=customer-service \
-e PG_CUSTOMER_SERVICE_USERNAME=postgres \
-e PG_CUSTOMER_SERVICE_PASSWORD=W3n9JdFMUPYz \
-e DB_EXECUTION_CONTEXT=default \
$registry/dialog/db_customer_service:latest

docker run \
-e PG_DIALOG_MESSAGE_HOST=$ip \
-e PG_DIALOG_MESSAGE_PORT=30002 \
-e PG_DIALOG_MESSAGE_DATABASE=dialog-message \
-e PG_DIALOG_MESSAGE_USERNAME=postgres \
-e PG_DIALOG_MESSAGE_PASSWORD=W3n9JdFMUPYz \
-e DB_EXECUTION_CONTEXT=default \
$registry/dialog/db_dialog_message:latest

docker run \
-e PG_DIALOG_REPORT_HOST=$ip \
-e PG_DIALOG_REPORT_PORT=30002 \
-e PG_DIALOG_REPORT_DATABASE=dialog-report \
-e PG_DIALOG_REPORT_USERNAME=postgres \
-e PG_DIALOG_REPORT_PASSWORD=W3n9JdFMUPYz \
-e DB_EXECUTION_CONTEXT=default \
$registry/dialog/db_dialog_report:latest
