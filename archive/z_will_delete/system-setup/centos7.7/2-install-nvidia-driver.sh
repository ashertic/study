#!/usr/bin/env bash
if [[ $EUID -ne 0 ]];then
  echo "This script must be run as root" 1>&2
  exit 1
fi

workdir=`pwd`

lsmod | grep nvidia
if [  $? -eq 0 ];then
  echo -e "The nvidia driver has been installed"
else
  echo -e "\ninstall kernel packages"
  cd $workdir/packages/kernel-packages
  rpm -ivh --replacefiles --replacepkgs *.rpm
  echo -e "\ninstall gcc packages"
  cd $workdir/packages/gcc-packages
  rpm -ivh --replacefiles --replacepkgs *.rpm
  echo -e "\ninstall nvidia driver"
  cd $workdir/nvidia-driver-P
  bash NVIDIA-Linux-x86_64-440.33.01.run --silent
  echo -e "\nhere is nvidia gpu card information after installed nvidia gpu driver"
  nvidia-smi
fi	
