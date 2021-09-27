from fabric import Connection
import os

# centos 7.5 192.168.174.128 done
# centos 7.6 192.168.174.130 done
# centos 7.7 192.168.174.131 done
# centos 7.8 192.168.174.132
# centos 7.9 192.168.174.134 done

target_ip = '192.168.174.132'
target_user = 'root'
target_passwd = '1'
target_root_dir = '/root'

conn = Connection(target_ip, port=22, user=target_user, connect_kwargs={'password': target_passwd})
conn.run('uname -a')
result = conn.run('uname -r', hide=True)
kernel_version = result.stdout.strip()
print(kernel_version)

src_dir_full_path = os.path.abspath('../setup-centos-7-script')
target_dir_full_path = f'{target_root_dir}/setup-centos-7-script'

conn.run(f'mkdir -p {target_dir_full_path}')
conn.run(f'mkdir -p {target_dir_full_path}/basic')
conn.run(f'mkdir -p {target_dir_full_path}/docker')
conn.run(f'mkdir -p {target_dir_full_path}/k8s')
conn.run(f'mkdir -p {target_dir_full_path}/nvidia-docker')
conn.run(f'mkdir -p {target_dir_full_path}/python3')

files_need_upload = [
    'add_local_repo.sh',
    'download-packages.sh',
    'basic/download-packages.sh',
    'docker/download-packages.sh',
    'docker/install.sh',
    'k8s/download-packages.sh',
    'python3/download-packages.sh',
    'nvidia-docker/download-packages.sh'
]

for one_file in files_need_upload:
    src = os.path.join(src_dir_full_path, one_file)
    target = os.path.join(target_dir_full_path, one_file)
    ret = conn.put(src, remote=target)
    print("Uploaded {0.local} to {0.remote}".format(ret))

conn.run(f'cd {target_dir_full_path}; bash add_local_repo.sh')
conn.run(f'cd {target_dir_full_path}; bash download-packages.sh')

result = conn.get(f'{target_root_dir}/centos-packages/{kernel_version}.tar.gz', local=f'/mnt/d/deployment-resources/centos-7-packages/{kernel_version}.tar.gz')
print("Downloaded {0.remote} to {0.local}".format(result))
