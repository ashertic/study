#!/usr/bin/env bash

# run below command to enable debug mode
# sudo docker run  -d \
# --name nginx \
# --restart=always \
# --network host \
# -v /data/nginx/test-nginx.conf:/etc/nginx/nginx.conf \
# -v /data/nginx/log:/var/log/nginx \
# -v /data/nginx/conf.d:/etc/nginx/conf.d \
# -v /data/nginx/cert-test:/etc/nginx/cert \
# nginx:1.17.6 \
# nginx-debug -g 'daemon off;'

# run below command for production use
docker run  -d \
--name nginx \
--restart=always \
--network host \
-v /data/nginx/test-nginx.conf:/etc/nginx/nginx.conf \
-v /data/nginx/log:/var/log/nginx \
-v /data/nginx/conf.d:/etc/nginx/conf.d \
-v /data/nginx/cert-test:/etc/nginx/cert \
nginx:1.17.6