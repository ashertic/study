
### Disable nouveau driver in CentOS
```
# we need this to make kubectl autocomplete work correctly in bash shell 
sudo yum install -y bash-completion

# show gpu information
sudo yum install lshw -y
lshw -numeric -C display
lsmod | grep nouveau

# disable nouveau gpu driver
sudo -i
cat /etc/modprobe.d/blacklist.conf
echo -e "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/blacklist.conf
mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.bak
dracut /boot/initramfs-$(uname -r).img $(uname -r)
reboot

# check is nouveau driver is disabled
lsmod | grep nouveau

# install kernel delvel and headers, also gcc, we need them when compile nvidia driver from source code
uname -r
kernel_version=$(uname -r)
echo $kernel_version

yum info kernel-devel
yum info kernel-headers

sudo yum install kernel-devel-$kernel_version
# it is same as: sudo yum install kernel-devel-3.10.0-1062.el7.x86_64
sudo yum install kernel-headers-$kernel_version
# it is same as: yum install kernel-headers-3.10.0-1062.el7.x86_64
# you may get similar result as above by running this command, but not understand how it works now: yum -y install gcc kernel-devel "kernel-devel-uname-r == $(uname -r)"

yum info kernel-devel
yum info kernel-headers

sudo yum -y install gcc

yum info kernel-devel
yum info kernel-headers

# compile and install nvidia driver
cd ~/setup/resources-common/nvidia-driver
sudo sh ./NVIDIA-Linux-x86_64-440.36.run --silent
nvidia-smi


# install docker
cd ~/setup/resources-centos/packages/docker-1809-packages

# sudo rpm -ivh checkpolicy-2.5-8.el7.x86_64.rpm
# sudo rpm -ivh libcgroup-0.41-21.el7.x86_64.rpm
# sudo rpm -ivh setools-libs-3.3.8-4.el7.x86_64.rpm
# sudo rpm -ivh libsemanage-python-2.5-14.el7.x86_64.rpm
# sudo rpm -ivh audit-libs-python-2.8.5-4.el7.x86_64.rpm
# sudo rpm -ivh python-IPy-0.75-6.el7.noarch.rpm
# sudo rpm -ivh policycoreutils-python-2.5-33.el7.x86_64.rpm
# sudo rpm -ivh container-selinux-2.107-3.el7.noarch.rpm
# sudo rpm -ivh containerd.io-1.2.10-3.2.el7.x86_64.rpm
# sudo rpm -ivh docker-ce-cli-19.03.5-3.el7.x86_64.rpm
# sudo rpm -ivh docker-ce-18.09.9-3.el7.x86_64.rpm
# use below one command to install everything
sudo rpm -ivh --replacefiles --replacepkgs *.rpm


sudo systemctl enable docker.service
sudo systemctl start docker
sudo docker version

# enable to use docker with normal user mode
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker version

# install nvidia docker2
cd ~/setup/resources-centos/packages/nvidia-docker2-packages
# sudo rpm -ivh libnvidia-container1-1.0.5-1.x86_64.rpm
# sudo rpm -ivh libnvidia-container-tools-1.0.5-1.x86_64.rpm
# sudo rpm -ivh nvidia-container-toolkit-1.0.5-2.x86_64.rpm
# sudo rpm -ivh nvidia-container-runtime-3.1.4-1.x86_64.rpm
# sudo rpm -ivh nvidia-docker2-2.2.2-1.noarch.rpm
# use below one command to install everything
sudo rpm -ivh --replacefiles --replacepkgs *.rpm

# execute other shell script

# install kubernets
cd ~/setup/resources-centos/packages/kubernetes-packages
# sudo rpm -ivh libnetfilter_cthelper-1.0.0-10.el7_7.1.x86_64.rpm
# sudo rpm -ivh libnetfilter_cttimeout-1.0.0-6.el7_7.1.x86_64.rpm
# sudo rpm -ivh libnetfilter_queue-1.0.2-2.el7_2.x86_64.rpm
# sudo rpm -ivh conntrack-tools-1.4.4-5.el7_7.2.x86_64.rpm
# sudo rpm -ivh socat-1.7.3.2-2.el7.x86_64.rpm
# sudo rpm -ivh 14bfe6e75a9efc8eca3f638eb22c7e2ce759c67f95b43b16fae4ebabde1549f3-cri-tools-1.13.0-0.x86_64.rpm
# sudo rpm -ivh fd6465355a85b8ddbc0b2e7cb073e3a40160c7c359576b86e9b8eca0a2d7805b-kubectl-1.16.3-0.x86_64.rpm
# sudo rpm -ivh 8a0e2b605c7a616d7cb72c25c9058b2327e41d869046c7c6cb3930f10a3dc012-kubelet-1.16.3-0.x86_64.rpm 548a0dcd865c16a50980420ddfa5fbccb8b59621179798e6dc905c9bf8af3b34-kubernetes-cni-0.7.5-0.x86_64.rpm
# sudo rpm -ivh b45a63e77d36fc7e1ef84f1cd2f7b84bccf650c8248191a37d20c69564d8b8df-kubeadm-1.16.3-0.x86_64.rpm
sudo rpm -ivh --replacefiles --replacepkgs *.rpm

sudo systemctl enable kubelet.service

cd ~/setup/resources-common/kubernetes-images
gunzip -c calico-cni-v3.10.1.tgz | sudo docker load
gunzip -c calico-kube-controllers-v3.10.1.tgz | sudo docker load
gunzip -c calico-node-v3.10.1.tgz | sudo docker load
gunzip -c calico-pod2daemon-flexvol-v3.10.1.tgz | sudo docker load
gunzip -c k8s.gcr.io-coredns-1.6.2.tgz | sudo docker load
gunzip -c k8s.gcr.io-etcd-3.3.15-0.tgz | sudo docker load
gunzip -c k8s.gcr.io-kube-apiserver-v1.16.3.tgz | sudo docker load
gunzip -c k8s.gcr.io-kube-controller-manager-v1.16.3.tgz | sudo docker load
gunzip -c k8s.gcr.io-kube-proxy-v1.16.3.tgz | sudo docker load
gunzip -c k8s.gcr.io-kube-scheduler-v1.16.3.tgz | sudo docker load
gunzip -c k8s.gcr.io-pause-3.1.tgz | sudo docker load
gunzip -c nginx-ingress-controller.tgz | sudo docker load
gunzip -c nvidia-k8s-device-plugin-1.0.0-beta4.tgz | sudo docker load


# change kubernete config

# disable firewall: https://linuxize.com/post/how-to-stop-and-disable-firewalld-on-centos-7/
sudo firewall-cmd --state
sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo systemctl mask --now firewalld
sudo swapoff -a


# https://blog.csdn.net/zhydream77/article/details/81909939
echo "1" >/proc/sys/net/bridge/bridge-nf-call-iptables

kubeadm init --apiserver-advertise-address $ip --apiserver-bind-port 6443 --kubernetes-version 1.16.3 --pod-network-cidr $POD_CIDR
export KUBECONFIG=/etc/kubernetes/admin.conf

```


# 参考链接
https://blog.51cto.com/zorro/1904484
https://linuxcluster.wordpress.com/2018/10/08/nvidia-drivers-issues-unable-to-find-the-kernel-source-tree/

