#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

kernel_version=$(uname -r)
target_package_dir=../../centos-packages/$kernel_version/basic
cd $target_package_dir
rpm -ivh --replacefiles --replacepkgs *.rpm
# rpm -ivh  *.rpm --force --nodeps



# echo -e "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/blacklist.conf
# mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.bak
# dracut /boot/initramfs-$(uname -r).img $(uname -r)
# reboot


