## Step 1
Check the current running Kernel Version
```
# uname -a
Linux node64 3.10.0-1160.25.1.el7.x86_64 #1 SMP Wed Apr 28 21:49:45 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
```
## Step 2
List the Kernel Entries as per GRUB2 file
```
# awk -F\' '$1=="menuentry " {print $2}' /etc/grub2.cfg
CentOS Linux (5.12.6-1.el7.elrepo.x86_64) 7 (Core)
CentOS Linux (3.10.0-1160.25.1.el7.x86_64) 7 (Core)
CentOS Linux (3.10.0-1062.el7.x86_64) 7 (Core)
CentOS Linux (0-rescue-c66cd409783f4368888aae97fa6c8626) 7 (Core)
```

## Step 3
Let us modify the Kernel Version to `5.12.6-1.el7.elrepo.x86_64` which is at line number `1` but denoted as entry `0`.
```
# grub2-set-default 0
```

## Step 4
Changes to `/etc/default/grub` require rebuilding the `grub.cfg` file as follows
```
# grub2-mkconfig -o /boot/grub2/grub.cfg
```