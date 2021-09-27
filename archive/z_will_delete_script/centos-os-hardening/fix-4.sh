#!/usr/bin/env bash

source ./common.sh

# echo "Manual Fix: "
# audit:
# remediation:

# Can't change this, it will break our service
# echo "Fix: "


# echo "Manual Fix: 4.2.1.1 Ensure rsyslog Service is enabled"
# audit:
# rpm -q rsyslog
# systemctl is-enabled rsyslog
# remediation:
# systemctl enable rsyslog


# echo "Manual Fix: 4.2.1.3 Ensure rsyslog default file permissions configured"
# audit:
# grep ^\$FileCreateMode /etc/rsyslog.conf /etc/rsyslog.d/*.conf
# remediation:
# vi /etc/rsyslog.conf
#   $FileCreateMode 0640


echo "Fix: 4.2.4 Ensure permissions on all logfiles are configured"
# audit:
# find /var/log -type f -ls
find /var/log -type f -exec chmod g-rwx,o-rwx {} +



