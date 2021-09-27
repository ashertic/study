#!/usr/bin/env bash

cd /home/ran/setup/minerva-kubernetes
mkdir -p ../logs
./deploy.sh 192.168.1.35 1 3 2 1 2 yes &> ../logs/log-$(date +"%Y-%m-%d").txt
