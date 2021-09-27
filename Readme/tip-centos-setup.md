# CentOS 7 获取安装包

yumdownloader在下载时，即使系统已经安装了该package，仍然会下载.但是如果该package是依赖package，已经安装了，就不会被下载
```

sudo yumdownloader --resolve --destdir=/home/ran/packages/basic-packages lshw
sudo yumdownloader --resolve --destdir=/home/ran/packages/basic-packages bash-completion
sudo yumdownloader --resolve --destdir=/home/ran/packages/kernel-packages kernel-devel-3.10.0-1062.el7.x86_64
sudo yumdownloader --resolve --destdir=/home/ran/packages/kernel-packages kernel-headers-3.10.0-1062.el7.x86_64
sudo yumdownloader --resolve --destdir=/home/ran/packages/gcc-packages gcc

### RHEL 7.3
kernel_version=$(uname -r)
echo $kernel_version
yumdownloader --resolve kernel-devel-$kernel_version kernel-headers-$kernel_version
yumdownloader --resolve gcc

# tools
yumdownloader --resolve lshw bash-completion
yumdownloader --resolve yum-utils
yumdownloader --resolve device-mapper-persistent-data lvm2

# docker
yumdownloader --resolve docker-ce-18.09.9-3.el7 docker-ce-cli-18.09.9-3.el7 containerd.io-1.2.6-3.3.el7

# nvidia docker runtime


sudo yumdownloader --resolve --destdir=/home/ran/packages/kernel-packages kernel-devel-3.10.0-514.el7.x86_64
sudo yumdownloader --resolve --destdir=/home/ran/packages/kernel-packages kernel-headers-3.10.0-514.el7.x86_64
sudo yumdownloader --resolve --destdir=/home/ran/packages/gcc-packages gcc



sudo yumdownloader --resolve gcc

# sudo yumdownloader --resolve --destdir=/home/ran/packages/development-tools-packages "@Development Tools"


yum list docker-ce --showduplicates | sort -r
yum list docker-ce-cli --showduplicates | sort -r
yum list containerd.io --showduplicates | sort -r

sudo yum install docker-ce-18.09.9-3.el7 --downloaddir=/home/ran/docker-1809-packages --downloadonly
sudo yum install docker-ce-cli-18.09.9-3.el7 --downloaddir=/home/ran/docker-1809-packages --downloadonly
sudo yum install containerd.io-1.2.6-3.3.el7 --downloaddir=/home/ran/docker-1809-packages --downloadonly

sudo yumdownloader --resolve --destdir=/home/ran/packages/docker-1809-packages audit-libs-2.8.5-4.el7.x86_64
sudo yumdownloader --resolve --destdir=/home/ran/packages/docker-1809-packages policycoreutils selinux-policy selinux-policy-base selinux-policy-targeted
sudo yumdownloader --resolve --destdir=/home/ran/packages/docker-1809-packages libseccomp libsemanage libselinux libsepol
sudo yumdownloader --resolve --destdir=/home/ran/packages/docker-1809-packages libselinux-utils

# remove i686 packages if there are
sudo rm -r -f *.i686.rpm 

yum list nvidia-container-toolkit --showduplicates | sort -r
yum list nvidia-docker2 --showduplicates | sort -r

sudo yum install nvidia-container-toolkit-1.0.5-2 --downloaddir=/home/ran/packages/nvidia-container-toolkit-packages --downloadonly
sudo yumdownloader --resolve --destdir=/home/ran/packages/nvidia-docker2-packages nvidia-docker2-2.2.2-1

sudo yumdownloader --resolve --destdir=/home/ran/packages/kubernetes-packages --disableexcludes=kubernetes kubelet kubeadm kubectl
sudo yumdownloader --resolve --destdir=/home/ran/packages/missing libnetfilter_conntrack



```

3. 压缩和解压缩
sudo tar cfz nvidia-docker2-packages.tar.gz nvidia-docker2-packages
sudo tar cfz docker-18-09-packages.tar.gz docker-18-09-packages
sudo tar cfz docker-19-03-packages.tar.gz docker-19-03-packages
sudo tar cfz kubernetes-1-16-packages.tar.gz kubernetes-1-16-packages
sudo tar cfz nvidia-container-toolkit-packages.tar.gz nvidia-container-toolkit-packages

# 参考链接
1. https://www.ostechnix.com/download-rpm-package-dependencies-centos/
1. https://blog.csdn.net/njdxtj/article/details/46341755