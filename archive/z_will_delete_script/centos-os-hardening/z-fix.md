# 1.1.1.1, 1.1.1.2, 1.1.1.3, 1.1.1.4, 1.1.1.5, 1.1.1.6, 1.1.1.7, 
```
# change file and execute command
```

# 1.1.3, 1.1.4, 1.1.5, 1.1.8, 1.1.9, 1.1.10, 1.1.14, 1.1.15, 1.1.16, 1.1.17, 1.1.18, 1.1.19, 1.1.20
```
# removable media partitions
# /etc/fstab

nosuid,nodev,noexec
```

# 1.2.1, 1.2.2, 
```
# TODO
```

# 1.3.1, 1.3.2
```
yum install -y aide

crontab -u root -e
0 5 * * * /usr/sbin/aide --check
```

# 1.4.1, 1.4.2
```
# Exception: File not exist

stat /boot/grub2/grub.cfg
stat /boot/grub2/user.cfg

```
# change file config
```
1.5.1
1.5.3

2.2.15

3.5.1
3.5.2
3.5.3
3.5.4

```

# To do something manually
```
1.5.2
1.7.1.1
1.7.1.2
1.7.1.3

4.2.4
```

# may not need
```
2.2.1.2
2.2.1.3

4.2.1.3
4.2.1.4

5.1.2
5.1.3
5.1.4
5.1.5
5.1.6
5.1.7

```

# 3.1.1, 3.1.2, 3.2.1, 3.2.2, 3.2.3, 3.2.4, 3.2.5, 3.2.6, 3.2.7, 3.2.8, 
# 3.3.1, 3.3.2, 3.3.3
```
# Set the following parameter in /etc/sysctl.conf or a /etc/sysctl.d/* file:
net.ipv4.ip_forward = 0
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0


sysctl -w net.ipv4.ip_forward=0
sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv6.conf.all.accept_ra=0
sysctl -w net.ipv6.conf.default.accept_ra=0
sysctl -w net.ipv6.route.flush=1
```

# 3.4.2， 3.4.3， 
```
# Need IP Range Information 
```

# 4.2.4
```
# Need complicated action
```

# 5.2.2, 5.2.3, 5.2.4, 5.2.5, 5.2.6, 5.2.7, 5.2.8, 5.2.9, 5.2.10, 5.2.12, 5.2.13, 5.2.14, 5.2.15, 
```
# change file
```

# 5.3.1, 5.3.2, 5.3.3 
```
# complicated
```

# 5.4.1.1, 5.4.1.2, 5.4.1.4, 5.4.2, 5.4.4, 5.6, 
```
# complicated 
```

# 6.1.10, 6.1.11, 6.1.12, 6.2.3, 6.2.6, 6.2.7, 6.2.8, 6.2.10
```
# complicated
```










