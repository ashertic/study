#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

kernel_version=$(uname -r)
target_package_dir=../../centos-packages/$kernel_version/nvidia-docker

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | sudo tee /etc/yum.repos.d/nvidia-docker.repo

# 清理以防寻找Repro出错
# yum -y clean all
# sleep 30
# yum list available

# 下面的命令和显示多种不同的版本
# yum list nvidia-container-toolkit --showduplicates | sort -r
# yum list nvidia-docker2 --showduplicates | sort -r

yum install -y nvidia-container-toolkit-1.0.5-2 --downloaddir=$target_package_dir --downloadonly
yumdownloader --resolve --destdir=$target_package_dir nvidia-docker2-2.2.2-1
echo "packages are downlowded to directory: $target_package_dir"
ls -l $target_package_dir
