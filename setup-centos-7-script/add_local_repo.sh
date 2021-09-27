#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

echo "mount local repo"
mkdir /localrepo
mount /dev/cdrom /localrepo # 挂载源所在cd到临时目录
cd /localrepo/
ls

cd /etc/yum.repos.d
ls -l

cat <<EOF > /etc/yum.repos.d/CentOS-Local.repo
[LocalYum]
name=CentOS-Local-7
baseurl=file:///localrepo
enable=1
gpgcheck=1
gpgfile=file:///localrepo/RPM-GPG-KEY-CentOS-7
EOF

cat CentOS-Local.repo

# yum -y clean all
rpm --import /localrepo/RPM-GPG-KEY-CentOS-7
yum -y install yum-utils
echo "add local repo completed"
