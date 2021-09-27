#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

kernel_version=$(uname -r)
target_package_dir=../../centos-packages/$kernel_version/python3

yumdownloader --resolve --destdir=$target_package_dir zlib-devel zlib1g-dev zlib-static zlib bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel
echo "packages are downlowded to directory: $target_package_dir"
ls -l $target_package_dir
