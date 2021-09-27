#!/usr/bin/env bash

docker stop information_extraction_cpu0
docker stop information_extraction_gpu0
docker stop information_extraction_mt

docker start information_extraction_cpu0
sleep 120

docker start information_extraction_gpu0
sleep 60

docker start information_extraction_mt
sleep 60
