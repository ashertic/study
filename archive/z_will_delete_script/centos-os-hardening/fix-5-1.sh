#!/usr/bin/env bash

source ./common.sh

# echo "Manual Fix: "
# audit:
# remediation:
# vi /etc/ssh/sshd_config
#   Protocol 2
#   LogLevel INFO
#   LoginGraceTime 60
#   PermitRootLogin no      # ignore this change and ask PWC to change it
#   MaxAuthTries 4
#   HostbasedAuthentication no
#   IgnoreRhosts yes
#   PermitEmptyPasswords no
#   X11Forwarding no
#   PermitUserEnvironment no
#   ClientAliveInterval 300
#   ClientAliveCountMax 0
#   Banner /etc/issue.net
#   MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com
# systemctl reload sshd

echo "Fix: 5.2.2 Ensure SSH Protocol is set to 2"
appendWithCheck "/etc/ssh/sshd_config" "Protocol 2"

echo "Fix: 5.2.3 Ensure SSH LogLevel is set to INFO"
appendWithCheck "/etc/ssh/sshd_config" "LogLevel INFO"

echo "Fix: 5.2.13 Ensure SSH LoginGraceTime is set to one minute or less"
appendWithCheck "/etc/ssh/sshd_config" "LoginGraceTime 60"

echo "Fix: 5.2.8 Ensure SSH root login is disabled"
appendWithCheck "/etc/ssh/sshd_config" "PermitRootLogin no"

echo "Fix: 5.2.5 Ensure SSH MaxAuthTries is set to 4 or less"
appendWithCheck "/etc/ssh/sshd_config" "MaxAuthTries 4"

echo "Fix: 5.2.7 Ensure SSH HostbasedAuthentication is disabled"
appendWithCheck "/etc/ssh/sshd_config" "HostbasedAuthentication no"

echo "Fix: 5.2.6 Ensure SSH IgnoreRhosts is enabled"
appendWithCheck "/etc/ssh/sshd_config" "IgnoreRhosts yes"

echo "Fix: 5.2.9 Ensure SSH PermitEmptyPasswords is disabled"
appendWithCheck "/etc/ssh/sshd_config" "PermitEmptyPasswords no"

echo "Fix: 5.2.4 Ensure SSH X11 forwarding is disabled"
appendWithCheck "/etc/ssh/sshd_config" "X11Forwarding no"

echo "Fix: 5.2.10 Ensure SSH PermitUserEnvironment is disabled"
appendWithCheck "/etc/ssh/sshd_config" "PermitUserEnvironment no"

echo "Fix: 5.2.12 Ensure SSH Idle Timeout Interval is configured"
appendWithCheck "/etc/ssh/sshd_config" "ClientAliveInterval 300"
appendWithCheck "/etc/ssh/sshd_config" "ClientAliveCountMax 0"

echo "Fix: 5.2.15 Ensure SSH warning banner is configured"
appendWithCheck "/etc/ssh/sshd_config" "Banner /etc/issue.net"

echo "Fix: 5.2.11 Ensure only approved MAC algorithms are used"
appendWithCheck "/etc/ssh/sshd_config" "MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com"


# 5.1.2
chown root:root /etc/crontab
chmod og-rwx /etc/crontab
stat /etc/crontab

# 5.1.3
chown root:root /etc/cron.hourly
chmod og-rwx /etc/cron.hourly
stat /etc/cron.hourly

# 5.1.4
chown root:root /etc/cron.daily
chmod og-rwx /etc/cron.daily
stat /etc/cron.daily

# 5.1.5
chown root:root /etc/cron.weekly
chmod og-rwx /etc/cron.weekly
stat /etc/cron.weekly

# 5.1.6
chown root:root /etc/cron.monthly
chmod og-rwx /etc/cron.monthly
stat /etc/cron.monthly

# 5.1.7
chown root:root /etc/cron.d
chmod og-rwx /etc/cron.d
stat /etc/cron.d