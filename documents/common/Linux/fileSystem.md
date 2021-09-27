## lsblk

## blkid

## fdisk -l

## /etc/fstab

##  lvdisplaly lvremove lvextend

## CentOS 7 remove home partition and extend root partition

### 1. Unmount home partiton
```
$ umount /home
```

### 2. Show logical volumes and look for the home volume.
```
$ lvdisplay
```
```
  .
  .
  --- Logical volume ---
  LV Path                /dev/myhost/home
  LV Name                home
  VG Name                centos
  .
  .
```

### 3. Remove the home volume
```
$ lvremove /dev/myhost/home
```

### 4. Verify that you have free space.
```
$ vgs
```

### 5. Take note of where your root is located
```
df -h
```
```
Filesystem                Size  Used Avail Use% Mounted on
/dev/mapper/myhost-root    50G  1.2G   49G   3% /
.
.
```

### 6. Resize root partition to reclaim all free space.
```
$ lvextend -l +100%FREE -r /dev/mapper/myhost-root
```

### 7. Remove the line containing the home directory from `/etc/fstab`

### 8. Reboot.