#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

lshw -numeric -C display
lsmod | grep nouveau

sudo vim /etc/modprobe.d/blacklist.conf

# blacklist vga16fb
# blacklist nouveau
# blacklist rivafb
# blacklist rivatv
# blacklist nvidiafb

sudo update-initramfs -u
sudo reboot
