# declaration_report_management
最新代码在cyy分支上

### 本地如何起环境

本地一共需要起四个内容, 参考local-box.sh
1. db
2. api
3. ui
4. intelligence-mt

* 一键启动全部 sh local-box.sh your_ip

保证自己有以下数据


1. /data/kangdele-declaration/intelligence/intelligence-mt-data
2. /data/kangdele-declaration/intelligence/intelligence-mt-wheel
3. /data/kangdele-declaration/intelligence/intelligence-mt-resource
4. /data/kangdele-declaration/intelligence/intelligence-mt-models
5. /data/kangdele-declaration/intelligence/intelligence-mt-configs


#### db
如果本地已经有db service, 那么不需要起database service, 只需要将pgPort和pgPassword替换为自己本地的就行

#### api
按照 local-box中的启动
#### ui
按照 local-box中的启动
#### intelligence-mt
1. 把代码中server/restful_server.py中的第77行的加密注释了
2. 在intelligence-mt目录下 docker build --no-cache -t intelligence_mt .
3. 用local-box中被注释的一段启动intelligence-mt docker
