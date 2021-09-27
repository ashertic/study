#!/usr/bin/env bash

source ./common.sh

# echo "Fix: 6.1.8 Ensure permissions on /etc/group- are configured"
# audit:
# stat /etc/group-
# remediation:
chown root:root /etc/group-
chmod u-x,go-rwx /etc/group-
