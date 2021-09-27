## Linux
```
du -h --max-depth=1
cp -a -v src_dir dest_dir
unzip file -d dir
```

## 打包并分割
```
tar -zcvf suzhoushenpiju.tar.gz suzhoushenpiju
split -b 524288000 -d -a 2 suzhoushenpiju.tar.gz suzhoushenpiju.tar.gz.
split -b 314572800 -d -a 3 minerva_20200512.tar.gz minerva_20200512.tar.gz. 
```

## 将分割打包的文件，重新解压缩
```
cat cm-11.tar.gz.* | tar -zxv
cat minerva_20200512.tar.gz.* | tar -zxv
tar -xvf file.tar.gz
```


## ls按照时间排序输入结果
```
# 时间最近的在前面
ls -lt
```
```
# 时间从前到后
ls -ltr
```

## 统计文件个数
http://noahsnail.com/2017/02/07/2017-02-07-Linux%E7%BB%9F%E8%AE%A1%E6%96%87%E4%BB%B6%E5%A4%B9%E4%B8%8B%E7%9A%84%E6%96%87%E4%BB%B6%E6%95%B0%E7%9B%AE/

```
ls -lR| grep "^-" | wc -l
ls -l | grep "^-" | wc -l
```

## 命令行下mount smb共享目录
```
smbclient -L //192.168.1.9 --user=mnvai
sudo mount -t cifs -o username=mnvai //192.168.1.9/share /mnt/sharefolder/
```

## Ubuntu backup and restore
https://linuxconfig.org/ubuntu-20-04-system-backup-and-restore#:~:text=Software%20Requirements%20and%20Linux%20Command%20Line%20Conventions%20,given%20linux%20commands%20to%20be%20%20...%20
