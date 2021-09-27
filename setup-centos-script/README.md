# 获取对应的安装包

1. 安装一台干净的对应 Centos 版本的机器，升级内容到对应的内核版本
1. 将本目录下的所有东西都原封不动的复制到新安装的机器，存放在一个目录下，比如 Home 目录
1. 远程连接到新安装的机器，在命令行下移到 setup-centos-script 目录下，执行脚本 download-packages.sh
1. 安装包下载完毕后，会放在和 setup-centos-script 目录同级的 centos-packages 目录的对应内核版本的目录下，将整个这个目录复制到自己的机器，作为私有部署的安装包保留

下载 packages 的过程中，会安装 docker，这样在下载 nvidia-docker 的 packages 就不会再下载其他非指定版本的 docker 安装包了

# 在目标机器上安装

```
scp -r centos-packages root@192.168.1.36:/data/
scp -r os-setup-common-files root@192.168.1.36:/data/
scp -r setup-centos-script root@192.168.1.36:/data/
scp -r deploy-script root@192.168.1.36:/data/

scp -r project-pwc-ds root@192.168.1.35:/data/
scp -r project-pwc-chuangxinzhongxin root@192.168.1.35:/data/
scp -r project-suzhoushenpiju root@192.168.1.172:/data/

scp -r project-taipingjinke root@192.168.1.36:/data/
scp -r project-changning root@192.168.1.36:/data/

remote： mkdir ~/os-setup-common-files
cd os-setup-common-files
scp -r python3 root@192.168.1.55:~/os-setup-common-files/
scp -r nvidia-driver root@192.168.1.55:~/os-setup-common-files/
scp -r common-docker-images root@192.168.1.55:~/os-setup-common-files/
scp -r k8s-1.16.3-images root@192.168.1.55:~/os-setup-common-files/

```

# 安装顺序

1. 安装 basic
1. 手动安装 Nvidia 显卡驱动，具体安装方法见其他的文档: sh ./NVIDIA-Linux-x86_64-440.36.run --silent
1. 安装 docker, 安装完成后，执行 post-docker-installation 脚本关闭系统防火墙，修改 SELinux，修改 IP forward 配置，使 docker 可以正常工作
1. 安装 nvidia docker runtime
1. 如果是 K8S 集群模式部署，在所有节点上安装 K8S 的基础安装包和命令行工具，k8s/install-tools.sh
1. 然后在 K8S 集群的 Master 节点上配置私有的 Docker 镜像服务，k8s/install-private-docker-registry-master.sh
1. 然后在 K8S 集群的 Master 节点上创建 K8S 集群，k8s/install-master-node.sh
1. 然后在 K8S 集群的其他 Worker 节点上配置 Docker 配置文件，允许访问 Master 节点上的私有镜像服务，并将 Worker 节点加入到 Master 节点所在的 K8S 集群
1. 安装 python3

# 针对 K8S 集群

## root 模式下使用 kubectl 命令需要导出配置文件

```
export KUBECONFIG=/etc/kubernetes/admin.conf
```

## 给集群的节点添加 nodeTag，K8S 部署集群时，我们使用 nodetag 来控制服务部署到哪里

```
kubectl get nodes
kubectl label nodes node1 node-tag=gpu-001
kubectl label nodes node2 node-tag=gpu-002
```
