#!/usr/bin/env bash
export ip=192.168.1.9
export redisPassword=bz1XLAb3GKb7
export pgPassword=Ku5C43CHb9
export pgDataDir=/data/kangdele-declaration/postgres
export projectDir=/data2/project_dev
export pgPort=56000
export redisPort=6381

#docker pull swr.cn-north-4.myhuaweicloud.com/meinenghua/metis_ultra/metis_db_migration:beta

# redis
echo -e "create redis"
docker run -d \
--name=ultra_redis \
--restart=always \
-e REDIS_PASSWORD="$redisPassword" \
-p "$redisPort":6379 \
swr.cn-north-4.myhuaweicloud.com/meinenghua/redis:5.0.5-alpine \
redis-server --requirepass "$redisPassword" --appendonly "yes"
sleep 10

# postgres
echo -e "create postgres"
docker run -d \
  --name=postgres \
  --restart=always \
  -p "$pgPort":5432 \
  -e POSTGRES_PASSWORD="$pgPassword" \
  -v "$pgDataDir":/var/lib/postgresql/data \
postgres:11.5-alpine
sleep 15

# metis_db_migration
echo -e "initialize metis database"
docker run --rm \
  -e POSTGRES=postgres:"$pgPassword"@"$ip":"$pgPort" \
  swr.cn-north-4.myhuaweicloud.com/meinenghua/metis_ultra/metis_db_migration:beta
sleep 10

# metis_runtime
echo -e "create metis_runtime"
docker run -d \
  --name metis_runtime \
  --shm-size 128G \
  --ulimit core=100 \
  -p 8000:8000 \
  -p 8265:8265 \
  -e DATA_DIR=/ultra/data \
  -e MODULE_DIR=/ultra/modules \
  -e WHEEL_DIR=/ultra/wheels \
  -e RESOURCE_ROOT=/ultra/resource \
  -e MT_GPU=0 \
  -e PYTHONPATH=/ultra \
  -e POSTGRES=postgres://postgres:"$pgPassword"@"$ip":"$pgPort"/metis_ultra \
  -e REDIS=redis://user:"$redisPassword"@"$ip":"$redisPort" \
  -e CPU_EXECUTOR_NUMBER=12 \
  -e GPU_EXECUTOR_NUMBER=4 \
  -e EXECUTOR_GPU_NUM=1 \
  -v "$projectDir"/data:/ultra/data \
  -v "$projectDir"/dependencies/resource:/ultra/resource \
  -v "$projectDir"/dependencies/wheels:/ultra/wheels \
  -v "$projectDir"/module_library:/ultra/modules \
  metis_runtime:beta