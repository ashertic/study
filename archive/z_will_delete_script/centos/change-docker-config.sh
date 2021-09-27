#!/usr/bin/env bash

ip=$1
mode=$2

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

echocolor()
{
  log=$1
  echo -e "\n\e[40;31;1m$log\e[0m\n"
}

registry=${ip}:5001

if [ $mode = "gpu" ]
then

echo "mode is: gpu"
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
  },
  "insecure-registries" : ["192.168.200.211:8000"]
}
EOF

else

echo "mode is: cpu"
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

fi


sed -i "s/192.168.200.211:8000/$registry/g" /etc/docker/daemon.json

echocolor "configure docker as below"
cat /etc/docker/daemon.json

echocolor "restart docker"
systemctl daemon-reload
systemctl restart docker
systemctl status docker.service
sleep 5

echocolor "docker version"
docker version
