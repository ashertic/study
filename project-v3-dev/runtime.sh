#!/usr/bin/env bash
export ip=192.168.1.9
export redisPassword=bz1XLAb3GKb7
export pgPassword=Ku5C43CHb9
export pgDataDir=/data/kangdele-declaration/postgres
export projectDir=/data2/project_dev
export pgPort=56000
export redisPort=6381

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