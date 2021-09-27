## 安装 ssh

```
sudo apt-get install openssh-server
service sshd start
```

```
# deb cdrom:[Ubuntu 16.04 LTS _Xenial Xerus_ - Release amd64 (20160420.1)]/ xenial main restricted
deb-src http://archive.ubuntu.com/ubuntu xenial main restricted #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates universe
deb http://mirrors.aliyun.com/ubuntu/ xenial multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-updates multiverse
deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse #Added by software-properties
deb http://archive.canonical.com/ubuntu xenial partner
deb-src http://archive.canonical.com/ubuntu xenial partner
deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted
deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted multiverse universe #Added by software-properties
deb http://mirrors.aliyun.com/ubuntu/ xenial-security universe
deb http://mirrors.aliyun.com/ubuntu/ xenial-security multiverse
```

## 获取 Docker 相关 Package 的版本

```
apt-cache madison docker-ce
apt-cache madison docker-ce-cli
apt-cache madison containerd.io

# docker-ce | 5:18.09.9~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
# docker-ce-cli | 5:18.09.9~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages

# docker-ce | 5:19.03.5~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
# docker-ce-cli | 5:19.03.5~3-0~ubuntu-xenial | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages

# containerd.io |    | https://download.docker.com/linux/ubuntu xenial/stable amd64 Packages
```

## 下载 Docker 18.09

```
cd /var/cache/apt
sudo apt-get install --download-only -y docker-ce=5:18.09.9~3-0~ubuntu-bionic
sudo apt-get install --download-only -y docker-ce-cli=5:18.09.9~3-0~ubuntu-bionic
sudo apt-get install --download-only -y containerd.io=1.2.10-3

mv archives docker_1809
```

## 下载 Docker 19.03

```
sudo apt-get install --download-only -y docker-ce=5:19.03.5~3-0~ubuntu-xenial
```

## 下载 nvidia runtime

```
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update

apt-cache madison nvidia-container-toolkit
apt-cache madison nvidia-docker2

# nvidia-container-toolkit |    1.0.5-1 | https://nvidia.github.io/nvidia-container-runtime/ubuntu16.04/amd64  Packages
# nvidia-docker2 |    2.2.2-1 | https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64  Packages

sudo apt-get install --download-only -y nvidia-container-toolkit=1.0.5-1
sudo apt-get install --download-only -y nvidia-docker2=2.2.2-1
```

## 复制到本地

```
scp -r ran@192.168.1.55:/home/ran/docker_1809 ./resource-ubuntu1604/packages/
scp -r ran@192.168.1.55:/home/ran/docker_1903 ./resource-ubuntu1604/packages/
scp -r ran@192.168.1.55:/home/ran/nvidia-container-toolkit ./resource-ubuntu1604/packages/
scp -r ran@192.168.1.55:/home/ran/nvidia-docker2 ./resource-ubuntu1604/packages/
scp -r ran@192.168.1.55:/home/ran/gcc ./resource-ubuntu1604/packages/
```

## 其他需要的 package

```
cd /var/cache/apt

sudo apt-get install --download-only -y gcc
sudo apt-get install --download-only -y make

mv archives docker_1809
```

scp -r one-box-expert/install.sh ran@192.168.1.55:~/setup/one-box-expert/
scp -r one-box-expert/rm.sh ran@192.168.1.55:~/setup/one-box-expert/
scp -r one-box-expert/save-images.sh ran@192.168.1.55:~/setup/one-box-expert/

scp -r one-box-expert/install.sh demo@192.168.0.104:~/setup/
scp -r one-box-expert/rm.sh demo@192.168.0.104:~/setup/

export http_proxy="http://192.168.0.6:2001";
export HTTP_PROXY="http://192.168.0.6:2001";
export https_proxy="http://192.168.0.6:2001";
export HTTPS_PROXY="http://192.168.0.6:2001"

https://www.ostechnix.com/download-packages-dependencies-locally-ubuntu/
