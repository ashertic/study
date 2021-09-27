#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# workdir=`pwd`
# resourcesBaseDir=../resources-centos/packages
# kernelPackagesDir=$resourcesBaseDir/kernel-packages
# gccPackagesDir=$resourcesBaseDir/gcc-packages

sudo apt-get --purge remove nvidia-*

# install gcc and make
# cd gcc
# sudo dpkg -i *

# cd $nvidiaDriverDir
# sudo ./NVIDIA-Linux-x86_64-440.36.run --silent
nvidia-smi


# install docker 19.03
# sudo dpkg -i *
sudo service docker status

sudo usermod -aG docker $USER
newgrp docker

# install nvidia-container-toolkit
sudo dpkg -i *
sudo systemctl restart docker
sudo service docker status

# docker run --gpus all nvidia/cuda:9.0-base nvidia-smi