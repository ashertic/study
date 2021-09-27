#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

kernel_version=$(uname -r)
target_package_dir=../../centos-packages/$kernel_version/k8s-1.16.3

# refer to: https://developer.aliyun.com/mirror/kubernetes

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# 清理以防寻找Repro出错
yum -y clean all 
yum list available

# 下面的命令和显示多种不同的版本  
# yum list kubelet --showduplicates | sort -r
# yum list kubeadm --showduplicates | sort -r
# yum list kubectl --showduplicates | sort -r

yumdownloader --resolve --destdir=$target_package_dir kubelet-1.16.3-0 kubeadm-1.16.3-0 kubectl-1.16.3-0
echo "packages are downlowded to directory: $target_package_dir"
