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

echocolor2()
{
  log=$1
  echo -e "\e[40;31;1m$log\e[0m"
}

workdir=`pwd`

resourcesBaseDir=../resources-centos/packages/
kubernetesPackagesDir=$resourcesBaseDir/kubernetes-packages

resourceCommonBaseDir=../resources-common
kubernetesImagesDir=$resourceCommonBaseDir/kubernetes-images

echocolor "install kubernetes tools"
cd $kubernetesPackagesDir
rpm -ivh --replacefiles --replacepkgs *.rpm

# for CentOS or RHEL we may need to do below step
update-alternatives --set iptables /usr/sbin/iptables-legacy

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
vm.swappiness=0
EOF
cat /etc/sysctl.d/k8s.conf
sysctl --system

systemctl enable --now kubelet

echocolor "kubeadm version"
kubeadm version
cd $workdir

echocolor "load kubernetes related docker images"
cd $kubernetesImagesDir

load_images() {
  images=$(ls | grep ".tgz")
  for imgs in $(echo $images); 
  do
    imageFilePath=$workdir/$kubernetesImagesDir/$imgs
    echocolor "start to load image file: $imageFilePath"

    gunzip -c $imageFilePath | docker load

    if [ $? -ne 0 ]; then
        logger "$imageFilePath load failed."
    else
        logger "$imageFilePath load successfully."
    fi
  done
}

load_images
cd $workdir
