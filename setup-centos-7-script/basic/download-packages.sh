#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

kernel_version=$(uname -r)
target_package_dir=../../centos-packages/$kernel_version/basic

yumdownloader --resolve --destdir=$target_package_dir bash-completion kernel-devel-$kernel_version kernel-headers-$kernel_version gcc lshw lsmod device-mapper-persistent-data lvm2
echo "packages are downlowded to directory: $target_package_dir"
ls -l $target_package_dir

