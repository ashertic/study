#!/usr/bin/env bash

envFilePath=$1
if [ -z $envFilePath ]; then
  echo "please provide environment configure file path"
  exit 1
fi

echo "load configuraiton file"
while IFS= read oneConfigure
do
  # echo "$oneConfigure"

  array=(${oneConfigure//=/ })
  parameterName=${array[0]}
  nameLength=${#parameterName}
  start=$(expr $nameLength + 1)
  parameterValue=${oneConfigure: start}

  # echo "$parameterName"
  # echo "$parameterValue"

  case "$parameterName" in
    'dockerImageTag')
      dockerImageTag=$parameterValue
      ;;
    'dockerImageBaseUrl')
      dockerImageBaseUrl=$parameterValue
      ;;
    'loggingNodeSelector')
      loggingNodeSelector=$parameterValue
      ;;
    'identityNodeSelector')
      identityNodeSelector=$parameterValue
      ;;
    'expertNodeSelector')
      expertNodeSelector=$parameterValue
      ;;
    'dialogNodeSelector')
      dialogNodeSelector=$parameterValue
      ;;
    'informationExtractionNodeSelector')
      informationExtractionNodeSelector=$parameterValue
      ;;
    'informationExtractionNodeSelector2')
      informationExtractionNodeSelector2=$parameterValue
      ;;       
    'masterIP')
      masterIP=$parameterValue
      ;;
    'mountDataPath')
      mountDataPath=$parameterValue
      ;;
    'informationExtractionSoftKey')
      informationExtractionSoftKey=$parameterValue
      ;;
    'vueAppTenant')
      vueAppTenant=$parameterValue
      ;;
    'vueAppPrimaryColor')
      vueAppPrimaryColor=$parameterValue
      ;;
    'appCookieDomainName')
      appCookieDomainName=$parameterValue
      ;;
    'homepageUIUrl')
      homepageUIUrl=$parameterValue
      ;;
    'identityUIUrl')
      identityUIUrl=$parameterValue
      ;;
    'expertUIUrl')
      expertUIUrl=$parameterValue
      ;;
    'labelUIUrl')
      labelUIUrl=$parameterValue
      ;;
    'identityAPIUrl')
      identityAPIUrl=$parameterValue
      ;;
    'expertAPIUrl')
      expertAPIUrl=$parameterValue
      ;;
    'labelAPIUrl')
      labelAPIUrl=$parameterValue
      ;;
    'expertUIVueAppName')
      expertUIVueAppName=$parameterValue
      ;;
    'labelingUIVueAppName')
      labelingUIVueAppName=$parameterValue
      ;;
    'informationExtractionTrainingPeriod')
      informationExtractionTrainingPeriod=$parameterValue
      ;;
    'vueAppFooterText')
      vueAppFooterText=$parameterValue
      ;;
    'intelligenceWorkerModels')
      intelligenceWorkerModels=$parameterValue
      ;;
    'intelligenceMTTaskTimeout')
      intelligenceMTTaskTimeout=$parameterValue
      ;;
  esac
done <"$envFilePath"

echo "dockerImageTag=$dockerImageTag"
echo "dockerImageBaseUrl=$dockerImageBaseUrl"
echo "loggingNodeSelector=$loggingNodeSelector"
echo "identityNodeSelector=$identityNodeSelector"
echo "expertNodeSelector=$expertNodeSelector"
echo "dialogNodeSelector=$dialogNodeSelector"
echo "informationExtractionNodeSelector=$informationExtractionNodeSelector"
echo "informationExtractionNodeSelector2=$informationExtractionNodeSelector2"
echo "masterIP=$masterIP"
echo "mountDataPath=$mountDataPath"
echo "informationExtractionSoftKey=$informationExtractionSoftKey"
echo "vueAppTenant=$vueAppTenant"
echo "vueAppPrimaryColor=$vueAppPrimaryColor"
echo "appCookieDomainName=$appCookieDomainName"
echo "homepageUIUrl=$homepageUIUrl"
echo "identityUIUrl=$identityUIUrl"
echo "expertUIUrl=$expertUIUrl"
echo "labelUIUrl=$labelUIUrl"
echo "identityAPIUrl=$identityAPIUrl"
echo "expertAPIUrl=$expertAPIUrl"
echo "labelAPIUrl=$labelAPIUrl"
echo "expertUIVueAppName=$expertUIVueAppName"
echo "labelingUIVueAppName=$labelingUIVueAppName"
echo "informationExtractionTrainingPeriod=$informationExtractionTrainingPeriod"
echo "vueAppFooterText=$vueAppFooterText"
echo "intelligenceWorkerModels=$intelligenceWorkerModels"
echo "intelligenceMTTaskTimeout=$intelligenceMTTaskTimeout"

dockerImageTagPlaceholder=IMAGE_VERSION_PLACEHOLDER
dockerImageBaseUrlPlaceholder=IMAGE_BASEURL_PLACEHOLDER
loggingNodeSelectorPlaceholder=LOGGING_NODE_SELECTOR_PLACEHOLDER
identityNodeSelectorPlaceholder=IDENTITY_NODE_SELECTOR_PLACEHOLDER
expertNodeSelectorPlaceholder=EXPERT_NODE_SELECTOR_PLACEHOLDER
dialogNodeSelectorPlaceholder=DIALOG_NODE_SELECTOR_PLACEHOLDER
informationExtractionNodeSelectorPlaceholder=INFORMATION_EXTRACTION_NODE_SELECTOR_PLACEHOLDER
informationExtractionNodeSelectorPlaceholder2=INFORMATION_EXTRACTION_NODE_SELECTOR2_PLACEHOLDER
masterIPPlaceholder=MASTER_IP_PLACEHOLDER
mountDataPathPlaceholder=MOUNT_DATA_PATH_PLACEHOLDER
informationExtractionSoftKeyPlaceholder=INFORMATION_EXTRACTION_SOFT_KEY_PLACEHOLDER
vueAppTenantPlaceholder=VUE_APP_TENANT_PLACEHOLDER
vueAppPrimaryColorPlaceholder=VUE_APP_PRIMARY_COLOR_PLACEHOLDER
appCookieDomainNamePlaceholder=APP_COOKIE_DOMAIN_NAME_PLACEHOLDER
homepageUIUrlPlaceholder=HOMEPAGE_UI_URL_PLACEHOLDER
identityUIUrlPlaceholder=IDENTITY_UI_URL_PLACEHOLDER
expertUIUrlPlaceholder=EXPERT_UI_URL_PLACEHOLDER
labelUIUrlPlaceholder=LABEL_UI_URL_PLACEHOLDER
identityAPIUrlPlaceholder=IDENTITY_API_URL_PLACEHOLDER
expertAPIUrlPlaceholder=EXPERT_API_URL_PLACEHOLDER
labelAPIUrlPlaceholder=LABEL_API_URL_PLACEHOLDER
expertUIVueAppNamePlaceholder=EXPERT_UI_VUE_APP_NAME_PLACEHOLDER
labelingUIVueAppNamePlaceholder=LABELING_UI_VUE_APP_NAME_PLACEHOLDER
informationExtractionTrainingPeriodPlaceholder=INFORMATION_EXTRACTION_TRAINING_PERIOD_PLACEHOLDER
vueAppFooterTextPlaceholder=VUE_APP_FOOTER_TEXT_PLACEHOLDER
intelligenceWorkerModelsPlaceholder=INTELLIGENCE_WORKER_MODELS_PLACEHOLDER
intelligenceMTTaskTimeoutPlaceholder=INTELLIGENCE_MT_TASK_TIMEOUT_PLACEHOLDER

replace(){
  targetDir=$1
  
  for file in `ls -a $1`
  do
      if [[ $file == .* ]]; then
        # echo "ignore $file"
        :
      elif [ -d $1"/"$file ]; then
        if [[ $file != '.' && $file != '..' ]]; then
          replace $1"/"$file
        fi
      else
        suffix="${file##*.}"
        if [[ $suffix = "yaml" ]]; then
          echo $1"/"$file
          targetFile=$1"/"$file

          outputDir=$(echo "$1" | sed "s?-template??")
          mkdir -p $outputDir
          newFile=$outputDir/$file

          sed -e "s?$dockerImageTagPlaceholder?$dockerImageTag?g" \
          -e "s?$dockerImageBaseUrlPlaceholder?$dockerImageBaseUrl?g" \
          -e "s?$loggingNodeSelectorPlaceholder?$loggingNodeSelector?g" \
          -e "s?$identityNodeSelectorPlaceholder?$identityNodeSelector?g" \
          -e "s?$expertNodeSelectorPlaceholder?$expertNodeSelector?g" \
          -e "s?$dialogNodeSelectorPlaceholder?$dialogNodeSelector?g" \
          -e "s?$masterIPPlaceholder?$masterIP?g" \
          -e "s?$mountDataPathPlaceholder?$mountDataPath?g" \
          -e "s?$informationExtractionSoftKeyPlaceholder?$informationExtractionSoftKey?g" \
          -e "s?$informationExtractionNodeSelectorPlaceholder?$informationExtractionNodeSelector?g" \
          -e "s?$informationExtractionNodeSelectorPlaceholder2?$informationExtractionNodeSelector2?g" \
          -e "s?$vueAppTenantPlaceholder?$vueAppTenant?g" \
          -e "s?$vueAppPrimaryColorPlaceholder?$vueAppPrimaryColor?g" \
          -e "s?$appCookieDomainNamePlaceholder?$appCookieDomainName?g" \
          -e "s?$homepageUIUrlPlaceholder?$homepageUIUrl?g" \
          -e "s?$identityUIUrlPlaceholder?$identityUIUrl?g" \
          -e "s?$expertUIUrlPlaceholder?$expertUIUrl?g" \
          -e "s?$labelUIUrlPlaceholder?$labelUIUrl?g" \
          -e "s?$identityAPIUrlPlaceholder?$identityAPIUrl?g" \
          -e "s?$expertAPIUrlPlaceholder?$expertAPIUrl?g" \
          -e "s?$labelAPIUrlPlaceholder?$labelAPIUrl?g" \
          -e "s?$expertUIVueAppNamePlaceholder?$expertUIVueAppName?g" \
          -e "s?$labelingUIVueAppNamePlaceholder?$labelingUIVueAppName?g" \
          -e "s?$informationExtractionTrainingPeriodPlaceholder?$informationExtractionTrainingPeriod?g" \
          -e "s?$vueAppFooterTextPlaceholder?$vueAppFooterText?g" \
          -e "s?$intelligenceWorkerModelsPlaceholder?$intelligenceWorkerModels?g" \
          -e "s?$intelligenceMTTaskTimeoutPlaceholder?$intelligenceMTTaskTimeout?g" \
          $targetFile > $newFile
        else
          # echo "ignore $file"
          :
        fi
      fi
  done
}

replace ./expert-config-template
replace ./dialog-config-template
replace ./identity-config-template
replace ./logging-config-template
