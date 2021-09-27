#!/usr/bin/env bash

# No need to change this, no removable media on the server
# echo "Fix: 1.1.18 Ensure nodev option set on removable media partitions"
# echo "Fix: 1.1.19 Ensure nosuid option set on removable media partitions"
# echo "Fix: 1.1.20 Ensure noexec option set on removable media partitions"


# No need to change this, all repro are configured by trusted vendor
# echo "Fix: 1.2.2 Ensure GPG keys are configured"


# No need to change this, we don't need NTP service or chrony service
# echo "Fix: 2.2.1.1 Ensure time synchronization is in use"
# echo "Fix: 2.2.1.2 Ensure ntp is configured"
# echo "Fix: 2.2.1.3 Ensure chrony is configured"


# No need to change this, we need to use NFS to mount network disk
# echo "Fix: 2.2.7 Ensure NFS and RPC are not enabled"



# No need to change this, already configure it appropriate for our environment
# echo "Manual Fix: 4.2.1.2 Ensure logging is configured"
# audit:
# ls -l /var/log/
# remediation:
# vi /etc/rsyslog.conf
# vi /etc/rsyslog.d/*.conf
# #### RULES ####
# # Everybody gets emergency messages
# *.emerg                                                 :omusrmsg:*
# # Log all the mail messages in one place.
# mail.*                                                  -/var/log/mail
# mail.info                                               -/var/log/mail.info
# mail.warning                                            -/var/log/mail.warn
# mail.err                                                 /var/log/mail.err
# news.crit                                               -/var/log/news/news.crit
# news.err                                                -/var/log/news/news.err
# news.notice                                             -/var/log/news/news.notice
# *.=warning;*.=err                                       -/var/log/warn
# *.crit                                                   /var/log/warn
# *.*;mail.none;news.none                                 -/var/log/messages
# local0,local1.*                                         -/var/log/localmessages
# local2,local3.*                                         -/var/log/localmessages
# local4,local5.*                                         -/var/log/localmessages
# local6                                                  -/var/log/localmessages
# # Log anything (except mail) of level info or higher.
# # Don't log private authentication messages!
# auth,user.*;*.info;authpriv.none;cron.none               /var/log/messages
# # The authpriv file has restricted access.
# authpriv.*                                               /var/log/secure
# # Log cron stuff
# cron.*                                                   /var/log/cron
# # Save news errors of level crit and higher in a special file.
# uucp                                                    /var/log/spooler
# # Save boot messages also to boot.log
# local7.*                                                /var/log/boot.log
# # BEGIN ANSIBLE MANAGED BLOCK - rsyslog rules
# kern.*                                                  /var/log/kern.log
# daemon.*                                                /var/log/daemon.log
# syslog.*                                                /var/log/syslog
# lpr,news,uucp,local1,local3,local5,local6.*             /var/log/unused.log
# # END ANSIBLE MANAGED BLOCK - rsyslog rules