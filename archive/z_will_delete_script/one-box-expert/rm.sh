#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run with sudo" 1>&2
  exit 1
fi

docker container stop $(docker ps -q)
docker container rm $(docker ps -a -q)

# docker image rm -f $(docker images -q)
