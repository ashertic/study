#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

imageLoadFlagFilePath=".image_already_load_flag"

if [ ! -f "$imageLoadFlagFilePath" ]; then
touch  .image_already_load_flag
gunzip -c ../images/thirdparty/nginx.tgz  | docker load
fi



docker run  -d \
--name nginx \
--restart=always \
--network host \
-v /data/project-onlyou/nginx/nginx.conf:/etc/nginx/nginx.conf \
-v /data/project-onlyou/nginx/log:/var/log/nginx \
-v /data/project-onlyou/nginx/conf.d:/etc/nginx/conf.d \
nginx:1.17.6


