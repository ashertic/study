#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echocolor()
{
  log=$1
  echo -e "\n\e[40;31;1m$log\e[0m\n"
}

resourcesBaseDir=../resources-centos/packages
nvidiaDocker2PackagesDir=$resourcesBaseDir/nvidia-docker2-packages

cd $nvidiaDocker2PackagesDir
rpm -ivh --replacefiles --replacepkgs *.rpm
# rpm -ivh libnvidia-container1-1.0.5-1.x86_64.rpm
# rpm -ivh libnvidia-container-tools-1.0.5-1.x86_64.rpm
# rpm -ivh nvidia-container-toolkit-1.0.5-2.x86_64.rpm
# rpm -ivh nvidia-container-runtime-3.1.4-1.x86_64.rpm
# rpm -ivh nvidia-docker2-2.2.2-1.noarch.rpm


systemctl restart docker
sleep 10

echocolor "install nvidia-docker2 successfully, docker version is:"
docker version
