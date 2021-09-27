#!/usr/bin/env bash
if [[ $EUID -ne 0 ]];then
  echo "This script must be run as root" 1>&2
  exit 1
fi

imagedir=/data1/minerva-setup/images/minerva
serviceconfigdir=/data1/minerva-setup/minerva-kubernetes


function readTargetServiceGroup(){
  echo -e "\nPlease select targetServiceGroup value from below options:"
  echo "  1. identity"
  echo "  2. expert"
  echo "  3. registry"
  echo "  4. thirdparty"
  echo -n "Please give the option number and press [ENTER] in 20 seconds: "
  read -t 20 choice
  return $choice
}


function UpdateIdentityService(){
  echo -e "\nPlease select updateServiceGroup value from below options:"
  echo "  1. homepage_ui"
  echo "  2. identity_api"
  echo "  3. identity_db"
  echo "  4. identity_ui"
  echo "  5. token_mt"
  echo -n "Please give the option number and press [ENTER] in 20 seconds: "
  read -t 20 choice
  return $choice
}



function UpdatEexpertService(){
  echo -e "\nPlease select updateServiceGroup value from below options:"
  echo "  1. expert_api"
  echo "  2. expert_db"
  echo "  3. expert_ui"
  echo "  4. information_extraction"
  echo "  5. intelligence_mt"
  echo "  6. intelligence_worker"
  echo "  7. labeling_ui"
  echo -n "Please give the option number and press [ENTER] in 20 seconds: "
  read -t 20 choice
  return $choice
}


function   CommandExecute(){
  imagetag=$1
  yamldir=$2
  imagetgz=$3
  fullImageTag=swr.cn-north-4.myhuaweicloud.com/meinenghua/$imagetag
  pwcImageTag=10.157.107.48:5001/$imagetag
  gunzip -c $imagetgz | docker load
  docker tag $fullImageTag  $pwcImageTag
  docker image rm  $fullImageTag 
  docker push  $pwcImageTag
  cd $serviceconfigdir/$yamldir
  kubectl delete -f deployment.yaml
  kubectl apply -f deployment
  kubectl get pods -n  ${imagetag%/*}
}

readTargetServiceGroup
case "$choice" in
1)
  UpdateIdentityService
  if [[ $choice != [1-7] ]];then
  echo "Please enter a correct parameter"
  exit 1
  fi
  cd $imagedir/identity
  if [ $choice -eq 1 ];then
    imagetag=identity/homepage_ui:latest  
    yamldir=identity-config/homepage_ui
    imagetgz=identity-homepage_ui-latest.tgz
    CommandExecute $imagetag  $yamldir $imagetgz 
  elif [ $choice -eq 2 ];then
    imagetag=identity/identity_api:latest  
    newtag=identity/identity_api:latest
    yamldir=identity-config/identity_api
    imagetgz=identity-identity_api-latest.tgz
    CommandExecute $imagetag  $yamldir $imagetgz 
  elif [ $choice -eq 3 ];then
    imagetag=identity/identity_db:latest  
    newtag=identity/identity_db:latest
    yamldir=identity-config/identity_db
    imagetgz=identity-identity_db.tgz
    CommandExecute $imagetag  $yamldir $imagetgz 
  elif [ $choice -eq 4 ];then
    imagetag=identity/identity_ui:latest  
    newtag=identity/identity_ui:latest
    yamldir=identity-config/identity_ui
    imagetgz=identity-identity_ui-latest.tgz
    CommandExecute $imagetag  $yamldir $imagetgz 
  else
    imagetag=identity/token_mt:latest  
    newtag=identity/token_mt:latest
    yamldir=identity-config/token_mt
    imagetgz=identity-token_mt-latest.tgz
    CommandExecute $imagetag  $yamldir $imagetgz 
  fi
;;
2)
  UpdatEexpertService
  if [[ $choice != [1-7] ]];then
  echo "Please enter a correct parameter"
  exit 1
  fi
  cd $imagedir/expert
  if [ $choice -eq 1 ];then
    imagetag=expert/expert_api:latest  
    newtag=expert/expert_api:latest
    yamldir=expert-config/expert_api
    imagetgz=expert-expert_api-latest.tgz
    CommandExecute $imagetag  $yamldir $imagetgz 
  elif [ $choice -eq 2 ];then
    imagetag=expert/expert_db:latest  
    newtag=expert/expert_db:latest
    yamldir=expert-config/expert_db
    imagetgz=expert-expert_db-latest.tgz
    CommandExecute $imagetag  $yamldir $imagetgz 
  elif [ $choice -eq 3 ];then
    imagetag=expert/expert_ui:latest  
    newtag=expert/expert_ui:latest
    yamldir=expert-config/expert_ui
    imagetgz=expert-expert_ui-latest.tgz
    CommandExecute $imagetag  $yamldir $imagetgz 
  elif [ $choice -eq 4 ];then
    echo "4"
    imagetag=expert/information_extraction:latest  
    newtag=expert/information_extraction:latest
    yamldir=expert-config/information_extraction
    imagetgz=expert-information_extraction-latest.tgz
    CommandExecute $imagetag  $yamldir $imagetgz 
  elif [ $choice -eq 5 ];then
    echo "5"
    imagetag=expert/intelligence_mt:latest  
    newtag=expert/intelligence_mt:latest
    yamldir=expert-config/intelligence_mt
    imagetgz=expert-intelligence_mt-latest.tgz
    CommandExecute $imagetag  $yamldir $imagetgz 
  elif [ $choice -eq 6 ];then
    echo "6"
    imagetag=expert/intelligence_worker:latest  
    newtag=expert/intelligence_worker:latest
    yamldir=expert-config/intelligence_worker
    imagetgz=expert-intelligence_worker-latest.tgz
    CommandExecute $imagetag  $yamldir $imagetgz 
  else
    imagetag=expert/labeling_ui:latest  
    newtag=expert/labeling_ui:latest
    yamldir=expert-config/labeling_ui
    imagetgz=expert-labeling_ui-latest.tgz
    CommandExecute $imagetag  $yamldir $imagetgz 
  fi
;;
*)
  echo "Please enter a correct parameter"
;;
esac