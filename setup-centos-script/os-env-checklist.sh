#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echo -e "\n uname -a"
uname -a

echo -e "\n rpm --query centos-release"
rpm --query centos-release

echo -e "\n rpm --query redhat-release"
rpm --query redhat-release

echo -e "\n cat /etc/centos-release"
cat /etc/centos-release

echo -e "\n cat /etc/redhat-release"
cat /etc/redhat-release

echo -e "\n cat /etc/system-release"
cat /etc/system-release

echo -e "\n cat /etc/os-release"
cat /etc/os-release

echo -e "\n cat /etc/fstab"
cat /etc/fstab

echo -e "\n df -TH"
df -TH

echo -e "\n nvidia-smi"
nvidia-smi

echo -e "\n docker info"
docker info

echo -e "\n docker version"
docker version

echo -e "\n cat /etc/docker/daemon.json"
cat /etc/docker/daemon.json

echo -e "\n docker ps -a"
docker ps -a

echo -e "\n lshw -numeric -C display"
lshw -numeric -C display

echo -e "\n lsmod | grep nouveau"
lsmod | grep nouveau

echo -e "\n kubeadm version"
kubeadm version
