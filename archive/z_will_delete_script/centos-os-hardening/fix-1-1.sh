#!/usr/bin/env bash

source ./common.sh

cisConfigureFilePath="/etc/modprobe.d/CIS.conf"
if [ ! -e "$cisConfigureFilePath" ]
then
  # echo "$cisConfigureFilePath not exist, so will create an empty one"
  touch "$cisConfigureFilePath"
else
  # echo "$cisConfigureFilePath already exist"
  :
fi


echo "Fix: 1.1.1.1 Ensure mounting of cramfs filesystems is disabled"
content='install cramfs /bin/true'
checkFileIncludeString "$cisConfigureFilePath" "$content"
if [ $? -eq 1 ]; then
  echo "Append '$content' to file:$cisConfigureFilePath"
  echo "$content" >> "$cisConfigureFilePath"
fi
rmmod cramfs


echo "Fix: 1.1.1.2 Ensure mounting of freevxfs filesystems is disabled"
content='install freevxfs /bin/true'
checkFileIncludeString "$cisConfigureFilePath" "$content"
if [ $? -eq 1 ]; then
  echo "Append '$content' to file:$cisConfigureFilePath"
  echo "$content" >> "$cisConfigureFilePath"
fi
rmmod freevxfs


echo "Fix: 1.1.1.3 Ensure mounting of jffs2 filesystems is disabled"
content='install jffs2 /bin/true'
checkFileIncludeString "$cisConfigureFilePath" "$content"
if [ $? -eq 1 ]; then
  echo "Append '$content' to file:$cisConfigureFilePath"
  echo "$content" >> "$cisConfigureFilePath"
fi
rmmod jffs2


echo "Fix: 1.1.1.4 Ensure mounting of hfs filesystems is disabled"
content='install hfs /bin/true'
checkFileIncludeString "$cisConfigureFilePath" "$content"
if [ $? -eq 1 ]; then
  echo "Append '$content' to file:$cisConfigureFilePath"
  echo "$content" >> "$cisConfigureFilePath"
fi
rmmod hfs


echo "Fix: 1.1.1.5 Ensure mounting of hfsplus filesystems is disabled"
content='install hfsplus /bin/true'
checkFileIncludeString "$cisConfigureFilePath" "$content"
if [ $? -eq 1 ]; then
  echo "Append '$content' to file:$cisConfigureFilePath"
  echo "$content" >> "$cisConfigureFilePath"
fi
rmmod hfsplus


echo "Fix: 1.1.1.6 Ensure mounting of squashfs filesystems is disabled"
content='install squashfs /bin/true'
checkFileIncludeString "$cisConfigureFilePath" "$content"
if [ $? -eq 1 ]; then
  echo "Append '$content' to file:$cisConfigureFilePath"
  echo "$content" >> "$cisConfigureFilePath"
fi
rmmod squashfs


echo "Fix: 1.1.1.7 Ensure mounting of udf filesystems is disabled"
content='install udf /bin/true'
checkFileIncludeString "$cisConfigureFilePath" "$content"
if [ $? -eq 1 ]; then
  echo "Append '$content' to file:$cisConfigureFilePath"
  echo "$content" >> "$cisConfigureFilePath"
fi
rmmod udf
