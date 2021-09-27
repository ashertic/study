#!/usr/bin/env bash

# if [[ $EUID -ne 0 ]]; then
#   echo "This script must be run as root" 1>&2
#   exit 1
# fi

mkdir -p ./images/minerva/identity
mkdir -p ./images/minerva/expert

noConfirm=$1

timeout=10

readIsSkip(){
  targetImage=$1
  echo -e "\nWill download image: $targetImage"
  echo -n "If you want to skip download please type yes:"
  read -t $timeout isSkip
  echo ""
  if [[ $isSkip = "y" || $isSkip = "yes" || $isSkip = "Yes" || $isSkip = "YES" ]]
  then
    echo "Skip download: $targetImage"
    return 0
  else
    return 1
  fi
}

downloadAndSave() {
  imageName=$1
  imageTag=$2
  category=$3

  imageFullName="swr.cn-north-4.myhuaweicloud.com/meinenghua/$category/$imageName:$imageTag"
  # echo "debug: $imageFullName"
  docker pull $imageFullName

  if [[ $imageName = "pwc-home-page" ]]
  then
    echo "tag image with a new tag"
    docker tag swr.cn-north-4.myhuaweicloud.com/meinenghua/privatization/pwc-home-page:latest swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/homepage_ui:latest
    docker image rm swr.cn-north-4.myhuaweicloud.com/meinenghua/privatization/pwc-home-page:latest
    imageFullName="swr.cn-north-4.myhuaweicloud.com/meinenghua/identity/homepage_ui:latest"
  fi

  if [[ $imageName != "pwc-home-page" && $imageTag != "latest" ]]
  then
    echo "tag image with a new tag"
    newImageFullName="swr.cn-north-4.myhuaweicloud.com/meinenghua/$category/$imageName:latest"
    docker tag $imageFullName $newImageFullName
    docker image rm $imageFullName
    imageFullName=$newImageFullName
  fi

  # echo "debug: $imageFullName"
  fullnameWithouCloudPrefix=$(echo "$imageFullName" | sed -e "s?swr.cn-north-4.myhuaweicloud.com/meinenghua/??")

  echo "save image to file"
  if [[ $category = "privatization" ]]
  then
    docker save $imageFullName | gzip > ./images/minerva/identity/$(echo $fullnameWithouCloudPrefix | sed "s#/#-#g; s#:#-#g").tgz
  else
    docker save $imageFullName | gzip > ./images/minerva/$category/$(echo $fullnameWithouCloudPrefix | sed "s#/#-#g; s#:#-#g").tgz
  fi
}

confirmToDownload(){
  imageName=$1
  imageTag=$2
  category=$3

  if [[ $noConfirm = "yes" ]]
  then
    downloadAndSave $imageName $imageTag $category
  else
    readIsSkip $imageName
    if [[ $? != 0 ]]
    then
      downloadAndSave $imageName $imageTag $category
    fi
  fi
}

confirmToDownload "identity_db" "latest" "identity"
confirmToDownload "identity_ui" "latest" "identity"
confirmToDownload "identity_api" "latest" "identity"
confirmToDownload "token_mt" "latest" "identity"
confirmToDownload "pwc-home-page" "latest" "privatization"

confirmToDownload "labeling_ui" "pwc" "expert"
confirmToDownload "expert_ui" "latest" "expert"
confirmToDownload "expert_db" "latest" "expert"
confirmToDownload "expert_api" "latest" "expert"
confirmToDownload "intelligence_mt" "latest" "expert"
confirmToDownload "intelligence_worker" "latest" "expert"
confirmToDownload "information_extraction" "pwc" "expert"
