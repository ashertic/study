#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root or with sudo permission" 1>&2
  exit 1
fi

ip=$1
if [ -z $ip ]; then
  echo "please provide machine IP as parameter"
  exit 1
fi

machineID=$2
if [ -z $machineID ]; then
  echo "please provide machine ID as parameter"
  exit 1
fi

sed -i "s@TARGET_MACHINE_IP_PLACEHOLDER@$ip@" prod.json
sed -i "s@TARGET_MACHINE_ID_PLACEHOLDER@$machineID@" prod.json
