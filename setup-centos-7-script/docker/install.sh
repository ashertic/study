#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

kernel_version=$(uname -r)
target_package_dir=../../centos-packages/$kernel_version/docker
cd $target_package_dir
rpm -ivh --replacefiles --replacepkgs *.rpm
systemctl enable docker.service
systemctl start docker
docker info
docker version
