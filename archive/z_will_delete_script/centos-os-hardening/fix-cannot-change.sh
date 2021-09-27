#!/usr/bin/env bash

# Can't change this, it will break our service
# echo "Fix: 3.1.1 Ensure IP forwarding is disabled"
# appendWithCheck "/etc/sysctl.conf" "net.ipv4.ip_forward = 0"
# sysctl -w net.ipv4.ip_forward=0
# sysctl -w net.ipv4.route.flush=1


# Can't change this, it will break our service
# echo "Maunal Fix: 3.3.3 Ensure IPv6 is disabled"
# grep "^\s*linux" /boot/grub2/grub.cfg

# Can't change this, it will break our service
# echo "Fix: 3.6.2 Ensure default deny firewall policy"