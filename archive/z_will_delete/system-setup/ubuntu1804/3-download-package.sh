#!/usr/bin/env bash
mkdir $1 && cd $1
apt-get download $1
for package in `apt-cache depends $1 | grep Depends |cut -d: -f2`
do
  apt-get download $package 
done

ls ../$1
