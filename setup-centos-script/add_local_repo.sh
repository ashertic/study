#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

echo "mount local repo"
mkdir /temprepo	# 创建一个临时repo目录
mount /dev/cdrom /temprepo # 挂载源所在cd到临时目录
cd /temprepo/ # 进入源所在目录，查看内容
ls # 显示所有内容

cd /etc/yum.repos.d
ls -l

cat <<EOF > /etc/yum.repos.d/CentOS-Local.repo
[LocalYum]
name=CentOS-Local-7
baseurl=file:///temprepo
enable=1
gpgcheck=1
gpgfile=file:///temprepo/RPM-GPG-KEY-CentOS-7
EOF

cat CentOS-Local.repo

yum clean all
yum list 
rpm --import /temprepo/RPM-GPG-KEY-CentOS-7
yum install yum-utils -y

echo "add local repo completed"
