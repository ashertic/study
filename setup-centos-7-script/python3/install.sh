#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

workdir=`pwd`

kernel_version=$(uname -r)
target_package_dir=../../centos-packages/$kernel_version/python3
cd $target_package_dir
rpm -ivh --replacefiles --replacepkgs *.rpm


cd $workdir
cp ../../os-setup-common-files/python3/Python-3.7.4.tar.xz   .
tar -xvJf Python-3.7.4.tar.xz
rm -f ./Python-3.7.4.tar.xz

mkdir /usr/local/python3
cd Python-3.7.4
./configure --prefix=/usr/local/python3 --enable-optimizations --with-ssl
# 第一个指定安装的路径,不指定的话,安装过程中可能软件所需要的文件复制到其他不同目录,删除软件很不方便,复制软件也不方便.
# 第二个可以提高python10%-20%代码运行速度.
# 第三个是为了安装pip需要用到ssl,后面报错会有提到.
make && make install

ln -s /usr/local/python3/bin/python3 /usr/local/bin/python3
ln -s /usr/local/python3/bin/pip3 /usr/local/bin/pip3
ln -s /usr/local/python3/bin/python3 /usr/local/sbin/python3
ln -s /usr/local/python3/bin/pip3 /usr/local/sbin/pip3

cd $workdir
rm -r -f ./Python-3.7.4

echo -e "\npython3 -V"
python3 -V

echo -e "\npip3 -V"
pip3 -V
