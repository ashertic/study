#!/usr/bin/env bash

source ./common.sh


# echo "Manual Fix: 5.3.1 Ensure password creation requirements are configured"
# audit:
# grep pam_pwquality.so /etc/pam.d/password-auth
#   password requisite pam_pwquality.so try_first_pass retry=3
# grep pam_pwquality.so /etc/pam.d/system-auth
#   password requisite pam_pwquality.so try_first_pass retry=3
# grep ^minlen /etc/security/pwquality.conf
#   minlen = 14
# grep ^dcredit /etc/security/pwquality.conf
#   dcredit = -1
# grep ^lcredit /etc/security/pwquality.conf
#   lcredit = -1
# grep ^ocredit /etc/security/pwquality.conf
#   ocredit = -1
# grep ^ucredit /etc/security/pwquality.conf
#   ucredit = -1
# remediation:
# vi /etc/pam.d/password-auth
#   password requisite pam_pwquality.so try_first_pass retry=3
# vi /etc/pam.d/system-auth
#   password requisite pam_pwquality.so try_first_pass retry=3
# vi /etc/security/pwquality.conf
#   minlen = 14
#   dcredit = -1
#   ucredit = -1
#   ocredit = -1
#   lcredit = -1

# already changed below

# echo "Manual Fix: 5.3.4 Ensure password hashing algorithm is SHA-512"
# vi /etc/pam.d/password-auth
#   password   sufficient pam_unix.so sha512
# vi /etc/pam.d/system-auth
#   password   sufficient pam_unix.so sha512

# already changed above

# echo "Manual Fix: 5.3.2 Ensure lockout for failed password attempts is configured"
# audit:
# remediation:
# vi /etc/pam.d/password-auth
#   auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900
#   auth [success=1 default=bad] pam_unix.so
#   auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900
#   auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900
# vi /etc/pam.d/system-auth
#   auth required pam_faillock.so preauth audit silent deny=5 unlock_time=900
#   auth [success=1 default=bad] pam_unix.so
#   auth [default=die] pam_faillock.so authfail audit deny=5 unlock_time=900
#   auth sufficient pam_faillock.so authsucc audit deny=5 unlock_time=900


# echo "Manual Fix: 5.3.3 Ensure password reuse is limited"
# audit:
# egrep '^password\s+sufficient\s+pam_unix.so' /etc/pam.d/password-auth
# egrep '^password\s+sufficient\s+pam_unix.so' /etc/pam.d/system-auth
# remediation:
# vi /etc/pam.d/password-auth
#   password   sufficient pam_unix.so remember=5
# vi /etc/pam.d/system-auth
#   password   sufficient pam_unix.so remember=5





# echo "Manual Fix: 5.4.1.1 Ensure password expiration is 90 days or less"
# audit:
# grep PASS_MAX_DAYS /etc/login.defs
# egrep ^[^:]+:[^\!*] /etc/shadow | cut -d: -f1
# chage --list appuser
# remediation:
# vi /etc/login.defs
#   PASS_MAX_DAYS 90
# chage --maxdays 90 appuser


# echo "Maunal Fix: 5.4.1.4 Ensure inactive password lock is 30 days or less"
# audit:
# useradd -D | grep INACTIVE
#   INACTIVE=30
# egrep ^[^:]+:[^\!*] /etc/shadow | cut -d: -f1
# chage --list appuser
# remediation:
# useradd -D -f 30
# chage --inactive 30 appuser


# echo "Manual Fix: 5.4.4 Ensure default user umask is 027 or more restrictive"
# grep "umask" /etc/bashrc
# grep "umask" /etc/profile
# vi /etc/bashrc
# vi /etc/profile
# cd /etc/profile.d
# grep "umask" *
# ls -l | awk '{print $9}'
# sed -i "s/umask 077/umask 027/g" 256term.csh
# sed -i "s/umask 077/umask 027/g" 256term.sh
# sed -i "s/umask 077/umask 027/g" bash_completion.sh
# sed -i "s/umask 077/umask 027/g" colorgrep.csh
# sed -i "s/umask 077/umask 027/g" colorgrep.sh
# sed -i "s/umask 077/umask 027/g" colorls.csh
# sed -i "s/umask 077/umask 027/g" colorls.sh
# sed -i "s/umask 077/umask 027/g" csh.local
# sed -i "s/umask 077/umask 027/g" lang.csh
# sed -i "s/umask 077/umask 027/g" lang.sh
# sed -i "s/umask 077/umask 027/g" less.csh
# sed -i "s/umask 077/umask 027/g" less.sh
# sed -i "s/umask 077/umask 027/g" sh.local
# sed -i "s/umask 077/umask 027/g" which2.csh
# sed -i "s/umask 077/umask 027/g" which2.sh


# echo "Maunal Fix: 5.6 Ensure access to the su command is restricted"
# audit:
# grep pam_wheel.so /etc/pam.d/su
#   auth required pam_wheel.so use_uid
# grep wheel /etc/group
#   wheel:x:10:root,<user list>
# remediation:
# vi /etc/pam.d/su
#   auth required pam_wheel.so use_uid
# vi /etc/group
#   wheel:x:10:root,<user list>