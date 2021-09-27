# 下载需要的安装包
1. 使用下面的命令查看可用的目标软件的版本，请查阅kubernete和docker的官方文档，以添加kubernete和docker的repository，然后才可以执行下面的命令
```
apt-cache madison docker-ce
apt-cache madison docker-ce-cli
apt-cache madison containerd.io

apt-cache madison nvidia-container-toolkit
apt-cache madison nvidia-docker2

apt-cache madison kubelet
apt-cache madison kubeadm
apt-cache madison kubectl

apt-cache madison gcc
apt-cache madison build-essential
```

2. 将下列的目标文件下载的本地, 具体的原理可以参考文章： https://www.ostechnix.com/download-packages-dependencies-locally-ubuntu/
```
sudo apt-get install --download-only -y kubelet=1.16.3-00
sudo apt-get install --download-only -y kubeadm=1.16.3-00
sudo apt-get install --download-only -y kubectl=1.16.3-00


sudo apt-get install --download-only -y docker-ce=5:19.03.5~3-0~ubuntu-bionic
sudo apt-get install --download-only -y docker-ce-cli=5:19.03.5~3-0~ubuntu-bionic
sudo apt-get install --download-only -y containerd.io=1.2.10-3

sudo apt-get install --download-only -y nvidia-container-toolkit=1.0.5-1

sudo apt-get install --download-only -y nvidia-docker2=2.2.2-1

sudo apt-get install --download-only -y docker-ce=5:18.09.9~3-0~ubuntu-bionic
sudo apt-get install --download-only -y docker-ce-cli=5:18.09.9~3-0~ubuntu-bionic
sudo apt-get install --download-only -y containerd.io=1.2.10-3

sudo apt-get install --download-only -y gcc=4:7.3.0-3ubuntu2

sudo apt-get install --download-only -y build-essential=12.4ubuntu1
```


3. 压缩和解压缩
```
tar cfz kubernete-ubuntu-1804-setup.tar.gz kubernete-ubuntu-1804-setup
tar -zxvf kubernete-ubuntu-1804-setup.tar.gz

tar cfz gcc-packages.tar.gz gcc-packages
tar cfz build-essential-packages.tar.gz build-essential-packages
```



scp ubuntu:129.226.113.202:/home/ubuntu/archives.tar.gz ./
scp ./archives.tar.gz ubuntu@192.168.1.35:~/

scp ./archives.tar.gz ubuntu@13.78.52.234:~/

scp ubuntu@13.78.52.234:~/kubernete-ubuntu-1804-setup.tar.gz ./
scp ubuntu@129.226.113.202:~/kubernete-ubuntu-1804-setup.tar.gz ./

scp ubuntu@129.226.113.202:~/docker-18-09-packages.tar.gz ./resources
scp ubuntu@129.226.113.202:~/docker-19-03-packages.tar.gz ./resources
scp ubuntu@129.226.113.202:~/nvidia-container-toolkit-packages.tar.gz ./resources
scp ubuntu@129.226.113.202:~/kubernetes-1-16-packages.tar.gz ./resources

scp -r ubuntu@129.226.113.202:~/nvidia-docker2-packages ./resources

scp ran@104.215.58.17:~/packages.tar.gz .
scp ubuntu@129.226.113.202:~/packages.tar.gz .

scp -r ran@10.0.0.9:/home/ran/packages/ ./

# 安装显卡驱动

## 查看显卡型号
sudo lshw -numeric -C display
sudo lspci -vnn | grep VGA

sudo nvidia-smi

## Disable nouveau driver
```
  sudo bash -c "echo blacklist nouveau > /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
  sudo bash -c "echo options nouveau modeset=0 >> /etc/modprobe.d/blacklist-nvidia-nouveau.conf"
  sudo cat /etc/modprobe.d/blacklist-nvidia-nouveau.conf
  sudo update-initramfs -u
  sudo reboot -nf
```

```
  安装 gcc, build-essential
  sudo rpm -Uvh *.rpm
  rpm -ivh *.rpm
  sh ./NVIDIA-Linux-x86_64-440.36.run
  nvidia-smi
```

```
watch   -n  1   nvidia-smi
```


## 安装

# 参考链接
1. https://docs.docker.com/install/linux/docker-ce/ubuntu/
1. https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
1. https://docs.docker.com/compose/install/
1. https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
1. https://cloud.tencent.com/developer/article/1479625
1. https://my.oschina.net/u/2306127/blog/1922542?spm=a2c4e.10696291.0.0.44b519a4LndJmf
1. https://docs.projectcalico.org/v3.10/getting-started/kubernetes/installation/calico
1. https://github.com/kubernetes/kubeadm/issues/338
1. https://medium.com/@juniarto.samsudin/ip-address-changes-in-kubernetes-master-node-11527b867e88
1. https://linuxconfig.org/how-to-disable-nouveau-nvidia-driver-on-ubuntu-18-04-bionic-beaver-linux
1. https://www.mvps.net/docs/install-nvidia-drivers-ubuntu-18-04-lts-bionic-beaver-linux/
1. https://kubernetes.io/docs/tasks/manage-gpus/scheduling-gpus/
1. https://github.com/NVIDIA/nvidia-docker
1. https://github.com/NVIDIA/k8s-device-plugin
1. https://www.ostechnix.com/download-rpm-package-dependencies-centos/
1. https://linuxcluster.wordpress.com/2018/10/08/nvidia-drivers-issues-unable-to-find-the-kernel-source-tree/
1. https://blog.51cto.com/zorro/1904484
1. https://blog.csdn.net/njdxtj/article/details/46341755    挂载ISO作为RHEL本地Repro
1. https://www.digitalocean.com/community/tutorials/how-to-create-a-sudo-user-on-centos-quickstart    CentOS创建Sudo User
1. https://docs.docker.com/install/linux/linux-postinstall/    Work need to be done after install Docker in Linux

kubeadm init --apiserver-advertise-address 10.254.100.101 --apiserver-bind-port 6443 --kubernetes-version 1.14.1 --pod-network-cidr 10.244.0.0/16





https://docs.projectcalico.org/v3.10/getting-started/kubernetes/installation/calico


POD_CIDR="10.96.0.0/12" \
sed -i -e "s?192.168.0.0/16?$POD_CIDR?g" calico.yaml



export fullImageTag=k8s.gcr.io/kube-proxy:v1.16.3
sudo docker save "$fullImageTag" | gzip > $(echo "$fullImageTag" | sed "s#/#-#g; s#:#-#g").tgz

export fullImageTag=k8s.gcr.io/kube-apiserver:v1.16.3
sudo docker save "$fullImageTag" | gzip > $(echo "$fullImageTag" | sed "s#/#-#g; s#:#-#g").tgz

export fullImageTag=k8s.gcr.io/kube-controller-manager:v1.16.3
sudo docker save "$fullImageTag" | gzip > $(echo "$fullImageTag" | sed "s#/#-#g; s#:#-#g").tgz

export fullImageTag=k8s.gcr.io/kube-scheduler:v1.16.3
sudo docker save "$fullImageTag" | gzip > $(echo "$fullImageTag" | sed "s#/#-#g; s#:#-#g").tgz

export fullImageTag=k8s.gcr.io/etcd:3.3.15-0
sudo docker save "$fullImageTag" | gzip > $(echo "$fullImageTag" | sed "s#/#-#g; s#:#-#g").tgz

export fullImageTag=k8s.gcr.io/coredns:1.6.2
sudo docker save "$fullImageTag" | gzip > $(echo "$fullImageTag" | sed "s#/#-#g; s#:#-#g").tgz

export fullImageTag=k8s.gcr.io/pause:3.1
sudo docker save "$fullImageTag" | gzip > $(echo "$fullImageTag" | sed "s#/#-#g; s#:#-#g").tgz

export fullImageTag=calico/node:v3.10.1
sudo docker save "$fullImageTag" | gzip > $(echo "$fullImageTag" | sed "s#/#-#g; s#:#-#g").tgz

export fullImageTag=calico/cni:v3.10.1
sudo docker save "$fullImageTag" | gzip > $(echo "$fullImageTag" | sed "s#/#-#g; s#:#-#g").tgz

export fullImageTag=calico/kube-controllers:v3.10.1
sudo docker save "$fullImageTag" | gzip > $(echo "$fullImageTag" | sed "s#/#-#g; s#:#-#g").tgz

export fullImageTag=calico/pod2daemon-flexvol:v3.10.1
sudo docker save "$fullImageTag" | gzip > $(echo "$fullImageTag" | sed "s#/#-#g; s#:#-#g").tgz

export fullImageTag=registry:2
sudo docker save "$fullImageTag" | gzip > $(echo "$fullImageTag" | sed "s#/#-#g; s#:#-#g").tgz

sudo swapoff -a
sudo iptables -F

sudo kubeadm init --apiserver-advertise-address 192.168.1.35 --apiserver-bind-port 6443 --kubernetes-version 1.16.3 --pod-network-cidr 10.96.0.0/12

```
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

```
POD_CIDR="10.96.0.0/12" \
sed -i -e "s?192.168.0.0/16?$POD_CIDR?g" calico.yaml

kubectl apply -f calico.yaml




sudo kubeadm join 192.168.1.35:6443 --token 0f58ix.v3cwnfyn8o476vqm --discovery-token-ca-cert-hash sha256:2be61b9c95a76a34b5d4501c0bd6380a79d9e7709fc7a03fc2a6f3c0ed087c30
```

archives.tar.gz
calico.yaml

```
sudo gunzip -c ./calico-cni-v3.10.1.tgz | sudo docker load
sudo gunzip -c ./calico-kube-controllers-v3.10.1.tgz | sudo docker load
sudo gunzip -c ./calico-node-v3.10.1.tgz | sudo docker load
sudo gunzip -c ./calico-pod2daemon-flexvol-v3.10.1.tgz | sudo docker load
sudo gunzip -c ./k8s.gcr.io-coredns-1.6.2.tgz | sudo docker load
sudo gunzip -c ./k8s.gcr.io-etcd-3.3.15-0.tgz | sudo docker load
sudo gunzip -c ./k8s.gcr.io-kube-apiserver-v1.16.3.tgz | sudo docker load
sudo gunzip -c ./k8s.gcr.io-kube-controller-manager-v1.16.3.tgz | sudo docker load
sudo gunzip -c ./k8s.gcr.io-kube-proxy-v1.16.3.tgz | sudo docker load
sudo gunzip -c ./k8s.gcr.io-kube-scheduler-v1.16.3.tgz | sudo docker load
sudo gunzip -c ./k8s.gcr.io-pause-3.1.tgz | sudo docker load
```



```
sudo -i
cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl daemon-reload
sudo systemctl restart docker
sudo systemctl status docker.service
```

# CentOS挂载新硬盘

https://segmentfault.com/a/1190000008007157


fdisk -l
fdisk /dev/sdb
mkfs.ext4 /dev/sdb1

mkdir /data
mount /dev/sdb1 /data
df -h

blkid /dev/sdb1

vi /etc/fstab

UUID=918c8b4a-c909-4ba0-b1fb-7624482b516e /data ext4    defaults        1 2

  Installing : python-chardet-2.2.1-3.el7.noarch                                                                                                                                                                                          1/4
  Installing : python-kitchen-1.1.1-5.el7.noarch                                                                                                                                                                                          2/4
  Installing : libxml2-python-2.9.1-6.el7_2.3.x86_64                                                                                                                                                                                      3/4
  Installing : yum-utils-1.1.31-52.el7.noarch




scp -r ran@104.215.58.17:/home/ran/packages/missing/ .
scp -r ubuntu@129.226.113.202:/home/ubuntu/missing/ .

scp -r /Users/ran/code/mnvai/offline-deployment/resources-centos/packages/missing/ ran@10.0.0.9:/home/ran/setup/resources-centos/packages/docker-1809-packages/


scp -r ran@10.0.0.9:/home/ran/setup/resources-centos/packages/docker-1809-packages ./docker-1809-packages-new
scp -r ran@10.0.0.9:/home/ran/setup/resources-centos/packages/nvidia-docker2-packages ./nvidia-docker2-packages

scp -r /Users/ran/code/mnvai/offline-deployment/resources-centos/packages/kubernetes-packages/ ran@10.0.0.9:/home/ran/setup/resources-centos/packages


[root@node2 expert]# cat /etc/selinux/config
# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=enforcing
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted





# 挂载本地U盘作为repro
sudo -i
mkdir /media/rhel7
fdisk -l
mount /dev/sdc1 /media/rhel7
mount /dev/sdb /media/rhel7

vi /etc/yum.repos.d/rhel7.repo

[LocalYum]
name=rhel7
baseurl=file:///media/rhel7
enable=1
gpgcheck=1
gpgfile=file:///media/rhel7/RPM-GPG-KEY-redhat-release

gpgfile=file:///media/rhel7/RPM-GPG-KEY-CentOS-7

 yum clean all

 yum list available

 rpm --import /media/rhel7/RPM-GPG-KEY-redhat-release
 rpm --import /media/rhel7/RPM-GPG-KEY-CentOS-7

 journalctl -xeu kubelet
 systemctl status kubelet -l
 cat /var/lib/kubelet/kubeadm-flags.env


 # 安装GUI
 ```
 yum groupinstall "X Window System" 
 
 ```


 0 2 * * * /bin/bash /home/ran/setup/minerva-kubernetes/crontab-daily-refresh.sh







https://cnshaappulv043.asia.pwcinternal.com/
https://cnshaappulv043.asia.pwcinternal.com/account





/data/nginx
config
log

sudo docker run -it -p 80:80 -p 443:443  -v /data/nginx/log:/var/log/nginx nginx:latest

sudo docker run --name nginx -d -p 80:80 -p 443:443  -v /data/nginx/config/nginx.conf:/etc/nginx/nginx.conf  -v /data/nginx/log:/var/log/nginx nginx:latest

sudo docker run --name nginx -d --network host  -v /data/nginx/config/nginx.conf:/etc/nginx/nginx.conf  -v /data/nginx/log:/var/log/nginx nginx:latest


scp ran@10.0.0.9:/home/ran/setup/images/minerva/expert/expert-expert_api-latest.tgz .
scp ran@10.0.0.9:/home/ran/setup/images/minerva/expert/expert-expert_db-latest.tgz .
scp ran@10.0.0.9:/home/ran/setup/images/minerva/expert/expert-expert_ui-latest.tgz .
scp ran@10.0.0.9:/home/ran/setup/images/minerva/expert/expert-intelligence_mt-latest.tgz .


ip=192.168.1.55
dockerImageTag=latest
dockerImageBaseUrl=$ip:5001
loggingNodeSelector=gpu-001
identityNodeSelector=gpu-001
expertNodeSelector=gpu-001
dialogNodeSelector=gpu-001
informationExtractionNodeSelector=gpu-001
masterIP=$ip
mountDataPath="/data"
informationExtractionSoftKey=""
vueAppTenant="pwc"
vueAppPrimaryColor="#D04902"

sudo ./generate-config-from-template.sh \
"$dockerImageTag" \
"$dockerImageBaseUrl" \
"$loggingNodeSelector" \
"$identityNodeSelector" \
"$expertNodeSelector" \
"$dialogNodeSelector" \
"$informationExtractionNodeSelector" \
"$masterIP" \
"$mountDataPath" \
"$informationExtractionSoftKey" \
"$vueAppTenant" \
"$vueAppPrimaryColor"


docker run  -d \
--name nginx \
--restart=always \
--network host \
-v /home/ran/setup/nginx/nginx.conf:/etc/nginx/nginx.conf \
-v /home/ran/setup/nginx/log:/var/log/nginx \
-v /home/ran/setup/nginx/conf.d:/etc/nginx/conf.d \
-v /home/ran/setup/nginx/cert:/etc/nginx/cert \
nginx:1.17.6 \
nginx-debug -g 'daemon off;'

docker run  -d \
--name nginx \
--restart=always \
--network host \
-v /data1/minerva-setup/nginx/nginx.conf:/etc/nginx/nginx.conf \
-v /data1/minerva-setup/nginx/log:/var/log/nginx \
-v /data1/minerva-setup/nginx/conf.d:/etc/nginx/conf.d \
-v /data1/minerva-setup/nginx/cert:/etc/nginx/cert \
nginx:1.17.6




scp nginx/nginx.conf ran@192.168.1.55:/home/ran/setup/nginx


kubectl delete -f cpu0-deployment.yaml
kubectl delete -f cpu1-deployment.yaml
kubectl delete -f gpu0-deployment.yaml
kubectl delete -f gpu1-deployment.yaml
kubectl delete -f mt-deployment.yaml

kubectl apply -f cpu0-deployment.yaml
sleep 60
kubectl apply -f cpu1-deployment.yaml
sleep 60
kubectl apply -f gpu0-deployment.yaml
sleep 60
kubectl apply -f gpu1-deployment.yaml
sleep 60
kubectl apply -f mt-deployment.yaml
sleep 60

scp hardening/fix-1.sh ran@192.168.1.55:~/hardening

docker pull swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/intelligence_mt:beta
docker tag swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/intelligence_mt:beta 192.168.1.35:5001/expert/intelligence_mt:latest
docker push 192.168.1.35:5001/expert/intelligence_mt:latest

docker pull swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/intelligence_worker:beta
docker tag swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/intelligence_worker:beta 192.168.1.35:5001/expert/intelligence_worker:latest
docker push 192.168.1.35:5001/expert/intelligence_worker:latest







# taiping
```
yumdownloader --resolve --destdir=/root/driver-dependency kernel-devel-3.10.0-514.el7.x86_64 kernel-headers-3.10.0-514.el7.x86_64 gcc

yum install kernel-devel-3.10.0-514.el7.x86_64 kernel-headers-3.10.0-514.el7.x86_64 gcc


  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",

cat > /etc/docker/daemon.json <<EOF
{
  "default-runtime": "nvidia",
  "runtimes": {
      "nvidia": {
          "path": "/usr/bin/nvidia-container-runtime",
          "runtimeArgs": []
      }
  }
}
EOF

systemctl enable docker.service
systemctl start docker.service

systemctl daemon-reload
systemctl restart docker
systemctl status docker.service

docker run --privileged=true --rm -it swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/soft_enctyption:latest /bin/sh
docker run --privileged=true --rm swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/soft_enctyption:latest

sudo sysctl net.bridge.bridge-nf-call-iptables=1
sudo sysctl net.bridge.bridge-nf-call-ip6tables=1

firewall-cmd --state
systemctl stop firewalld
systemctl disable firewalld
systemctl mask --now firewalld

getenforce


apjAt/pfjroOtfXtmAHgqhIPi6/UhKv/B4B8n/wkFCTJWDufRpItzd3Xij0VyDCJogrlxWIyNkyMJT1oZdR0AuzuDD1rZhjEF6/zu37CUX843v7rLf8XKoScOq3/TaXFVhfGdWMkP+mEQZ/BuCCUEGUINGzL0iPcCeUjkSw6kuw=
```


ll | awk '{printf "gunzip -c %s | docker load\n", $9}'
```
gunzip -c ./kubernetes-images/calico-cni-v3.10.1.tgz | docker load
gunzip -c ./kubernetes-images/calico-kube-controllers-v3.10.1.tgz | docker load
gunzip -c ./kubernetes-images/calico-node-v3.10.1.tgz | docker load
gunzip -c ./kubernetes-images/calico-pod2daemon-flexvol-v3.10.1.tgz | docker load
gunzip -c ./kubernetes-images/k8s.gcr.io-coredns-1.6.2.tgz | docker load
gunzip -c ./kubernetes-images/k8s.gcr.io-etcd-3.3.15-0.tgz | docker load
gunzip -c ./kubernetes-images/k8s.gcr.io-kube-apiserver-v1.16.3.tgz | docker load
gunzip -c ./kubernetes-images/k8s.gcr.io-kube-controller-manager-v1.16.3.tgz | docker load
gunzip -c ./kubernetes-images/k8s.gcr.io-kube-proxy-v1.16.3.tgz | docker load
gunzip -c ./kubernetes-images/k8s.gcr.io-kube-scheduler-v1.16.3.tgz | docker load
gunzip -c ./kubernetes-images/k8s.gcr.io-pause-3.1.tgz | docker load
gunzip -c ./kubernetes-images/nginx-ingress-controller.tgz | docker load
gunzip -c ./kubernetes-images/nvidia-k8s-device-plugin-1.0.0-beta4.tgz | docker load
```