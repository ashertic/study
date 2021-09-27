#!/bin/sh

fullImageTag=$1

imageTag=$2

if [ -z $fullImageTag ]; then
  echo "please input the fullImageTag"
  exit 1
fi

if [ -z $imageTag ]; then
  echo "please input the imageTag"
  exit 1
fi

# imageTag=declaration/declaration_api:latest

docker save $fullImageTag | gzip > $(echo ${imageTag} | sed "s#/#-#g; s#:#-#g").tgz