prod-k8s-0515_for_debug.json是之前为了留后门用的, 允许使用email方式登录，而不是PWC内部的vProfile方式登录

2021.08.12已经更新到最新，和PWC本地的生产环境机器的一致

2021.08.16本地的测试环境如下内容已经和PWC那边部署的内容一致：
1. identity，expert，information extraction，logging，第三方的image 的所有需要运行的images都和PWC部署版本一致了
2. expert下的 configs， modules， resource， wheels已经与PWC那边部署的内容一致

还没有比较的部分包括：
数据库内容
数据库相关的db image





本地部署的时候，只需要部署如下的部分服务：
1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,21,22,23,24,31

