#!/usr/bin/env bash

ip=$1
imageListFile=$2

if [ -z $ip ]; then
  echo "please provide local machine IP as parameter"
  exit -1
fi

if [ -z $imageListFile ]; then
  echo "please provide image list file"
  exit -1
fi

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echoArguments()
{
  echo ""
  echo -e "\e[40;31;1mHere are input parameters：\e[0m"
  echo -e "\e[40;31;1m    ip=$ip\e[0m"
  echo -e "\e[40;31;1m    imageListFile=$imageListFile\e[0m"
  echo ""
}

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

echoArguments

deployLogDir=../logs
mkdir -p $deployLogDir
log_file=$deployLogDir/install_minerva_images_$(date +"%Y-%m-%d").log

registry=${ip}:5001
imageBaseDir=../images/minerva

load_and_push() {
  imageTag=$1
  imagePath=$2

  echocolor "load image from $imagePath"
  gunzip -c $imagePath | docker load
  if [ $? -ne 0 ]; then
      logger "$imagePath load failed."
  else
      logger "$imagePath load successfully."
  fi

  fullImageTag=swr.cn-north-4.myhuaweicloud.com/meinenghua/$imageTag
  echo $fullImageTag
  newImg=$(echo "$fullImageTag" | sed -e "s?swr.cn-north-4.myhuaweicloud.com/meinenghua/??")
  echo "$registry/$newImg"
  docker tag $fullImageTag $registry/$newImg
  docker image rm $fullImageTag
  docker push $registry/$newImg
  logger "$registry/$newImg push successfully."
  echocolor "push $registry/$newImg successfully."
}

images=$(cat $imageListFile)
for imageInfo in $(echo $images); do
  echo $imageInfo
  array=(${imageInfo//,/ })
  arrayLength=${#array[*]}

  if [ $arrayLength -eq 2 ]; then
    imageTag=${array[0]}
    imageDirName=$imageBaseDir/${array[1]}
    imageName=$(echo ${imageTag} | sed "s#/#-#g; s#:#-#g").tgz
    imagePath=$imageDirName/$imageName

    load_and_push $imageTag $imagePath
  else
    echocolor "invalid image info line, length is $arrayLength, ignore it: $imageInfo"
  fi
done
