#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

docker rm -f identity_pg
docker rm -f expert_redis
docker rm -f token_mt
docker rm -f identity_api
docker rm -f homepage_ui
docker rm -f identity_ui
docker rm -f rabbitmq
docker rm -f labeling_ui
docker rm -f information-extraction-cpu0
docker rm -f information-extraction-cpu1
docker rm -f information-extraction-cpu2
docker rm -f information-extraction-cpu3
docker rm -f information-extraction-gpu0
docker rm -f information-extraction-mt

echo -e "remove all minerva docker container successfully"
