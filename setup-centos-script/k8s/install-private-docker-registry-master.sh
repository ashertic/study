#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

ip=$1
if [ -z $ip ]; then
  echo "please provide registry IP" 1>&2
  exit 1
fi

registryAuthDir=$2
if [ -z $registryAuthDir ]; then
  echo "please provide registryAuthDir" 1>&2
  exit 1
fi

registryImageDir=$3
if [ -z $registryImageDir ]; then
  echo "please provide registryImageDir" 1>&2
  exit 1
fi

registry=$ip:5001
registryTarFile=../../os-setup-common-files/common-docker-images/registry-2.7.1.tgz
registryImage="registry:2.7.1"

echo -e "change docker configure to use insecure private registry at $registry"
sed -i "s/192.168.200.211:8000/$registry/g" /etc/docker/daemon.json
systemctl restart docker
sleep 15

mkdir -p $registryAuthDir
mkdir -p $registryImageDir
gunzip -c $registryTarFile | docker load

docker run --entrypoint htpasswd \
$registryImage -Bbn testuser minerva > $registryAuthDir/htpasswd

docker run -d \
-p 5001:5000 \
--restart=always \
--name registry \
-v $registryAuthDir:/auth \
-v $registryImageDir:/var/lib/registry \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
-e "REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd" \
$registryImage

sleep 10
docker login --username='testuser' --password='minerva' $registry

# ./install-private-docker-registry-master.sh 10.0.0.10 /data/private-docker-registry /data/private-registry