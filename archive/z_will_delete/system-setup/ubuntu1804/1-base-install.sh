#!/usr/bin/env bash
ip=$1
workdir=`pwd`
packagedir=$workdir/packages

echocolor()
{
   log=$1
   echo  -e "\n\e[40;31;1m$log\e[0m\n"
}

function linux-headers()
{
cd $packagedir/linux-headers-5.3.0-40-generic
dpkg -i *.deb
}

function gcc()
{
cd $packagedir/libgcc-7-dev
dpkg -i *.deb
cd $packagedir/gcc
dpkg -i *.deb
}

function build-essential()
{
cd $packagedir/libc6-dev
dpkg -i *.deb
cd $packagedir/g++-7
dpkg -i *.deb
cd $packagedir/libdpkg-perl
dpkg -i *.deb
cd $packagedir/build-essential
dpkg -i *.deb
}



function docker.io()
{
docker -v
if [ $? -eq 0 ];then
   echo  "docker system already instll"
else
   cd $packagedir/runc
   dpkg -i *.deb
   cd $packagedir/docker.io
   dpkg -i *.deb
fi
}


function nvidia-docker2()
{
cd $packagedir/libnvidia-container1
dpkg -i *.deb
cd $packagedir/nvidia-container-toolkit
dpkg -i *.deb
cd $packagedir/nvidia-docker2
dpkg -i *.deb
}


linux-headers
if [ $? -eq 0 ];then
   echocolor  "linux-headers install is successful"
else
   echocolor  "linux-headers install is failed"  	
   exit 1
fi

gcc
if [ $? -eq 0 ];then
    echocolor  "gcc install is successful"
else
    echocolor  "gcc install is failed"
    exit 1
fi

build-essential
if [ $? -eq 0 ];then
    echocolor  "build-essential install is successful"
else
    echocolor  "build-essential install is failed"
    exit 1
fi

docker.io
if [ $? -eq 0 ];then
    echocolor  "docker install is successful"
else
    echocolor  "docker install is failed"
    exit 1
fi   




if [ $? -eq 0 ];then
    echo  -e "blacklist nouveau\noptions nouveau modeset=0" >> /etc/modprobe.d/blacklist.conf
    sed -i  's/blacklist nvidiafb/\#blacklist nvidiafb/'   /etc/modprobe.d/blacklist.conf
else
    echo   -e "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/blacklist.conf
fi

bash NVIDIA-Linux-x86_64-440.36.run --silent
lspci | grep -i nvidia
nvidia-smi




nvidia-docker2
if [ $? -eq 0 ];then
  systemctl restart docker
  echocolor  "nvidia-docker2 install is successful"
else
  echocolor  "nvidia-docker2 install is failed"
fi  




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

sed -i "s/192.168.200.211:8000/$ip:5001/g" /etc/docker/daemon.json

echo -e "\nconfigure docker as below"
cat /etc/docker/daemon.json

echo -e "\nrestart docker service"
systemctl daemon-reload
systemctl restart docker
echo -e "\ndocker service status"
systemctl status docker.service


gunzip -c  $workdir/cuda-test-image/cuda_9_0_base.tgz | docker load
docker run --rm cuda:9.0-base nvidia-smi
docker image rm -f cuda:9.0-base
