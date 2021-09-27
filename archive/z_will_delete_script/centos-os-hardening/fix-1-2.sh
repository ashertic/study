#!/usr/bin/env bash

source ./common.sh

# echo "Manual Fix: "
# audit:
# remediation:

# echo "Manual Fix: 1.1.14 Ensure nodev option set on /home partition"
# audit:
# mount | grep /home
# remediation:
# vi /etc/fstab
#   add nodev to the 4 fields
# mount -o remount,nodev /home


# echo "Fix: 1.3.1 Ensure AIDE is installed"
# yum install -y aide
# aide --init
# mv /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz


# echo "Manual Fix: 1.3.2 Ensure filesystem integrity is regularly checked "
# audit:
# crontab -u root -l | grep aide
# grep -r aide /etc/cron.* /etc/crontab
# remediation:
# crontab -u root -e
#   0 5 * * * /usr/sbin/aide --check

