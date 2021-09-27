#!/usr/bin/env bash

source ./common.sh

# echo "Fix: 2.2.1.1 Ensure time synchronization is in use"
# yum install -y ntp chrony
# systemctl enable ntpd
# systemctl start ntpd
# systemctl status ntpd


# echo "Fix: 2.2.1.2 Ensure ntp is configured"
# targetFilePath="/etc/ntp.conf"
# content="restrict -4 default kod nomodify notrap nopeer noquery"
# if [ -e "$targetFilePath" ]
# then
#   checkFileIncludeString "$targetFilePath" "$content"
#   if [ $? -eq 1 ]
#   then
#     echo "Append '$content' to file:$targetFilePath"
#     echo "$content" >> "$targetFilePath"
#   fi
# fi
# content="restrict -6 default kod nomodify notrap nopeer noquery"
# if [ -e "$targetFilePath" ]
# then
#   checkFileIncludeString "$targetFilePath" "$content"
#   if [ $? -eq 1 ]
#   then
#     echo "Append '$content' to file:$targetFilePath"
#     echo "$content" >> "$targetFilePath"
#   fi
# fi
# targetFilePath="/etc/sysconfig/ntpd"
# cat > "$targetFilePath" <<EOF
# # Command line options for ntpd
# OPTIONS="-u ntp:ntp"
# EOF
# systemctl daemon-reload
# systemctl restart ntpd
# systemctl status ntpd


# echo "Fix: 2.2.1.3 Ensure chrony is configured"
# targetFilePath="/etc/chrony.conf"
# cat > "$targetFilePath" <<EOF
# # Command-line options for chronyd
# OPTIONS="-u chrony"
# EOF


# echo "Manual Fix: 2.2.15 Ensure mail transfer agent is configured for local-only mode"
# audit:
# netstat -an | grep LIST | grep ":25[[:space:]]"
# remediation:
# vi /etc/postfix/main.cf
#   /RECEIVING MAIL
#   inet_interfaces = loopback-only
# systemctl restart postfix


echo "Fix: 2.3.5 Ensure LDAP client is not installed"
yum remove -y openldap-clients

