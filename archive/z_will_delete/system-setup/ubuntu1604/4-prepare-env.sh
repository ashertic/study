#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# close and disable firewall
firewall-cmd --state
systemctl stop firewalld
systemctl disable firewalld
systemctl mask --now firewalld

# disable swap
swapoff -a

# Disable SELinux
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

echo -e "\nContent of file /etc/selinux/config"
cat /etc/selinux/config

echo -e "\nContent of file /etc/fstab"
cat /etc/fstab
