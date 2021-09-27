## 192.168.1.35
```
# on target server machine
mkdir -p ~/setup
mkdir -p ~/setup/images/minerva/
mkdir -p ~/setup/resources-common

# on your local machine
export ip=192.168.1.35
echo $ip

# copy all
scp -r . ran@$ip:~/setup/

# copy separately
scp -r cert ran@$ip:~/setup/
scp -r ./centos ran@$ip:~/setup/
scp -r ./minerva-kubernetes ran@$ip:~/setup/

scp -r ./resources-centos ran@$ip:~/setup/

scp -r ./resources-common ran@$ip:~/setup/

scp -r ./resources-common/nvidia-driver ran@$ip:~/setup/resources-common
scp -r ./resources-common/kubernetes-images/ ran@$ip:~/setup/resources-common/kubernetes-images
scp -r ./resources-common/kubernetes-config/ ran@$ip:~/setup/resources-common/kubernetes-config

scp -r ./resources-common/expert-intelligence/ ran@$ip:~/setup/resources-common/expert-intelligence
scp -r resources-common ran@$ip:~/setup/

scp -r images/registry ran@$ip:~/setup/images/
scp -r images/thirdparty ran@$ip:~/setup/images/
```

## 192.168.1.55
```
# on target server machine
mkdir -p /data/pwc-setup
mkdir -p /data/pwc-setup/images/minerva
mkdir -p /data/pwc-setup/resources-common

# on your local machine
export ip=192.168.1.55
export targetServerBaseDir=/data/pwc-setup
echo $ip
echo $targetServerBaseDir

scp -r ./centos ran@$ip:$targetServerBaseDir/
scp -r ./minerva-kubernetes ran@$ip:$targetServerBaseDir/
scp -r ./resources-centos ran@$ip:$targetServerBaseDir/

scp -r ./resources-common/nvidia-driver ran@$ip:$targetServerBaseDir/resources-common
scp -r ./resources-common/kubernetes-images ran@$ip:$targetServerBaseDir/resources-common
scp -r ./resources-common/kubernetes-config ran@$ip:$targetServerBaseDir/resources-common

scp -r images/registry ran@$ip:$targetServerBaseDir/images
scp -r images/thirdparty ran@$ip:$targetServerBaseDir/images

scp -r nginx ran@$ip:$targetServerBaseDir/
scp nginx/pwc-test-nginx.conf ran@$ip:$targetServerBaseDir/nginx/
scp pwc/save-pwc-image.sh ran@$ip:$targetServerBaseDir/

```