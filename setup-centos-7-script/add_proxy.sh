#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

cd /root
ls -al

cat <<EOF >> .bashrc

export http_proxy=http://192.168.1.34:8001
export https_proxy=http://192.168.1.34:8001
export HTTPS_PROXY=http://192.168.1.34:8001
export HTTPS_PROXY=http://192.168.1.34:8001

EOF

cat .bashrc

echo "add proxy to server"
