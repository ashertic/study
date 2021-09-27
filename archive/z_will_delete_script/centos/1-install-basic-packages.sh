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
basicPackagesDir=$resourcesBaseDir/basic-packages

cd $basicPackagesDir
rpm -ivh lshw-B.02.18-13.el7.x86_64.rpm
rpm -ivh bash-completion-2.1-6.el7.noarch.rpm

# sudo yum install -y lshw bash-completion

echocolor "install basic packages"
