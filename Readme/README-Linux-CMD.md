# CentOS挂载硬盘
```
sudo -i
df -TH
fdisk -l

fdisk /dev/sdb
fdisk -l
mkfs.ext4 /dev/sdb1

mkdir /data
mount /dev/sdb1 /data

df -TH

blkid /dev/sdb1
vi /etc/fstab
umount /dev/sdb1
mount -a
mount | grep /data
```

# ubuntu挂载硬盘
```
df -TH
fdisk -l
fdisk /dev/sdb
partprobe
mkfs -t ext4 /dev/sdb1
mkdir /mnt/data
mount /dev/sdb1 /mnt/data
df -TH
blkid /dev/sdb1
nano /etc/fstab
umount /dev/sdb1
mount -a
mount | grep /mnt/data
```

# /etc/fstab中添加的新行如下所示，替换掉其中的UUID值，以及最后的3换成相应的序号
```
UUID=e66299a1-2992-4f6b-bf9b-eeaf86d283da /data ext4    defaults        0 2

UUID=4909648e-04d3-4be1-829b-f5a122d513b4 /data ext4    defaults        0 1


```

# CentOS创建新的user
```
# 创建新用户
sudo adduser username

# 设置新用户的密码
sudo passwd username

# 添加用户到管理员
sudo usermod -aG wheel username

# 测试新用户的管理员权限
su - username
sudo ls -la /root
```

# 设置swap开机不启动,并修改K8s文件让Kubernetes开机可以顺利启动
使用如下命令，暂时关闭swap:
```
swapoff -a
```
修改下面的文件
```
sudo vi /etc/fstab
```
注释掉下面这一行:
```
/dev/mapper/centos-swap swap                    swap    defaults        0 0
```
检查swap的状态，如果有输出，那swap没有被关闭
```
swapon -s
```
然后输入命令，如果swap一行输出全部为0则代表已经关闭
```
sudo free -m
```
修改K8s文件：
```
sudo vi /etc/sysctl.d/k8s.conf
```
添加下面一行:
```
vm.swappiness=0
```
然后执行:
```
sudo sysctl -p /etc/sysctl.d/k8s.conf
```

# 获取软加密需要的机器信息
```
sudo dmidecode > machine_profile.txt
```

# 创建定时任务
https://linux.cn/article-9123-1.html
https://tecadmin.net/crontab-in-linux-with-20-examples-of-cron-schedule/


# 修改时区
## 参考链接
1. https://linuxize.com/post/how-to-set-or-change-timezone-on-centos-7/

## 修改时区的命令
```
# 显示当前系统的时区信息
timedatectl

# 显示可用的时区列表
timedatectl list-timezones

# 只显示上海时区
timedatectl list-timezones | grep Sh

# 修改为上海时区
sudo timedatectl set-timezone Asia/Shanghai
```

# 在CentOS Server 7中安装GUI并且配置显卡
## 参考链接
1. https://www.linuxidc.com/Linux/2018-04/152000.htm
1. https://www.centos.org/forums/viewtopic.php?t=2395

## 安装GNOME界面
```
# 进入root模式
sudo -i

# 安装X Window System
yum groupinstall "X Window System"

# 如果我们想检查我们已经安装的，以及可以安装的软件组列表，可以使用
yum grouplist

# 安装图形界面GNOME
yum groupinstall "GNOME Desktop" "Graphical Administration Tools"

# 如果进入图形界面，第一次会比较慢
startx

# 由于之前安装的是CentOS Server版系统，因此需要设置系统的模式启动模式为图形模式，使用下面的命令
ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target

# 然后重启一下
reboot

# 重启之后发现，会发现分辨率很低，原因是之前的NVIDIA Driver安装的时候X Configuration没有正确的配置
# 使用本项目内的脚本方式安装Nvidia Server Driver的时候，nvidia的安装脚本会自动设置X Configuration
# 因此我们可以重新安装一下Driver，就可以了
# 不过安装Nvidia Driver的时候，会提示X Server在运行需要退出，下面就是如何退出以及重新安装Driver后如何
# 重新进入X Server的命令

# 停止X Server
init 3

# 进入命令行，安装Nvidia Driver，千万不要添加--silent参数，因为默认模式是不修改X Configuration
sudo sh ./NVIDIA-Linux-x86_64-440.36.run

# 测试显卡驱动是否已经好了
startx

# 重新启动X Login
init 5
```

init 3
This will stop X and X logins
Configure your X

startx
Test your x. Then exit the session.

init 5

# 检查当前的系统运行级别
```
# 3 是文本模式， 5是图形模式
who -r
```


# 获取机器的软加密key
```
docker run --rm --privileged=true swr.cn-north-4.myhuaweicloud.com/meinenghua/expert/soft_enctyption:latest
```

# Ubuntu设置使用图形界面等
```
# 设置开机默认使用console
sudo systemctl set-default multi-user.target
# 设置开机默认使用图形界面
sudo systemctl set-default graphical.target

# console界面登录后，临时使用图形界面
sudo systemctl start gdm3.service
# 或者你升级过，安装了lightdm display manager，那么也可以使用下面的命令在命令行打开图形界面
sudo systemctl start lightdm.service

# https://ubuntuforums.org/showthread.php?t=2420259
```
