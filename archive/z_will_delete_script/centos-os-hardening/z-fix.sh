# 1.1.21
df --local -P | awk {'if (NR!=1) print $6'} | xargs -I '{}' find '{}' \
-xdev -type d -perm -0002 2>/dev/null | xargs chmod a+t

# 2.2.1.1
yum install -y ntp
yum install -y chrony

# 2.3.4
yum remove -y telnet

# 3.4.1
yum install -y tcp_wrappers

# 3.6.1
yum install -y iptables

# 4.2.3
yum install -y rsyslog
yum install -y syslog-ng

# 5.1.7
chown root:root /etc/cron.d
chmod og-rwx /etc/cron.d

# 5.1.8
rm /etc/cron.deny
rm /etc/at.deny
touch /etc/cron.allow
touch /etc/at.allow
chmod og-rwx /etc/cron.allow
chmod og-rwx /etc/at.allow
chown root:root /etc/cron.allow
chown root:root /etc/at.allow

# 6.1.8
chown root:root /etc/group-
chmod u-x,go-wx /etc/group-

