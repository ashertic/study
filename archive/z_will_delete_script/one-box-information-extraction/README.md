# 创建开机自动运行的脚本（CentOS7通过添加Service的方式完成）

## 创建一个脚本，放在适合的路径下，然后给它添加可执行权限:
```
chmod +x /home/testuser/minver-service-setup/restart.sh
```

## 在system目录下添加一个service文件
```
cd /etc/systemd/system/
sudo vi minerva.service
```
## 下面是minerva.service文件的内容：
```
[Unit]
Description=Restart minerva docker container service when boot
After=network.target
After=systemd-user-sessions.service
After=network-online.target

[Service]
Type=simple
ExecStart=/home/testuser/minver-service-setup/restart.sh
TimeoutStartSec=0

[Install]
WantedBy=default.target
```

## 使service生效, 重启并验证
```
sudo systemctl daemon-reload
systemctl enable minerva.service
systemctl start minerva.service
reboot
```

# 参考资料
1. https://linux.cn/article-9123-1.html
