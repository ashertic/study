#!/bin/sh

dir=/data1/project-dev/data_root/expert/intelligence-mt-data
mkdir /data/intelligence-mt-data

for i in `cat res`
do
  cp -r $dir/$i /data/intelligence-mt-data
done
