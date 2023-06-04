#!/bin/bash
threshold=70
backup_date=$(date +'%m/%d/%Y %H:%M:%S')
df -H | awk '{print $1 " " $5}' | while read output;
do
	#echo " Disk Details: $output"
	usage=$(echo $output | awk '{print $2}' | cut -d'%' -f1)
	file_sys=$(echo $output | awk '{print $1}')
	#echo " Disk usage: $usage"
	#echo "File System: $file_sys"
	if [[ $usage -gt $threshold ]];
	then
		mail_subject="Disk Memory Alert"
		mail_body="Disk memory usage is CRITICAL for $file_sys on $backup_date"
		mail_recipient="aloka.aj24@gmail.com"
		echo -e "Subject: $mail_subject\n$mail_body" | /usr/sbin/sendmail -t $mail_recipient
	fi
done
