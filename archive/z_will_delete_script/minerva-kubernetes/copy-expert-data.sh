#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

targetDataBaseDir=$1
if [ -z $targetDataBaseDir ]; then
  echo "please provide targetDataBaseDir" 1>&2
  exit 1
fi

echocolor()
{
  log=$1
  echo -e "\n\e[40;31;1m$log\e[0m\n"
}

resourcesDir=../resources-common/expert-intelligence
targetExpertDir=$targetDataBaseDir/expert

echocolor "start to copy expert intelligence data"
echo "targetExpertDir=$targetExpertDir"
echo "targetMTConfigsDir=$targetExpertDir/intelligence-mt-configs"
echo "targetMTDataDir=$targetExpertDir/intelligence-mt-data"
echo "targetMTModelRepositoryDir=$targetExpertDir/intelligence-mt-model-repository"
echo "targetMTModelsDir=$targetExpertDir/intelligence-mt-models"
echo "targetMTResourceDir=$targetExpertDir/intelligence-mt-resource"
echo "targetMTWheelDir=$targetExpertDir/intelligence-mt-wheel"

mkdir -p $targetExpertDir

cp -r $resourcesDir/intelligence-mt-configs $targetExpertDir
cp -r $resourcesDir/intelligence-mt-data $targetExpertDir
cp -r $resourcesDir/intelligence-mt-model-repository $targetExpertDir
cp -r $resourcesDir/intelligence-mt-models $targetExpertDir
cp -r $resourcesDir/intelligence-mt-resource $targetExpertDir
cp -r $resourcesDir/intelligence-mt-wheel $targetExpertDir
