# 1.3.2 Ensure filesystem integrity is regularly checked
```
# audit
crontab -u root -l | grep aide

# remediation
crontab -u root -e
0 3 * * * /usr/sbin/aide --check
```

# 2.2.15 Ensure mail transfer agent is configured for local-only mode
```
vi /etc/postfix/main.cf
# go to RECEIVING MAIL section, change "inet_interfaces = localhost" to to below line:
inet_interfaces = loopback-only

# save file and execute below command
systemctl restart postfix
```