#!/usr/bin/env bash

source ./common.sh


echo "Fix: 3.2.1 Ensure source routed packets are not accepted"
# appendWithCheck "/etc/sysctl.conf" "net.ipv4.conf.all.accept_source_route = 0"
# appendWithCheck "/etc/sysctl.conf" "net.ipv4.conf.default.accept_source_route = 0"
sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.accept_source_route=0


echo "Fix: 3.2.2 Ensure ICMP redirects are not accepted"
# appendWithCheck "/etc/sysctl.conf" "net.ipv4.conf.all.accept_redirects = 0"
# appendWithCheck "/etc/sysctl.conf" "net.ipv4.conf.default.accept_redirects = 0"
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0 


echo "Fix: 3.2.3 Ensure secure ICMP redirects are not accepted"
# appendWithCheck "/etc/sysctl.conf" "net.ipv4.conf.all.secure_redirects = 0"
# appendWithCheck "/etc/sysctl.conf" "net.ipv4.conf.default.secure_redirects = 0"
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0


echo "Fix: 3.2.5 Ensure broadcast ICMP requests are ignored"
# appendWithCheck "/etc/sysctl.conf" "net.ipv4.icmp_echo_ignore_broadcasts = 1"
sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1


echo "Fix: 3.2.6 Ensure bogus ICMP responses are ignored"
# appendWithCheck "/etc/sysctl.conf" "net.ipv4.icmp_ignore_bogus_error_responses = 1"
sysctl -w net.ipv4.icmp_ignore_bogus_error_responses=1


echo "Fix: 3.2.7 Ensure Reverse Path Filtering is enabled"
# appendWithCheck "/etc/sysctl.conf" "net.ipv4.conf.all.rp_filter = 1"
# appendWithCheck "/etc/sysctl.conf" "net.ipv4.conf.default.rp_filter = 1"
sysctl -w net.ipv4.conf.all.rp_filter=1
sysctl -w net.ipv4.conf.default.rp_filter=1


echo "Fix: 3.2.8 Ensure TCP SYN Cookies is enabled"
# appendWithCheck "/etc/sysctl.conf" "net.ipv4.tcp_syncookies = 1"
sysctl -w net.ipv4.tcp_syncookies=1


echo "Fix: 3.3.1 Ensure IPv6 router advertisements are not accepted"
# appendWithCheck "/etc/sysctl.conf" "net.ipv6.conf.all.accept_ra = 0"
# appendWithCheck "/etc/sysctl.conf" "net.ipv6.conf.default.accept_ra = 0"
sysctl -w net.ipv6.conf.all.accept_ra=0
sysctl -w net.ipv6.conf.default.accept_ra=0


echo "Fix: 3.3.2 Ensure IPv6 redirects are not accepted"
# appendWithCheck "/etc/sysctl.conf" "net.ipv6.conf.all.accept_redirects = 0"
# appendWithCheck "/etc/sysctl.conf" "net.ipv6.conf.default.accept_redirects = 0"
sysctl -w net.ipv6.conf.all.accept_redirects=0
sysctl -w net.ipv6.conf.default.accept_redirects=0

# echo "Fix: "
# ls -l /etc/sysctl.d/k8s.conf
# sudo chmod og+r k8s.conf

# manually fix

# 3.1.2
sysctl -w net.ipv4.conf.all.send_redirects=0
sysctl -w net.ipv4.conf.default.send_redirects=0
sysctl -w net.ipv4.route.flush=1

# 3.2.1
sysctl -w net.ipv4.conf.all.accept_source_route=0
sysctl -w net.ipv4.conf.default.accept_source_route=0
sysctl -w net.ipv4.route.flush=1

# 3.2.2
sysctl -w net.ipv4.conf.all.accept_redirects=0
sysctl -w net.ipv4.conf.default.accept_redirects=0
sysctl -w net.ipv4.route.flush=1

# 3.2.3
sysctl -w net.ipv4.conf.all.secure_redirects=0
sysctl -w net.ipv4.conf.default.secure_redirects=0
sysctl -w net.ipv4.route.flush=1

# 3.2.4
sysctl -w net.ipv4.conf.all.log_martians=1
sysctl -w net.ipv4.conf.default.log_martians=1
sysctl -w net.ipv4.route.flush=1

sysctl -w net.ipv4.route.flush=1
sysctl -w net.ipv6.route.flush=1