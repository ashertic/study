#!/usr/bin/env bash

ip=$1

pgPassword=postgres
pgPort=5432
pgDataDir=/data/kangdele-declaration/postgres

redisPassword=bz1XLAb3GKb7

intelligenceDataDir=/data/kangdele-declaration/intelligence/intelligence-mt-data
intelligenceWheelDir=/data/kangdele-declaration/intelligence/intelligence-mt-wheel
intelligenceResourceDir=/data/kangdele-declaration/intelligence/intelligence-mt-resource
intelligenceModelsDir=/data/kangdele-declaration/intelligence/intelligence-mt-models
intelligenceConfigsDir=/data/kangdele-declaration/intelligence/intelligence-mt-configs


# echo -e "\ncreate database service"
# docker run -d \
# --name=declaration_pg \
# --restart=always \
# -p $pgPort:5432 \
# -e POSTGRES_PASSWORD="$pgPassword" \
# -v $pgDataDir:/var/lib/postgresql/data \
# postgres:11.5-alpine
# sleep 20

echo -e "\ninitialize database"
docker run --rm \
-e POSTGRES_DB_DECLARATION_HOST=$ip \
-e POSTGRES_DB_DECLARATION_PORT=$pgPort \
-e POSTGRES_DB_DECLARATION_USERNAME="postgres" \
-e POSTGRES_DB_DECLARATION_PASSWORD="$pgPassword" \
-e DB_EXECUTION_CONTEXT="production" \
swr.cn-north-4.myhuaweicloud.com/meinenghua/declaration/declaration_db:latest
sleep 10


echo -e "\ncreate declaration api service"
docker run -d \
--name=declaration_api \
--restart=always \
-p 7111:7111 \
-e POSTGRES_DB_DECLARATION_HOST=$ip \
-e POSTGRES_DB_DECLARATION_PORT=$pgPort \
-e POSTGRES_DB_DECLARATION_USERNAME="postgres" \
-e POSTGRES_DB_DECLARATION_PASSWORD="$pgPassword" \
-e POSTGRES_DATABASE="declaration-report" \
-e SERVICE_INTELLIGENCE="http://$ip:6001" \
swr.cn-north-4.myhuaweicloud.com/meinenghua/declaration/declaration_api:latest
sleep 10

echo -e "\ncreate declaration UI service"
docker run -d \
--name=declaration_ui \
--restart=always \
-p 8082:8082 \
-e VUE_APP_EXPERT_HOST="http://$ip:7111/v1" \
-e VUE_APP_INTELLIGENCE_API="http://$ip:6001" \
-e VUE_APP_INFER_MODE="sync" \
-e VUE_APP_TENANT="minerva" \
-e VUE_APP_FOOTER_TEXT="©2019苏州美能华智能科技有限公司" \
-e VUE_APP_NAME="能手" \
swr.cn-north-4.myhuaweicloud.com/meinenghua/declaration/declaration_ui:latest
sleep 10


echo -e "\ncreate intelligence MT service"
docker run -d \
--gpus all \
--name=intelligence_mt \
--restart=always \
-p 6001:3000 \
-e MT_MACHINE_ID="ojAnJUSMFSYwFLMPD96ANRX2Rwq2FJIZG+gnWzTUs2L7e+X2flJe3ZXfawDLt+fBOwZvRKbRW0syk9U5+UKu/8KWz+7AciX/4yN0hOBpLhJTNS3z969uOvwRQdjyZ4i0NnpHgPzTx+Y9iCyOFsCXMPfCiWBkdcQgVmSMDRKxUWc=" \
-e RESTFUL_HOST="0.0.0.0" \
-e RESTFUL_PORT="3000" \
-e DATA_ROOT="/app/data" \
-e MODEL_REPOSITORY_ROOT="/app/models" \
-e RESOURCE_ROOT="/app/resource" \
-e CONFIGS_ROOT="/app/configs" \
-e MODEL_REPOSITORY="/app/model_repository" \
-e MT_GPU="0" \
-e MODELS="intelligence_rule_kdl_declaration_report" \
-v $intelligenceDataDir:/app/data \
-v $intelligenceWheelDir:/app/wheel \
-v $intelligenceResourceDir:/app/resource \
-v $intelligenceModelsDir:/app/models \
-v $intelligenceConfigsDir:/app/configs \
--privileged=true \
swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/intelligence_mt:kdl-latest


# docker run -it \
# --name=intelligence_mt \
# -p 6001:3000 \
# -e MT_MACHINE_ID="ojAnJUSMFSYwFLMPD96ANRX2Rwq2FJIZG+gnWzTUs2L7e+X2flJe3ZXfawDLt+fBOwZvRKbRW0syk9U5+UKu/8KWz+7AciX/4yN0hOBpLhJTNS3z969uOvwRQdjyZ4i0NnpHgPzTx+Y9iCyOFsCXMPfCiWBkdcQgVmSMDRKxUWc=" \
# -e RESTFUL_HOST="0.0.0.0" \
# -e RESTFUL_PORT="3000" \
# -e DATA_ROOT="/app/data" \
# -e MODEL_REPOSITORY_ROOT="/app/models" \
# -e RESOURCE_ROOT="/app/resource" \
# -e CONFIGS_ROOT="/app/configs" \
# -e MODEL_REPOSITORY="/app/model_repository" \
# -e MT_GPU="0" \
# -e MODELS="intelligence_rule_kdl_declaration_report" \
# -v $intelligenceDataDir:/app/data \
# -v $intelligenceWheelDir:/app/wheel \
# -v $intelligenceResourceDir:/app/resource \
# -v $intelligenceModelsDir:/app/models \
# -v $intelligenceConfigsDir:/app/configs \
# --privileged=true \
# intelligence_mt /bin/sh


docker run --rm \
--privileged=true \
swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/soft_enctyption:latest
sleep 10

echo -e "\ninstallation completed successfully"

