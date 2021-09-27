# ip=$1
ip=10.170.49.77
# kdl-api env
kdl_api_data=/data/kdl

pgPassword=Ku5C43CHb9
pgDataDir=/data/kangdele-declaration/postgres
redisPassword=bz1XLAb3GKb7

# TODO 改变启动选项和设置密码
# redis
echo -e "\ncreate redis"
docker run -d \
--name=ultra_redis \
--restart=always \
-e REDIS_PASSWORD="$redisPassword" \
-p 6381:6379 \
redis:5.0.5-alpine \
redis-server --requirepass "$redisPassword" --appendonly "yes"
sleep 10

# TODO 改变启动选项和设置密码
# postgres
echo -e "\ncreate postgres"
docker run -d \
  --name=postgres \
  --restart=always \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD="$pgPassword" \
  -v $pgDataDir:/var/lib/postgresql/data \
postgres:11.5-alpine


# TODO: 迁移表 + seeder 初始化数据
# metis_db_migration
echo -e "\ninitialize metis database"
docker run --rm \
  -e POSTGRES=postgres:"$pgPassword"@"$ip":5432 \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/metis_ultra/metis_db_migration:beta
sleep 10

# identity-db
echo -e "\ninitialize identity database"
docker run --rm \
  -e DB_EXECUTION_CONTEXT=production \
  -e POSTGRES=postgres:Ku5C43CHb9@"$ip":5432 \
  -e DB_NAME=identity_management_kdl \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/identity_db:kdl
sleep 10

# kdl-db
echo -e "\ninitialize kdl database"
docker run --rm \
  -e DB_EXECUTION_CONTEXT=production \
  -e POSTGRES=postgres:Ku5C43CHb9@"$ip":5432 \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/kdl_db:latest
sleep 10


# TODO: 项目挂载点改为一个
# metis_runtime
echo -e "\ncreate metis_runtime"
docker run -d \
  --name metis_runtime \
  --shm-size 32G \
  -p 8000:8000 \
  -p 8265:8265 \
  -e DATA_DIR=/ultra/data \
  -e MODULE_DIR=/ultra/modules \
  -e WHEEL_DIR=/ultra/wheels \
  -e RESOURCE_ROOT=/ultra/resource \
  -e MT_GPU=0 \
  -e PYTHONPATH=/ultra \
  -e POSTGRES=postgres://postgres:Ku5C43CHb9@10.170.49.77:5432/metis_ultra \
  -e REDIS=redis://user:bzpXOAb5GkBO@10.170.49.77:6381 \
  -e CPU_EXECUTOR_NUMBER=6 \
  -e GPU_EXECUTOR_NUMBER=2 \
  -e EXECUTOR_GPU_NUM=1 \
  -v /data/project-kangdele-ultra/ultra/data:/ultra/data \
  -v /data/project-kangdele/data_root/intelligence/expert/intelligence-mt-resource:/ultra/resource \
  -v /data/project-kangdele-ultra/ultra/wheels:/ultra/wheels \
  -v /data/project-kangdele-ultra/ultra/module_library:/ultra/modules \
  metis-ultra:beta


# identity - api
docker run -d \
  --name=identity_api_kdl \
  -p 5210:5200 \
  -e POSTGRES=postgres:Ku5C43CHb9@"$ip":5432 \
  -e POSTGRES_IDENTITY=identity_management_kdl \
  -e KDL_HOST=//$ip:7100/v1 \
  -e SERVICE_SECRET=//$ip:5100/secret \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/identity_api:kdl

# kdl - api
docker run -d \
  --name=kdl_api \
  --network host \
  -p 7100:7100 \
  -v $kdl_api_data:/data/kdl \
  -e DEPOT=/data/kdl \
  -e POSTGRES=postgres:Ku5C43CHb9@"$ip":5432 \
  -e POSTGRES_KDL=kdl \
  -e SERVICE_SECRET=http://$ip:5100/secret \
  -e SERVICE_METIS=http://$ip:8000 \
  -e SERVICE_IDENTITY=http://$ip:5210/v1 \
  -e SPLIT_INVOICE_WORKFLOW=LAjaKME1U8 \
  -e HANDLE_INVOICE_WORKFLOW=JoFvEuimQtYAJzq4johRkE \
  -e SPLIT_AUTHORIZATION_WORKFLOW=DteiO5Wv2s4JTLBPbzk_k \
  -e HANDLE_AUTHORIZATION_WORKFLOW=xXy19AsLhISULNb3bXUiL \
  -e HANA_HOST=10.1.147.166 \ 
  -e HANA_PORT=30041 \
  -e HANA_USER=E_OCR_CONN \
  -e HANA_PASSWORD=Shap@2021 \
  -e CMSFTP_HOST=10.1.16.73 \
  -e CMSFTP_PORT=22 \
  -e CMSFTP_PATH=/cmsFS/cms/uploader/saphana \
  -e CMSFTP_USER=admin \
  -e CMSFTP_PASSWORD=Password1 \
  -e CMSAPI_URL=http://10.1.16.73:8020/cmsapi/OptDoc \
  -e CMSAPI_SYSTEM=SAPHANA \
  -e CMSAPI_TAG=0 \
  -e CMSAPI_INVOICE_TYPE=11521 \
  -e CMSAPI_AUTHORIZATION_TYPE=11522 \
  -e CMSAPI_USERID=saphanaadmin \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/kdl_api:latest
# identity - ui
docker run -d \
  --name=identity_ui_kdl \
  -p 9110:9100 \
  -e VUE_APP_HOMEPAGE_ROOT_URL=//$ip:8087 \
  -e VUE_APP_IDENTITY_HOST=//$ip:5210/v1 \
  -e VUE_APP_TENANT=minerva \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/identity_ui:kdl

# homepage
docker run -d \
  --name=homepage_ui_kdl \
  -p 8087:8082 \
  -e VUE_APP_TENANT=minerva \
  -e VUE_APP_TENANT_NAME=康德乐 \
  -e VUE_APP_IDENTITY_HOST=//$ip:5210/v1 \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/homepage_ui:kdl

# kdl - ui
docker run -d \
  --name=kdl_ui \
  -p 7101:7101 \
  -e VUE_APP_HOMEPAGE_ROOT_URL=//$ip:8087 \
  -e VUE_APP_KDL_HOST=//$ip:7100/v1 \
  -e VUE_APP_IDENTITY_HOST=//$ip:5210/v1 \
  -e VUE_APP_TENANT=minerva \
  -e VUE_APP_IDENTITY=http://$ip:9110 \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/kdl_ui:latest

# token - mt
docker run -d \
  --name=token_mt \
  -p 5100:5100 \
  -e SECRET_KEY=jd98u3oijmrf9u02p3kemf9q7uyrhfgnm4tuer9vcjkm34ijo \
  -e SECRET_EXPIRED_DAYS=7 \
  -e SECRET_STATIC=true \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/token_mt:latest

