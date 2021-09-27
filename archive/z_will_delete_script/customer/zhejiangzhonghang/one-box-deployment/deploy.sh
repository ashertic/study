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
pgDataDir=/data/identity/postgres

redisPassword=bzpXOAb5GkBO

imageLoadFlagFilePath=".image_already_load_flag"
identityDBAlreadySetupFlagFilePath=".identity_db_already_setup_flag"

intelligenceDataDir=/data/expert/intelligence-mt-data
intelligenceWheelDir=/data/expert/intelligence-mt-wheel
intelligenceResourceDir=/data/expert/intelligence-mt-resource
intelligenceModelsDir=/data/expert/intelligence-mt-models
intelligenceConfigsDir=/data/expert/intelligence-mt-configs
intelligenceModelRepositoryDir=/data/expert/intelligence-mt-model-repository

mkdir -p $pgDataDir
mkdir -p $intelligenceDataDir
mkdir -p $intelligenceWheelDir
mkdir -p $intelligenceResourceDir
mkdir -p $intelligenceModelsDir
mkdir -p $intelligenceConfigsDir
mkdir -p $intelligenceModelRepositoryDir


if [ ! -f "$imageLoadFlagFilePath" ]; then
  touch $imageLoadFlagFilePath

  echocolor  "will load postgres docker image"
  gunzip -c ./images/thirdparty/postgres-11.5-alpine.tgz | docker load
  echocolor  "will load redis docker image"
  gunzip -c ./images/thirdparty/redis-5.0.5-alpine.tgz | docker load
  echocolor  "will load identity_db docker image"
  gunzip -c ./images/minerva/identity/identity-identity_db-latest.tgz | docker load
  echocolor  "will load homepage_ui docker image"
  gunzip -c ./images/minerva/identity/identity-homepage_ui-latest.tgz | docker load
  echocolor  "will load identity_api docker image"
  gunzip -c ./images/minerva/identity/identity-identity_api-latest.tgz | docker load
  echocolor  "will load identity_ui docker image"
  gunzip -c ./images/minerva/identity/identity-identity_ui-latest.tgz | docker load
  echocolor  "will load token_mt docker image"
  gunzip -c ./images/minerva/identity/identity-token_mt-latest.tgz | docker load
  echocolor  "will load expert_api docker image"
  gunzip -c ./images/minerva/expert/expert-expert_api-latest.tgz | docker load
  echocolor  "will load expert_db docker image"
  gunzip -c ./images/minerva/expert/expert-expert_db-latest.tgz | docker load
  echocolor  "will load expert_ui docker image"
  gunzip -c ./images/minerva/expert/expert-expert_ui-latest.tgz | docker load
  echocolor  "will load intelligence_mt docker image"
  gunzip -c ./images/minerva/expert/expert-intelligence_mt-latest.tgz | docker load
  echocolor  "will load intelligence_worker docker image"
  gunzip -c ./images/minerva/expert/expert-intelligence_worker-latest.tgz | docker load
fi

docker run -d \
--name=identity_pg \
--restart=always \
-p 5432:5432 \
-e POSTGRES_PASSWORD="$pgPassword" \
-v $pgDataDir:/var/lib/postgresql/data \
postgres:11.5-alpine
sleep 20

docker run -d \
--name=expert_redis \
--restart=always \
-e REDIS_PASSWORD="$redisPassword" \
-p 6379:6379 \
redis:5.0.5-alpine \
redis-server --requirepass "$redisPassword" --appendonly "yes"
sleep 10

if [ ! -f "$identityDBAlreadySetupFlagFilePath" ]; then
  touch $identityDBAlreadySetupFlagFilePath

  sleep 10
  echocolor "will initialize identity DB"
  docker run --rm \
  -e POSTGRES_DB_IDENTITY_MANAGEMENT_HOST=$ip \
  -e POSTGRES_DB_IDENTITY_MANAGEMENT_PORT=5432 \
  -e POSTGRES_DB_IDENTITY_MANAGEMENT_DATABASE="identity-management" \
  -e POSTGRES_DB_IDENTITY_MANAGEMENT_USERNAME="postgres" \
  -e POSTGRES_DB_IDENTITY_MANAGEMENT_PASSWORD="$pgPassword" \
  -e DB_EXECUTION_CONTEXT="boczj" \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/identity_db:latest

  echocolor "will initialize expert DB"
  docker run --rm \
  -e POSTGRES="postgres:$pgPassword@$ip:5432" \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/expert_db:latest

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
-e VUE_APP_ACCOUNT_ROOT_URL="//$ip:8083" \
-e VUE_APP_NENG_ROOT_URL="//$ip:8085" \
-e VUE_APP_READER_ROOT_URL="" \
-e VUE_APP_IDENTITY_HOST="//$ip:5200/v1" \
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
--name=expert_ui \
--restart=always \
-p 8085:8082 \
-e VUE_APP_INFER_MODE="sync" \
-e VUE_APP_TENANT="minerva" \
-e VUE_APP_HOMEPAGE_ROOT_URL="//$ip:8081" \
-e VUE_APP_PRIMARY_COLOR="" \
-e VUE_APP_COOKIE_DOMAIN_NAME="" \
-e VUE_APP_NAME="能手" \
-e VUE_APP_FOOTER_TEXT="©2019 苏州美能华智能科技有限公司" \
-e VUE_APP_IDENTITY_HOST="//$ip:5200/v1" \
-e VUE_APP_EXPERT_HOST="//$ip:7001/v1" \
swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/expert_ui:latest
sleep 10


docker run -d \
--name=expert_api \
--restart=always \
-p 7001:7001 \
-e POSTGRES="postgres:$pgPassword@$ip:5432" \
-e POSTGRES_DATABASE="expert" \
-e SERVICE_SECRET="http://$ip:5100/secret" \
-e SERVICE_INTELLIGENCE="http://$ip:6001" \
-e MINERVAOCR="" \
swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/expert_api:latest
sleep 10


docker run -d \
--name=intelligence_mt \
--restart=always \
-p 6001:3000 \
-e QUEUE_SIZE="4" \
-e QUEUE_NAME="INFER" \
-e RESTFUL_HOST="0.0.0.0" \
-e RESTFUL_PORT="3000" \
-e DATA_ROOT="/app/data" \
-e REDIS_URL="redis://:$redisPassword@$ip:6379" \
-e TASK_TIMEOUT="20m" \
-v $intelligenceDataDir:/app/data \
-v $intelligenceWheelDir:/app/wheel \
swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/intelligence_mt:latest
sleep 30


docker run -d \
--name=intelligence_worker \
--restart=always \
--gpus all \
-e QUEUE_SIZE="4" \
-e LISTENING_QUEUES="INFER" \
-e DATA_ROOT="/app/data" \
-e MODEL_REPOSITORY_ROOT="/app/models" \
-e RESOURCE_ROOT="/app/resource" \
-e CONFIGS_ROOT="/app/configs" \
-e MODEL_REPOSITORY="/app/model_repository" \
-e MT_GPU="0" \
-e REDIS_URL="redis://:$redisPassword@$ip:6379" \
-e MODELS="intelligence_model_convert_html,intelligence_rule_table_to_excel" \
-v $intelligenceDataDir:/app/data \
-v $intelligenceWheelDir:/app/wheel \
-v $intelligenceResourceDir:/app/resource \
-v $intelligenceModelsDir:/app/models \
-v $intelligenceConfigsDir:/app/configs \
-v $intelligenceModelRepositoryDir:/app/model_repository \
--privileged=true \
swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/intelligence_worker:latest
sleep 90

