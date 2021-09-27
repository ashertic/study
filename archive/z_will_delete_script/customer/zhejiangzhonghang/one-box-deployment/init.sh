#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

chmod +x ./bash-install.sh
chmod +x ./nvidia.sh
chmod +x ./docker-install.sh
chmod +x ./deploy.sh
chmod +x ./remove.sh

