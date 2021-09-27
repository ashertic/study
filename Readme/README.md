
## 保存docker image到文件




scp -r /Users/ran/code/mnvai/offline-deployment/ root@192.168.0.69: ~/setup

scp -r ./images ubuntu@192.168.1.172:/data/setup
scp -r ./minerva ubuntu@192.168.1.172:/data/setup
scp -r ./resources ubuntu@192.168.1.172:/data/setup
scp -r ./ubuntu ubuntu@192.168.1.172:/data/setup
scp ./replace-mount-path.sh ubuntu@192.168.1.172:/data/setup
scp ./replace-ip.sh ubuntu@192.168.1.172:/data/setup


scp ./images/minerva/expert/information-extraction.tar ubuntu@192.168.1.172:/data/setup/images/minerva/expert
scp ./images/minerva/expert/expert-labeling_ui-latest.tgz ubuntu@192.168.1.172:/data/setup/images/minerva/expert

scp ./minerva/initialize-expert-db.sh ubuntu@192.168.1.172:/data/setup/minerva

scp ./minerva/expert/labeling-ui.yaml ubuntu@192.168.1.172:/data/setup/minerva/expert
scp ./minerva/expert/information-extraction-primary.yaml ubuntu@192.168.1.172:/data/setup/minerva/expert



scp ./minerva/expert/information-extraction-data.yaml ubuntu@192.168.1.172:/data/setup/minerva/expert
scp ./minerva/expert/information-extraction-gpu0.yaml ubuntu@192.168.1.172:/data/setup/minerva/expert
scp ./minerva/expert/information-extraction-cpu0.yaml ubuntu@192.168.1.172:/data/setup/minerva/expert

# 机器列表

机器IP |用途 | 说明
--- | --- | ---
192.168.1.149 | Rancher Master

# 本地测试环境 192.168.1.149

## Setup Rancher Master需要拷贝的文件
```
scp -r ./ubuntu ubuntu@192.168.1.149:/data/setup
scp -r ./resources ubuntu@192.168.1.149:/data/setup
scp -r ./images ubuntu@192.168.1.149:/data/setup
scp -r ./minerva ubuntu@192.168.1.149:/data/setup
scp ./replace-mount-path.sh ubuntu@192.168.1.149:/data/setup
scp ./replace-ip.sh ubuntu@192.168.1.149:/data/setup
```

scp ./minerva/imagelist/minerva-images.txt ubuntu@192.168.1.149:/data/setup/minerva/imagelist
scp ./minerva/save-minerva-images-new.sh ubuntu@192.168.1.149:/data/setup/minerva




## Rancher Admin UI
https://192.168.1.149:8443

token: token-q56bt:xxxwk4tpmhh94nc4shbb8t2mrqkl75nrrwhn5b6tjwzqtsm7lxpj6g






# CentOS 
## 设置网络桥接到本地的网络
ip link
dhclient enp0s3

## 显示IP地址
ip addr show
ssh root@192.168.0.69

## 安装Docker
https://ahmermansoor.blogspot.com/2019/02/install-docker-ce-on-offline-centos-7-machine.html
https://docs.docker.com/install/linux/docker-ce/centos/


yum install -y epel-release.noarch
yum-config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo


### 下载docker RPM包
containerd.io-1.2.6-3.3.el7.x86_64.rpm
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm

docker-ce-18.09.8-3.el7.x86_64.rpm
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-18.09.8-3.el7.x86_64.rpm

docker-ce-cli-18.09.8-3.el7.x86_64.rpm
https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-18.09.8-3.el7.x86_64.rpm

TODO: 不同的centos的版本可能对应不同的安装包，需要解决

### 安装
sudo yum install /home/setup/offline-deployment/resources/centos-software/docker/containerd.io-1.2.6-3.3.el7.x86_64.rpm
TODO: 需要上网下载一些依赖，这个需要预先下载好
sudo yum install /home/setup/offline-deployment/resources/centos-software/docker/docker-ce-cli-18.09.8-3.el7.x86_64.rpm
sudo yum install /home/setup/offline-deployment/resources/centos-software/docker/docker-ce-18.09.8-3.el7.x86_64.rpm

启动Docker
sudo systemctl start docker

查看Docker服务情况和重启
systemctl status docker.service
systemctl daemon-reload
sleep 2
systemctl restart docker
sleep 2
systemctl status docker.service

## 创建本地的yum repo
https://www.cnblogs.com/zhangningbo/p/3685778.html
https://blog.51cto.com/7308310/2339182?source=dra 


yum install yum-utils createrepo


```

yum install createrepo

yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages nano
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages ifconfig


yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages libxml2-python
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages python-deltarpm
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages deltarpm
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages python-kitchen
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages createrepo
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages python-chardet
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages yum-utils


yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages 
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages 
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages 
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages 
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages 
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages 
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages 
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages 
yumdownloader --destdir /repository/centos/7/extras/x86_64/Packages 
```