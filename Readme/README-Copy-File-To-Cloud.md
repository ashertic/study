# 在机器上创建相应目录
mkdir -p ~/setup/resources-common

# 拷贝文件
```
ip=139.9.117.97
echo $ip
scp -i ~/huawei-cloud-keys/KeyPair-gpu-2.pem resources-common/nvidia-driver/Tesla-P40-T4-Linux64/NVIDIA-Linux-x86_64-440.33.01.run root@$ip:~
scp -i ~/huawei-cloud-keys/KeyPair-gpu-2.pem -r resources-centos root@$ip:~/setup
scp -i ~/huawei-cloud-keys/KeyPair-gpu-2.pem -r resources-common/kubernetes-config root@$ip:/root/setup/resources-common
scp -i ~/huawei-cloud-keys/KeyPair-gpu-2.pem -r resources-common/kubernetes-images root@$ip:/root/setup/resources-common
``


# 配置华为云服务器
```
cd ~
yum install -y lshw bash-completion
lshw -numeric -C display
lsmod | grep nouveau
nvidia-smi

sh ./NVIDIA-Linux-x86_64-440.33.01.run

cd /root/setup/resources-centos/packages/docker-1809-packages
rpm -ivh --replacefiles --replacepkgs *.rpm

cd /root/setup/resources-centos/packages/nvidia-docker2-packages
rpm -ivh --replacefiles --replacepkgs *.rpm

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "default-runtime": "nvidia",
  "runtimes": {
      "nvidia": {
          "path": "/usr/bin/nvidia-container-runtime",
          "runtimeArgs": []
      }
  }
}
EOF

cat /etc/docker/daemon.json

systemctl daemon-reload
systemctl restart docker
systemctl status docker.service
sleep 5

docker version

cd /root/setup/resources-centos/packages/kubernetes-packages
rpm -ivh --replacefiles --replacepkgs *.rpm

cd /root/setup/resources-common/kubernetes-images
gunzip -c ./calico-cni-v3.10.1.tgz | docker load
gunzip -c ./calico-kube-controllers-v3.10.1.tgz | docker load
gunzip -c ./calico-node-v3.10.1.tgz | docker load
gunzip -c ./calico-pod2daemon-flexvol-v3.10.1.tgz | docker load
gunzip -c ./k8s.gcr.io-coredns-1.6.2.tgz | docker load
gunzip -c ./k8s.gcr.io-etcd-3.3.15-0.tgz | docker load
gunzip -c ./k8s.gcr.io-kube-apiserver-v1.16.3.tgz | docker load
gunzip -c ./k8s.gcr.io-kube-controller-manager-v1.16.3.tgz | docker load
gunzip -c ./k8s.gcr.io-kube-proxy-v1.16.3.tgz | docker load
gunzip -c ./k8s.gcr.io-kube-scheduler-v1.16.3.tgz | docker load
gunzip -c ./k8s.gcr.io-pause-3.1.tgz | docker load

cd /root/setup/resources-common/kubernetes-config
POD_CIDR="10.96.0.0/12"
ip=139.9.117.97
sed -i -e "s?192.168.0.0/16?$POD_CIDR?g" calico.yaml
kubeadm init --apiserver-advertise-address $ip --apiserver-bind-port 6443 --kubernetes-version 1.16.3 --pod-network-cidr $POD_CIDR

```