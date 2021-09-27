lshw -numeric -C display

lsmod | grep nouveau

yum install wget

wget http://us.download.nvidia.com/tesla/440.64.00/NVIDIA-Linux-x86_64-440.64.00.run

sudo fdisk -l
sudo fdisk /dev/sdc
mkfs.ext4 /dev/sdc1
sudo mkdir /data
sudo mount /dev/sdc1 /data
blkid /dev/sdc1
vi /etc/fstab
umount /dev/sdc1
mount -a
df -TH
mkdir /data/minerva-setup
sudo chown -R minerva:minerva /data/minerva-setup
cd /data/minerva-setup

ran-test-cpu001: minerva@52.147.0.90 Minerva123456!
ran-test-gpu002: minerva@13.75.254.210 Minerva123456! /data/minerva-setup
ran-test-gpu003: minerva@13.75.215.52 Minerva123456! /data/minerva-setup

ssh minerva@13.75.215.52

scp -r centos-packages minerva@13.75.254.210:/data/minerva-setup/
scp -r os-setup-common-files minerva@13.75.254.210:/data/minerva-setup/
scp -r setup-centos-script minerva@13.75.254.210:/data/minerva-setup/
scp -r deploy-script minerva@13.75.254.210:/data/minerva-setup/

scp -r centos-packages minerva@13.75.215.52:/data/minerva-setup/
scp -r os-setup-common-files minerva@13.75.215.52:/data/minerva-setup/
scp -r setup-centos-script minerva@13.75.215.52:/data/minerva-setup/
scp -r deploy-script minerva@13.75.215.52:/data/minerva-setup/

scp -r centos-packages minerva@52.147.0.90:/data/minerva-setup/
scp -r os-setup-common-files minerva@52.147.0.90:/data/minerva-setup/
scp -r setup-centos-script minerva@52.147.0.90:/data/minerva-setup/
scp -r deploy-script minerva@52.147.0.90:/data/minerva-setup/
