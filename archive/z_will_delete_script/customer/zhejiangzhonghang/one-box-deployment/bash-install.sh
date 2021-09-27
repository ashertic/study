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


