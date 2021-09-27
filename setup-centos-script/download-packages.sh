#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

yum install -y yum-utils

workdir=`pwd`

cd ./basic
./download-packages.sh

cd $workdir/python3
./download-packages.sh

cd $workdir/k8s
./download-packages.sh

cd $workdir/docker
./download-packages.sh

echo "install docker, so when download nvidia-docker won't download wrong docker version package again"
cd $workdir/docker
./install.sh

cd $workdir/nvidia-docker
./download-packages.sh

echo -e "\ndownload packages completed"
