#!/bin/bash

set -x #to debug
n=2 #delete old files except this number
$(truncate -s 0 list.txt)
ls -lrt | awk '(NR>1){print $9}' >> list.txt
count=$(wc -l < list.txt)
num=$((  $count - $n ))
he=$(head -n $num < list.txt)
for file in $he; do
        rm -f $file
done
echo "successfully deleted old files"
