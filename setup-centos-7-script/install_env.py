from fabric import Connection
import os

# 192.168.174.132 root 1

target_ip = '192.168.1.37'
target_user = 'root'
target_passwd = '1'
target_os_version = '7.6'
target_root_dir = '/data'

conn = Connection(target_ip, port=22, user=target_user, connect_kwargs={'password': target_passwd})
conn.run('uname -a')

# copy rpm packages to server
src_dir_full_path = os.path.abspath('../setup-centos-7-script')
target_dir_full_path = f'{target_root_dir}/setup-centos-7-script'

conn.run(f'mkdir -p {target_dir_full_path}')
conn.run(f'mkdir -p {target_dir_full_path}/basic')
conn.run(f'mkdir -p {target_dir_full_path}/docker')
conn.run(f'mkdir -p {target_dir_full_path}/k8s')
conn.run(f'mkdir -p {target_dir_full_path}/nvidia-docker')
conn.run(f'mkdir -p {target_dir_full_path}/python3')

files_need_upload = [
    'basic/install.sh',
    'docker/install.sh',
    'docker/post-docker-installation.sh',
    'nvidia-docker/install.sh',
    'python3/install.sh'
]

for one_file in files_need_upload:
    src = os.path.join(src_dir_full_path, one_file)
    target = os.path.join(target_dir_full_path, one_file)
    ret = conn.put(src, remote=target)
    print("Uploaded {0.local} to {0.remote}".format(ret))

result = conn.put(f'centos-packages-{target_os_version}.tar.gz', f'{target_root_dir}/centos-packages-{target_os_version}.tar.gz')
print("Uploaded {0.local} to {0.remote}".format(result))

conn.run(f"cd {target_root_dir}; tar -xvf centos-packages-{target_os_version}.tar.gz")
conn.run(f"cd {target_root_dir}; mv centos-packages-{target_os_version} centos-packages")
conn.run(f"cd {target_root_dir}; rm -f centos-packages-{target_os_version}.tar.gz")

# install basic packages

# install nvidia driver
## check nouveau driver status
# below is old install nvidia driver shell
# #!/usr/bin/env bash

# if [[ $EUID -ne 0 ]]; then
#   echo "This script must be run as root" 1>&2
#   exit 1
# fi

# lshw -numeric -C display
# lsmod | grep nouveau

# cat /etc/modprobe.d/blacklist.conf
# echo -e "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/blacklist.conf
# mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.bak
# dracut /boot/initramfs-$(uname -r).img $(uname -r)
# reboot

# lsmod | grep nouveau
# uname -r
# lshw -numeric -C display
# sh ./NVIDIA-Linux-x86_64-440.36.run --silent
# nvidia-smi

# above is old install nvidia driver shell

# install docker
# execute post docker script

# install nvidia-docker if has gpu

# install python3