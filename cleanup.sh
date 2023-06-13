#!/bin/bash

set -x #to debug
n=10 #number of files to retain
now=$(date +%s) #current time
older_files=$(find . -type f -mtime +$n)

for file in $older_files; do
  rm -f $file
done
echo "Successfully cleaned up the $n old files.."

#using other options
#1.find . -type f -mtime +10 -delete
#2.find . -type f -mtime +10 -exec rm -f {} \;
