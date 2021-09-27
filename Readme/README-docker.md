# 查看 images 并且生成可以删除的文本

```
docker images | awk '{ print "docker image rm " $1 ":" $2 }'
docker images | sort -k 1 | awk '{ print "docker image rm " $1 ":" $2 }'
```

# 华为云容器镜像

docker login -u cn-north-4@GEVBQJCVF7ELO6E08LKL -p b176220c854d2610e28ce77448f7c10ef2a95d2c5029e869fd73a497cf79b4b0 swr.cn-north-4.myhuaweicloud.com


docker login -u cn-north-4@IEMJQQ1GEOZBP3QE0U5Y -p b27fe0087f9c9c268e105cac939d49c163f674e8d2165db0acf7ac75b80bab4b swr.cn-north-4.myhuaweicloud.com

