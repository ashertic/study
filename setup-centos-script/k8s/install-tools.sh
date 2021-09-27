#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

workdir=`pwd`

echo -e "install kubernetes tools"
kernel_version=$(uname -r)
target_package_dir=../../centos-packages/$kernel_version/k8s-1.16.3
cd $target_package_dir
rpm -ivh --replacefiles --replacepkgs *.rpm


echo -e "close and disable firewall"
firewall-cmd --state
systemctl stop firewalld
systemctl disable firewalld
systemctl mask --now firewalld


echo -e "disable swap"
swapoff -a


echo -e "disable SELinux"
# /usr/sbin/sestatus -v 
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
echo -e "\nContent of file /etc/selinux/config"
cat /etc/selinux/config


echo -e "\nContent of file /etc/fstab, please make sure to remove swap record in /etc/fstab manually"
cat /etc/fstab


# for CentOS or RHEL we may need to do below step
update-alternatives --set iptables /usr/sbin/iptables-legacy

cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
vm.swappiness=0
EOF
cat /etc/sysctl.d/k8s.conf
sysctl --system

systemctl restart docker

systemctl enable --now kubelet

echo -e "kubeadm version"
kubeadm version


echo -e "load kubernetes service docker images"
cd $workdir
cd ../../os-setup-common-files/k8s-1.16.3-images

load_images() {
  images=$(ls | grep ".tgz")
  for imgs in $(echo $images); 
  do
    imageFilePath=$imgs
    echo -e "start to load image file: $imageFilePath"

    gunzip -c $imageFilePath | docker load

    if [ $? -ne 0 ]; then
        logger "$imageFilePath load failed."
    else
        logger "$imageFilePath load successfully."
    fi
  done
}

load_images

echo -e "docker info, please makes sure no warning at the end of its output"
docker info
