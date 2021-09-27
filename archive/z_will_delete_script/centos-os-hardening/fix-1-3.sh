#!/usr/bin/env bash

source ./common.sh

# echo "Fix: 1.4.1 Ensure permissions on bootloader config are configured"
# targetFilePath="/boot/grub2/grub.cfg"
# if [ -e "$targetFilePath" ]
# then
#   chown root:root "$targetFilePath"
#   chmod og-rwx "$targetFilePath"
# fi
# targetFilePath="/boot/grub2/user.cfg"
# if [ -e "$targetFilePath" ]
# then
#   chown root:root "$targetFilePath"
#   chmod og-rwx "$targetFilePath"
# fi


echo "Fix: 1.5.1 Ensure core dumps are restricted"
targetFilePath="/etc/security/limits.conf"
content="* hard core 0"
if [ -e "$targetFilePath" ]
then
  checkFileIncludeString "$targetFilePath" "$content"
  if [ $? -eq 1 ]
  then
    echo "Append '$content' to file:$targetFilePath"
    echo "$content" >> "$targetFilePath"
  fi
fi
targetFilePath="/etc/sysctl.conf"
content="fs.suid_dumpable = 0"
if [ -e "$targetFilePath" ]
then
  checkFileIncludeString "$targetFilePath" "$content"
  if [ $? -eq 1 ]
  then
    echo "Append '$content' to file:$targetFilePath"
    echo "$content" >> "$targetFilePath"
  fi
fi
sysctl -w fs.suid_dumpable=0


echo "Fix: 1.5.3 Ensure address space layout randomization (ASLR) is enabled"
targetFilePath="/etc/sysctl.conf"
content="kernel.randomize_va_space = 2"
if [ -e "$targetFilePath" ]
then
  checkFileIncludeString "$targetFilePath" "$content"
  if [ $? -eq 1 ]
  then
    echo "Append '$content' to file:$targetFilePath"
    echo "$content" >> "$targetFilePath"
  fi
fi
sysctl -w kernel.randomize_va_space=2


# echo "Fix: 1.8 Ensure updates, patches, and additional security software are installed"
# yum update --security
