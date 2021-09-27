#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

kernel_version=$(uname -r)
target_package_dir=../../centos-packages/$kernel_version/docker

yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# 清理以防寻找Repro出错
# yum -y clean all
# sleep 30
# yum list available

# 下面的命令和显示多种不同的版本
# yum list docker-ce --showduplicates | sort -r
# yum list docker-ce-cli --showduplicates | sort -r
# yum list containerd.io --showduplicates | sort -r

yumdownloader --resolve --destdir=$target_package_dir docker-ce-18.09.9-3.el7 docker-ce-cli-18.09.9-3.el7 containerd.io-1.2.6-3.3.el7 libseccomp-2.3.1-3
echo "packages are downlowded to directory: $target_package_dir"
ls -l $target_package_dir
