#!/bin/sh

dir=/data1/project-gaoqishenpi/data_root/approval/data/high-tech
mkdir /data/high-tech

for i in `cat companyList.txt`
do
  cp -r $dir/$i /data/high-tech
done
