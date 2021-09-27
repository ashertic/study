#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

echo -e "\nclose and disable firewall"
firewall-cmd --state
systemctl stop firewalld
systemctl disable firewalld
systemctl mask --now firewalld

echo -e "\ndisable SELinux"
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

echo -e "\nContent of file /etc/selinux/config"
cat /etc/selinux/config

sysctl net.bridge.bridge-nf-call-iptables=1
sysctl net.bridge.bridge-nf-call-ip6tables=1

checkFileIncludeString() {
  targetFile=$1
  searchString=$2

  # echo "$searchString"

  grep "$searchString" "$targetFile" > /dev/null
  if [ $? -eq 0 ]; then
    return 0 # found
  else
    return 1 # not found
  fi
}

content='net.bridge.bridge-nf-call-iptables'
checkFileIncludeString "/etc/sysctl.conf" "$content"
if [ $? -eq 1 ]; then
  echo 'net.bridge.bridge-nf-call-iptables = 1' >> /etc/sysctl.conf
fi

content='net.bridge.bridge-nf-call-ip6tables'
checkFileIncludeString "/etc/sysctl.conf" "$content"
if [ $? -eq 1 ]; then
  echo 'net.bridge.bridge-nf-call-ip6tables = 1' >> /etc/sysctl.conf
fi

echo -e "\n content of /etc/sysctl.conf:"
cat /etc/sysctl.conf

systemctl daemon-reload
systemctl restart docker
echo -e "\ndocker service status"
systemctl status docker.service

docker info
