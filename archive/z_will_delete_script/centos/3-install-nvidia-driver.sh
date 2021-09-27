#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

workdir=`pwd`
resourcesBaseDir=../resources-centos/packages
kernelPackagesDir=$resourcesBaseDir/kernel-packages
gccPackagesDir=$resourcesBaseDir/gcc-packages

# for CentOS 7, GTX 1080Ti & 2080Ti
nvidiaDriverDir=../resources-common/nvidia-driver/GTX-1080Ti-2080Ti

# for CentOS 7, Tesla P40 

lsmod | grep nouveau
uname -r

cd $kernelPackagesDir
rpm -ivh --replacefiles --replacepkgs *.rpm
cd $workdir

cd $gccPackagesDir
rpm -ivh --replacefiles --replacepkgs *.rpm
cd $workdir

# if in RHEL 7.4+ OS, you can make local repro from ISO file and 
# then execute below commands to complete above installation work:
# kernel_version=$(uname -r)
# echo $kernel_version
# sudo yum install kernel-devel-$kernel_version
# sudo yum install kernel-headers-$kernel_version
# sudo yum -y install gcc
# yum info kernel-devel
# yum info kernel-headers

cd $nvidiaDriverDir
sh ./NVIDIA-Linux-x86_64-440.36.run --silent
nvidia-smi
