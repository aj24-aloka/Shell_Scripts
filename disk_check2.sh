#!/bin/bash
set -x
limit=20

disk_usage=$(df -H / | awk '(NR>1) {print $5}' | cut -d'%' -f1)
if [[ $disk_usage -gt $limit ]];
then
    mail_subject="Disk Memory Alert"
    mail_body="Disk memory usage is currently at $disk_usage%."
    poc="aloka.aj24@gmail.com"

    echo -e "Subject: $mail_subject \n$mail_body" | /usr/sbin/sendmail -t "$poc"
fi
