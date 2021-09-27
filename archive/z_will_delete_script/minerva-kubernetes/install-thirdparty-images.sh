#!/usr/bin/env bash

ip=$1
registry=${ip}:5001

if [ -z $ip ]; then
  echo "please provide local machine IP as parameter" 1>&2
  exit 1
fi

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

deployLogDir=../logs
mkdir -p $deployLogDir
log_file=$deployLogDir/install_3rd_party_images_$(date +"%Y-%m-%d").log

imagesBaseDir=../images
thirdpartyImageDir=$imagesBaseDir/thirdparty
thirdpartyImagesListFilePath=./image-list/3rd-images.txt

logger()
{
    log=$1
    cur_time='['$(date +"%Y-%m-%d %H:%M:%S")']'
    echo ${cur_time} ${log} | tee -a ${log_file}
}

echocolor()
{
  log=$1
  echo -e "\n\e[40;31;1m$log\e[0m\n"
}

images=$(ls $thirdpartyImageDir | grep ".tgz")
for imgs in $(echo ${images});
do
  imageFilePath=$thirdpartyImageDir/${imgs}
  echocolor "start to load image file：$imageFilePath"

  gunzip -c $imageFilePath | docker load

  if [ $? -ne 0 ]; then
      logger "$imageFilePath load failed."
  else
      logger "$imageFilePath load successfully."
  fi
done

images=$(cat $thirdpartyImagesListFilePath)
for img in $(echo ${images}); do
    docker tag $img $registry/$img
    docker image rm $img
    docker push $registry/$img
    logger "$registry/$img push successfully."
    echocolor "push $registry/$img successfully."
done