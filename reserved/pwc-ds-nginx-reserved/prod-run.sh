#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

workdir=`pwd`

confPath="$workdir/local-prod-nginx.conf"
logPath="$workdir/log"
confdPath="$workdir/conf.d"
certPath="$workdir/cert"

echo -e "current work directory: $workdir"
echo -e "nginx configure path  : $confPath"
echo -e "nginx log directory   : $logPath"
echo -e "nginx conf.d          : $confdPath"
echo -e "nginx cert path       : $certPath"

docker run  -d \
--name nginx \
--restart=always \
--network host \
-v $confPath:/etc/nginx/nginx.conf \
-v $logPath:/var/log/nginx \
-v $confdPath:/etc/nginx/conf.d \
-v $certPath:/etc/nginx/cert \
nginx:1.17.6

echo -e "start nginx successfully"
