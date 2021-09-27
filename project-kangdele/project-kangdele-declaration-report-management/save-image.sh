#!/usr/bin/env bash

# docker save swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/intelligence_worker:latest | gzip > expert-intelligence_worker-latest_1.tgz


fullImageTag=swr.cn-north-4.myhuaweicloud.com/meinenghua/declaration/declaration_api:latest
imageTag=declaration/declaration_api:latest
docker save $fullImageTag | gzip > $(echo ${imageTag} | sed "s#/#-#g; s#:#-#g").tgz

fullImageTag=swr.cn-north-4.myhuaweicloud.com/meinenghua/declaration/declaration_ui:latest
imageTag=declaration/declaration_ui:latest
docker save $fullImageTag | gzip > $(echo ${imageTag} | sed "s#/#-#g; s#:#-#g").tgz

fullImageTag=swr.cn-north-4.myhuaweicloud.com/meinenghua/declaration/declaration_db:latest
imageTag=declaration/declaration_db:latest
docker save $fullImageTag | gzip > $(echo ${imageTag} | sed "s#/#-#g; s#:#-#g").tgz

fullImageTag=postgres:11.5-alpine
imageTag=postgres:11.5-alpine
docker save $fullImageTag | gzip > $(echo ${imageTag} | sed "s#/#-#g; s#:#-#g").tgz

fullImageTag=redis:5.0.5-alpine
imageTag=redis:5.0.5-alpine
docker save $fullImageTag | gzip > $(echo ${imageTag} | sed "s#/#-#g; s#:#-#g").tgz