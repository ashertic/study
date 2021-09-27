#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echocolor()
{
  log=$1
  echo -e "\n\e[40;31;1m$log\e[0m\n"
}

# resourcesDir=../resources-common/expert-intelligence
# targetExpertDir=/data/expert

# echocolor "start to copy expert intelligence data"
# echo "targetExpertDir=$targetExpertDir"
# echo "targetDataDir=$targetExpertDir/intelligence-mt-configs"
# echo "targetDataDir=$targetExpertDir/intelligence-mt-data"
# echo "targetResourceDir=$targetExpertDir/intelligence-mt-model-repository"
# echo "targetModelsDir=$targetExpertDir/intelligence-mt-models"
# echo "targetResourceDir=$targetExpertDir/intelligence-mt-resource"
# echo "targetModelsDir=$targetExpertDir/intelligence-mt-wheel"

# mkdir -p $targetExpertDir

# cp -r $resourcesDir/intelligence-mt-configs $targetExpertDir
# cp -r $resourcesDir/intelligence-mt-data $targetExpertDir
# cp -r $resourcesDir/intelligence-mt-model-repository $targetExpertDir
# cp -r $resourcesDir/intelligence-mt-models $targetExpertDir
# cp -r $resourcesDir/intelligence-mt-resource $targetExpertDir
# cp -r $resourcesDir/intelligence-mt-wheel $targetExpertDir
