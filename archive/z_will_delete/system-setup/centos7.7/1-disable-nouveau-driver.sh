#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

workdir=`pwd`

cd $workdir/packages/basic-packages
rpm -ivh --replacefiles --replacepkgs *.rpm

echo -e "\nbelow is gpu card information:"
lshw -numeric -C display

echo -e "\nbelow is opensource gpu driver information"
lsmod | grep nouveau

# # TODO: 需要添加判断语句，如果系统已经禁用了开源驱动，就不需要执行下面的流程
# echo -e "\ndisable opensource gpu driver and then reboot, it will take several minutes, please wait"
# cat /etc/modprobe.d/blacklist.conf
# echo -e "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/blacklist.conf
# mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.bak
# dracut /boot/initramfs-$(uname -r).img $(uname -r)
# reboot
