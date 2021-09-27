#!/usr/bin/env bash

# must provide from command line
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

ip=$1
if [ -z $ip ]; then
  echo "please provide master machine IP"
  exit 1
fi

# parameter if not provide will ask
targetEnv=$2
targetMode=$3
targetAction=$4
targetServiceGroup=$5
isConfirmOnImageUpdate=$6

# optional parameter
isSlience=$7

timeout=60

checkTargetEnv(){
  case "$targetEnv" in
    '1')
      targetEnv="local_staging"
      return 0
      ;;
    '2')
      targetEnv="cloud"
      return 0
      ;;
    '3')
      targetEnv="pwc"
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

readTargetEnv(){
  echo -e "\nPlease select targetEnv value from below options:"
  echo "  1. local_staging"
  echo "  2. cloud"
  echo "  3. pwc"
  echo -n "Please give the option number and press [ENTER] in $timeout seconds: "
  read -t $timeout choice
  return $choice
}

checkTargetEnv 
if [[ $? != 0 ]]
then
  readTargetEnv
  targetEnv=$?
  checkTargetEnv
  if [[ $? != 0 ]]
  then
    echo "targetEnv=$targetEnv is invalid, so exit this script" 1>&2
    exit 1
  fi
fi


checkTargetMode(){
  case "$targetMode" in
    '1')
      targetMode="production-public"
      return 0
      ;;
    '2')
      targetMode="production-private"
      return 0
      ;;
    '3')
      targetMode="development"
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

readTargetMode(){
  echo -e "\nPlease select targetMode value from below options:"
  echo "  1. production-public"
  echo "  2. production-private"
  echo "  3. development"
  echo -n "Please give the option number and press [ENTER] in $timeout seconds: "
  read -t $timeout choice
  return $choice
}

checkTargetMode 
if [[ $? != 0 ]]
then
  readTargetMode
  targetMode=$?
  checkTargetMode
  if [[ $? != 0 ]]
  then
    echo "targetMode=$targetMode is invalid, so exit this script" 1>&2
    exit 1
  fi
fi


checkTargetAction(){
  case "$targetAction" in
    '1')
      targetAction="create"
      return 0
      ;;
    '2')
      targetAction="update"
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

readTargetAction(){
  echo -e "\nPlease select targetAction value from below options:"
  echo "  1. create"
  echo "  2. update"
  echo -n "Please give the option number and press [ENTER] in $timeout seconds: "
  read -t $timeout choice
  return $choice
}

checkTargetAction 
if [[ $? != 0 ]]
then
  readTargetAction
  targetAction=$?
  checkTargetAction
  if [[ $? != 0 ]]
  then
    echo "targetAction=$targetAction is invalid, so exit this script" 1>&2
    exit 1
  fi
fi


checkTargetServiceGroup(){
  case "$targetServiceGroup" in
    '1')
      targetServiceGroup="all"
      return 0
      ;;
    '2')
      targetServiceGroup="identity"
      return 0
      ;;
    '3')
      targetServiceGroup="expert"
      return 0
      ;;
    '4')
      targetServiceGroup="dialog"
      return 0
      ;;
    '5')
      targetServiceGroup="identity_expert"
      return 0
      ;;
    '6')
      targetServiceGroup="identity_dialog"
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

readTargetServiceGroup(){
  echo -e "\nPlease select targetServiceGroup value from below options:"
  echo "  1. all"
  echo "  2. identity"
  echo "  3. expert"
  echo "  4. dialog"
  echo "  5. identity + expert"
  echo "  6. identity + dialog"
  echo -n "Please give the option number and press [ENTER] in $timeout seconds: "
  read -t $timeout choice
  return $choice
}

checkTargetServiceGroup
if [[ $? != 0 ]]
then
  readTargetServiceGroup
  targetServiceGroup=$?
  checkTargetServiceGroup
  if [[ $? != 0 ]]
  then
    echo "targetServiceGroup=$targetServiceGroup is invalid, so exit this script" 1>&2
    exit 1
  fi
fi


checkIsConfirmOnImageUpdate(){
  case "$isConfirmOnImageUpdate" in
    '1')
      isConfirmOnImageUpdate="yes"
      return 0
      ;;
    '2')
      isConfirmOnImageUpdate="no"
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

readIsConfirmOnImageUpdate(){
  echo -e "\nPlease select isConfirmOnImageUpdate value from below options:"
  echo "  1. yes"
  echo "  2. no"
  echo -n "Please give the option number and press [ENTER] in $timeout seconds: "
  read -t $timeout choice
  return $choice
}

checkIsConfirmOnImageUpdate
if [[ $? != 0 ]]
then
  readIsConfirmOnImageUpdate
  isConfirmOnImageUpdate=$?
  checkIsConfirmOnImageUpdate
  if [[ $? != 0 ]]
  then
    echo "isConfirmOnImageUpdate=$isConfirmOnImageUpdate is invalid, so exit this script" 1>&2
    exit 1
  fi
fi


echo -e "\n$USER, here are parameters you have choosed:"
echo "  targetEnv=$targetEnv"
echo "  targetMode=$targetMode"
echo "  targetAction=$targetAction"
echo "  targetServiceGroup=$targetServiceGroup"
echo "  isConfirmOnImageUpdate=$isConfirmOnImageUpdate"

if [[ $isSlience == 'yes' ]]
then
  echo "You have selected slience mode, so we will move on automatically in 10 seconds"
  sleep 10
else
  echo "Please confirm above information are correct in $timeout seconds"
  echo -n "Input 'yes' or 'no' then press [ENTER]: "
  read -t $timeout confirm
  if [[ $confirm = "y" || $confirm = "yes" || $confirm = "Yes" || $confirm = "YES" ]]
  then
    echo "You have confirmed, will start to work in 3 seconds"
    sleep 3
  else
    echo "You haven't confirmed, will exit script immediately"
    exit 1
  fi
fi

# start to do the real work

echo "generate yaml configuration for $targetEnv"

if [ $targetEnv = 'local_staging' ]
then

  ./generate-config-from-template.sh ./env-config/local_staging.env

elif [ $targetEnv = 'pwc' ]
then

  ./generate-config-from-template.sh ./env-config/pwc.env
  
fi


export KUBECONFIG=/etc/kubernetes/admin.conf

if [ $targetMode = "development" ]
then
  echo "pull and save minerva images"
  case "$targetServiceGroup" in
    'all')
      ./save-minerva-images.sh ./image-list/minerva-all-images.txt
      ;;
    'identity')
      ./save-minerva-images.sh ./image-list/minerva-identity-images.txt
      ;;
    'expert')
      ./save-minerva-images.sh ./image-list/minerva-expert-images.txt
      ;;
    'dialog')
      ./save-minerva-images.sh ./image-list/minerva-dialog-images.txt
      ;;
  esac
fi

if [ $targetAction = "create" ]
then
  # prepare kubernetes namespace
  # create registry secret or ngix certificate
  ./prepare.sh $targetMode $ip

  if [[ $targetMode = "development" || $targetMode = "production-private" ]]
  then
    # need to load and push 3rd party images to private image registry
    echo "load thirdparty images and push to private registry"
    ./install-thirdparty-images.sh $ip
  fi
fi

if [[ $targetMode = "development" || $targetMode = "production-private" ]]
then
  # load minerva images from file and push to private image registry
  echo "load minerva images"
  case "$targetServiceGroup" in
    'all')
      ./install-minerva-images.sh $ip ./image-list/minerva-all-images.txt
      ;;
    'identity')
      ./install-minerva-images.sh $ip ./image-list/minerva-identity-images.txt
      ;;
    'expert')
      ./install-minerva-images.sh $ip ./image-list/minerva-expert-images.txt
      ;;
    'dialog')
      ./install-minerva-images.sh $ip ./image-list/minerva-dialog-images.txt
      ;;
    'identity_expert')
      ./install-minerva-images.sh $ip ./image-list/minerva-identity-images.txt
      ./install-minerva-images.sh $ip ./image-list/minerva-expert-images.txt
      ;;
    'identity_dialog')
      ./install-minerva-images.sh $ip ./image-list/minerva-identity-images.txt
      ./install-minerva-images.sh $ip ./image-list/minerva-dialog-images.txt
      ;;
  esac
fi

if [ $targetAction = "create" ]
then
  # deploy logging service
  echo "deploy logging services"
  ./install-logging-service.sh
fi

if [[ $targetServiceGroup = "all" || $targetServiceGroup = "identity" || $targetServiceGroup = "identity_expert" || $targetServiceGroup = "identity_dialog" ]]
then
  if [ $targetAction = "update" ]
  then
    echo "delete identity services"
    ./rm-identity.sh
    sleep 30
    echo "identity services deployment state:"
    kubectl get deployments.apps -n identity
  fi

  echo "deploy identity services"
  ./install-identity-service.sh $targetMode
  sleep 30
  echo "identity services deployment state:"
  kubectl get deployments.apps -n identity

  if [ $targetAction = "create" ]
  then
    echo "initialize identity db"
    ./install-identity-db.sh $ip
  fi
fi

if [[ $targetServiceGroup = "all" || $targetServiceGroup = "expert" || $targetServiceGroup = "identity_expert" ]]
then
  if [ $targetAction = "update" ]
  then
    echo "delete expert services"
    ./rm-expert.sh $targetEnv
    sleep 30
    echo "expert services deployment state:"
    kubectl get deployments.apps -n expert
  fi

  echo "deploy expert services"
  ./install-expert-service.sh $targetMode $targetEnv
  sleep 30
  echo "expert services deployment state:"
  kubectl get deployments.apps -n expert

  if [ $targetAction = "create" ]
  then
    echo "initialize expert db"
    ./install-expert-db.sh $ip
  fi
fi

if [[ $targetServiceGroup = "all" || $targetServiceGroup = "dialog" || $targetServiceGroup = "identity_dialog" ]]
then
  if [ $targetAction = "update" ]
  then
    echo "delete dialog services"
    ./rm-dialog.sh
    sleep 30
    echo "dialog services deployment state:"
    kubectl get deployments.apps -n dialog
  fi

  echo "deploy dialog services"
  ./install-dialog-service.sh $targetMode
  sleep 30
  echo "dialog services deployment state:"
  kubectl get deployments.apps -n dialog

  if [ $targetAction = "create" ]
  then
    echo "initialize dialog db"
    ./install-dialog-db.sh $ip
  fi
fi
