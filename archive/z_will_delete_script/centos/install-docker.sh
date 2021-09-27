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
dockerPackagesDir=$resourcesBaseDir/docker-1809-packages

cd $dockerPackagesDir
rpm -ivh --replacefiles --replacepkgs *.rpm
# rpm -ivh checkpolicy-2.5-8.el7.x86_64.rpm
# rpm -ivh libcgroup-0.41-21.el7.x86_64.rpm
# rpm -ivh setools-libs-3.3.8-4.el7.x86_64.rpm
# rpm -ivh libsemanage-python-2.5-14.el7.x86_64.rpm
# rpm -ivh audit-libs-python-2.8.5-4.el7.x86_64.rpm
# rpm -ivh python-IPy-0.75-6.el7.noarch.rpm
# rpm -ivh policycoreutils-python-2.5-33.el7.x86_64.rpm
# rpm -ivh container-selinux-2.107-3.el7.noarch.rpm
# # rpm -ivh containerd.io-1.2.6-3.3.el7.x86_64.rpm
# rpm -ivh containerd.io-1.2.10-3.2.el7.x86_64.rpm
# # rpm -ivh docker-ce-cli-18.09.9-3.el7.x86_64.rpm
# rpm -ivh docker-ce-cli-19.03.5-3.el7.x86_64.rpm
# rpm -ivh docker-ce-18.09.9-3.el7.x86_64.rpm

# start for: PWC installation
# yum install  policycoreutils-python libcgroup libseccomp
# rpm -ivh container-selinux-2.107-3.el7.noarch.rpm containerd.io-1.2.10-3.2.el7.x86_64.rpm docker-ce-18.09.9-3.el7.x86_64.rpm docker-ce-cli-19.03.5-3.el7.x86_64.rpm
# end for: PWC installation

systemctl enable docker.service
systemctl start docker

echocolor "install docker successfully, docker version is:"
docker version
