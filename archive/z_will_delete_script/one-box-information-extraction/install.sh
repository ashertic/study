#!/usr/bin/env bash

ip=$1

if [ -z $ip ]; then
  echo "please provide local machine IP as parameter"
  exit -1
fi

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run with sudo" 1>&2
  exit 1
fi

echocolor()
{
  log=$1
  echo -e "\n\e[40;31;1m$log\e[0m\n"
}

pgPassword=Kt4C4TCHJ3
pdDataDir=/data/identity/postgres
infoSessionDir=/data/expert/information-extraction/session
infoWorkspaceDir=/data/expert/information-extraction/workspace

imageLoadFlagFilePath=".image_already_load_flag"
identityDBAlreadySetupFlagFilePath=".identity_db_already_setup_flag"

mkdir -p $pdDataDir
mkdir -p $infoSessionDir
mkdir -p $infoWorkspaceDir

if [ ! -f "$imageLoadFlagFilePath" ]; then
  touch $imageLoadFlagFilePath

  echocolor  "will load postgres docker image"
  gunzip -c ./images/thirdparty/postgres-11.5-alpine.tgz | docker load
  echocolor  "will load rabbitmq docker image"
  gunzip -c ./images/thirdparty/rabbitmq-3.8-rc-management-alpine.tgz | docker load
  echocolor  "will load homepage_ui docker image"
  gunzip -c ./images/minerva/identity/identity-homepage_ui-latest.tgz | docker load
  echocolor  "will load identity_api docker image"
  gunzip -c ./images/minerva/identity/identity-identity_api-latest.tgz | docker load  
  echocolor  "will load identity_db docker image"
  gunzip -c ./images/minerva/identity/identity-identity_db-latest.tgz | docker load
  echocolor  "will load identity_ui docker image"
  gunzip -c ./images/minerva/identity/identity-identity_ui-latest.tgz | docker load  
  echocolor  "will load token_mt docker image"
  gunzip -c ./images/minerva/identity/identity-token_mt-latest.tgz | docker load
  echocolor  "will load labeling_ui docker image"
  gunzip -c ./images/minerva/expert/expert-labeling_ui-latest.tgz | docker load
  echocolor  "will load information_extraction docker image"
  gunzip -c ./images/minerva/expert/expert-information_extraction-latest.tgz | docker load
fi

docker run -d \
--name=identity_pg \
--restart=always \
-p 5432:5432 \
-e POSTGRES_PASSWORD="$pgPassword" \
-v $pdDataDir:/var/lib/postgresql/data \
postgres:11.5-alpine

if [ ! -f "$identityDBAlreadySetupFlagFilePath" ]; then
  touch $identityDBAlreadySetupFlagFilePath

  sleep 30
  echocolor "will initialize identity DB"
  docker run --rm \
  -e POSTGRES_DB_IDENTITY_MANAGEMENT_HOST=$ip \
  -e POSTGRES_DB_IDENTITY_MANAGEMENT_PORT=5432 \
  -e POSTGRES_DB_IDENTITY_MANAGEMENT_DATABASE="identity-management" \
  -e POSTGRES_DB_IDENTITY_MANAGEMENT_USERNAME="postgres" \
  -e POSTGRES_DB_IDENTITY_MANAGEMENT_PASSWORD="$pgPassword" \
  -e DB_EXECUTION_CONTEXT="cntaiping" \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/identity_db:latest
fi

docker run -d \
--name=token_mt \
--restart=always \
-p 5100:5100 \
-e SECRET_KEY="jd98u3oijmrf9u02p3kemf9q7uyrhfgnm4tuer9vcjkm34ijo" \
-e SECRET_EXPIRED_DAYS="7" \
-e SECRET_STATIC="true" \
swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/token_mt:latest

docker run -d \
--name=identity_api \
--restart=always \
-p 5200:5200 \
-e POSTGRES="postgres:$pgPassword@$ip:5432" \
-e POSTGRES_IDENTITY="identity-management" \
-e SERVICE_SECRET="http://$ip:5100/secret" \
swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/identity_api:latest

docker run -d \
--name=homepage_ui \
--restart=always \
-p 8081:8082 \
-e VUE_APP_HOMEPAGE_ROOT_URL="//$ip:8081" \
-e VUE_APP_IDENTITY_HOST="//$ip:5200/v1" \
-e VUE_APP_READER_ROOT_URL="//$ip:8082" \
-e VUE_APP_ACCOUNT_ROOT_URL="//$ip:9100" \
swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/homepage_ui:latest
sleep 10

docker run -d \
--name=identity_ui \
--restart=always \
-p 8083:8082 \
-e VUE_APP_HOMEPAGE_ROOT_URL="//$ip:8081" \
-e VUE_APP_IDENTITY_HOST="//$ip:5200/v1" \
swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/identity_ui:latest
sleep 10

docker run -d \
--name=labeling_ui \
--restart=always \
-p 8082:8082 \
-e VUE_APP_HOMEPAGE_ROOT_URL="//$ip:8081" \
-e VUE_APP_ACCOUNT_ROOT_URL="//$ip:8083" \
-e VUE_APP_IDENTITY_API_HOST="//$ip:5200/v1" \
-e VUE_APP_READER_API_HOST="//$ip:5001" \
-e VUE_APP_OCR_API_ROOT_URL="" \
swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/labeling_ui:latest
sleep 10

docker run -d \
--name=expert_rabbitmq \
--restart=always \
-p 15672:15672 \
-p 5672:5672 \
rabbitmq:3.8-rc-management-alpine

docker run -d \
--name=information_extraction_cpu0 \
--restart=always \
-e MT_CPU="1" \
-e MT_INSTANCE_ID="mt.cpu.0" \
-e MT_MQHOST="$ip" \
-e MT_TRAINABLE="10:00,0:00" \
-e MT_MACHINE_ID="apjAt/pfjroOtfXtmAHgqhIPi6/UhKv/B4B8n/wkFCTJWDufRpItzd3Xij0VyDCJogrlxWIyNkyMJT1oZdR0AuzuDD1rZhjEF6/zu37CUX843v7rLf8XKoScOq3/TaXFVhfGdWMkP+mEQZ/BuCCUEGUINGzL0iPcCeUjkSw6kuw=" \
-v $infoSessionDir:/app/package/data/session \
-v $infoWorkspaceDir:/app/package/data/workspace \
--privileged=true \
swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/information_extraction:latest
sleep 120

docker run -d \
--name=information_extraction_gpu0 \
--restart=always \
-e MT_GPU="0" \
-e MT_INSTANCE_ID="mt.gpu0" \
-e MT_MQHOST="$ip" \
-e MT_TRAINABLE="10:00,0:00" \
-e MT_MACHINE_ID="apjAt/pfjroOtfXtmAHgqhIPi6/UhKv/B4B8n/wkFCTJWDufRpItzd3Xij0VyDCJogrlxWIyNkyMJT1oZdR0AuzuDD1rZhjEF6/zu37CUX843v7rLf8XKoScOq3/TaXFVhfGdWMkP+mEQZ/BuCCUEGUINGzL0iPcCeUjkSw6kuw=" \
-v $infoSessionDir:/app/package/data/session \
-v $infoWorkspaceDir:/app/package/data/workspace \
--privileged=true \
swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/information_extraction:latest
sleep 60

docker run -d \
--name=information_extraction_mt \
--restart=always \
-p "5001:5001" \
-e MT_HTTPS="0" \
-e MT_PRIMARY="1" \
-e MT_INSTANCE_ID="mt.primary" \
-e MT_MQHOST="$ip" \
-e MT_TRAINABLE="0:00,23:59" \
-e MT_MACHINE_ID="apjAt/pfjroOtfXtmAHgqhIPi6/UhKv/B4B8n/wkFCTJWDufRpItzd3Xij0VyDCJogrlxWIyNkyMJT1oZdR0AuzuDD1rZhjEF6/zu37CUX843v7rLf8XKoScOq3/TaXFVhfGdWMkP+mEQZ/BuCCUEGUINGzL0iPcCeUjkSw6kuw=" \
--privileged=true \
swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/information_extraction:latest
sleep 60
