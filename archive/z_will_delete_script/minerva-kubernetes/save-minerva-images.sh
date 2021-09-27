#!/usr/bin/env bash

imageListFile=$1
imageBaseDir=../images/minerva

if [ -z $imageListFile ]; then
  echo "please provide image list file"
  exit -1
fi

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echocolor()
{
  log=$1
  echo -e "\n\e[40;31;1m$log\e[0m\n"
}

echoArguments()
{
  echo ""
  echo -e "\e[40;31;1mHere are input parameters：\e[0m"
  echo -e "\e[40;31;1m    imageListFile=$imageListFile\e[0m"
  echo -e "\e[40;31;1m    imageBaseDir=$imageBaseDir\e[0m"
  echo ""
}

echoArguments

mkdir -p $imageBaseDir


pull_save_image() {
  imageTag=$1
  imageSaveDir=$2
  fullImageTag=swr.cn-north-4.myhuaweicloud.com/meinenghua/$imageTag
  echocolor "start to download Image: ${fullImageTag}"
  docker pull $fullImageTag
  docker save $fullImageTag | gzip > ${imageSaveDir}/$(echo ${imageTag} | sed "s#/#-#g; s#:#-#g").tgz
}

images=$(cat $imageListFile)

for imageInfo in $(echo $images); do
  echo $imageInfo
  array=(${imageInfo//,/ })
  arrayLength=${#array[*]}

  if [ $arrayLength -eq 2 ]; then
    imageTag=${array[0]}
    imageSaveDirName=$imageBaseDir/${array[1]}

    echocolor "$imageTag to $imageSaveDirName"
    
    mkdir -p $imageSaveDirName
    pull_save_image $imageTag $imageSaveDirName
  else
    echocolor "invalid image info line, length is $arrayLength, ignore it: $imageInfo"
  fi
done