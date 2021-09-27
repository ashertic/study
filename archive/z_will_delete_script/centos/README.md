# 重要提示

1. 以下步骤，有的需要在 root 模式下执行，有的需要在普通用户模式下执行，请注意相应的说明。
1. 以下步骤，有的是在 kubernetes 的 control plane 节点，也就是 master 节点执行，有的是在 worker 节点执行，请注意相应的说明。
1. 以下步骤是针对 CentOS7.4 以上版本的 Minimal Server Installation 的环境的，不一定完全适用于其他的环境。如果是 Ubuntu，则需要使用 Ubuntu 的 package 安装包。

# 配置 CentOS 系统环境

## 配置 CentOS Kubernetes Control Plain 节点(Master 节点)

```
# 进入root模式，并切换到centos安装目录下
sudo -i
cd /home/ran/setup/centos/

# 安装基本的package
./1-install-basic-packages.sh

# 禁用默认的nouveau显卡驱动
./2-disable-nouveau-driver.sh
# 这脚本执行成功会自动重启系统，需要重新连接

# 等待重启后，重新进入root模式，并切换到centos安装目录下
sudo -i
cd /home/ran/setup/centos/

# 安装nvidia显卡驱动
./3-install-nvidia-driver.sh

# 禁用firewall，swap，SELinux
./4-prepare-env.sh

# 如果需要查看本机的IP地址，使用如下命令:
```

ip addr | grep inet

```

# 安装docker, nvidia-docker 2, kubernetes tools
# 创建kubernetes cluster以及local registry
./5-install.sh <master machine ip> master

exit
```

## 配置 CentOS Kubernetes Worker 节点

```
# 进入root模式，并切换到centos安装目录下
sudo -i
cd /home/ran/setup/centos/

# 安装基本的package
./1-install-basic-packages.sh

# 禁用默认的nouveau显卡驱动
./2-disable-nouveau-driver.sh
# 这脚本执行成功会自动重启系统，需要重新连接

# 等待重启后，重新进入root模式，并切换到centos安装目录下
sudo -i
cd /home/ran/setup/centos/

# 安装nvidia显卡驱动
./3-install-nvidia-driver.sh

# 禁用firewall，swap，SELinux
./4-prepare-env.sh

# 安装docker, nvidia-docker 2, kubernetes tools
./5-install.sh <master machine ip> worker

exit
```

## 以下命令需要退出 root 模式，在普通用户模式下执行(只有 Kubernetes Control Plane 节点需要执行)

```
# 配置kubectl，允许普通用户模式下可用
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 配置kubectl命令行补全
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
```

## 配置 docker 允许普通用户模式下可以使用 docker 命令

```
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

## 将 worker 节点添加到已有的 kubernetes cluster 中

```
# 在kubernetes control plane节点上执行下面的命令获取token
kubeadm token list

# 在kubernetes control plane节点上执行下面的命令获取hash
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'
```

获取了上面的 token 和 hash 之后，在要加入到 cluster 的 worker 节点机器上执行如下命令，替换掉其中的参数

```
sudo kubeadm join <ip of kubernetes master>:6443 --token <token> --discovery-token-ca-cert-hash sha256:<hash>
```

# 清理 Kubernetes 集群

```
sudo kubeadm reset -f
sudo rm -r -f $HOME/.kube

sudo docker container stop $(sudo docker ps -q)
sudo docker ps -a
sudo docker container rm $(sudo docker ps -a -q)
sudo docker ps -a

sudo docker image rm -f $(sudo docker images -q)
sudo docker volume prune -f

sudo rm -r -f /etc/sysctl.d/k8s.conf

iptables --flush
```
