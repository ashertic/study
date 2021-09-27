### 参考引用

- https://docs.docker.com/engine/install/ubuntu/
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/

### 安装 docker

```bash
sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update

apt-cache madison docker-ce
# use docker version 18.09

sudo apt-get install docker-ce=5:18.09.9~3-0~ubuntu-bionic docker-ce-cli=5:18.09.9~3-0~ubuntu-bionic containerd.io

sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
docker run hello-world
```

### 修改 Docker 配置

```bash
sudo -i

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2",
  "insecure-registries" : ["192.168.200.211:8000"]
}
EOF

cat /etc/docker/daemon.json
systemctl daemon-reload
systemctl restart docker
systemctl status docker.service

docker run --rm hello-world
```

### 修改网络设置

```bash
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
vm.swappiness=0
EOF

cat /etc/sysctl.d/k8s.conf
sudo sysctl --system
```

### 安装 k8s 基础命令行工具

```bash
sudo apt-get update && sudo apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
apt-cache madison kubelet
apt-cache madison kubeadm
apt-cache madison kubectl
sudo apt-get install -y kubelet=1.16.3-00 kubeadm=1.16.3-00 kubectl=1.16.3-00
sudo apt-mark hold kubelet kubeadm kubectl
```

### 创建一个单节点 K8S 集群

```bash
systemctl enable --now kubelet
kubeadm version


```
