#!/bin/bash

if [ "$(whoami)" != "root" ]
then
            sudo su -s "$0"
                exit
fi

sleep 3

#Step1: Install required pacakages
apt update
apt install libsasl2-modules postfix -y

#Step 3:Add Gmail Username and App Password to Postfix configuration
filename2="/etc/postfix/sasl/sasl_passwd"
echo -e "[smtp.gmail.com]:587 aloka.aj24@gmail.com:eyvqznluxpciotty" >> $filename2 #(add app passward which we generated in gmail)


#create the hash file for Postfix using the postmap command
postmap $filename2

#Step 4:Secure Your Postfix Hash Database and Email Password Files
chown root:root $filename2 /etc/postfix/sasl/sasl_passwd.db
chmod 0600 $filename2 /etc/postfix/sasl/sasl_passwd.db

#Step 5:Configure Relay Host postfix with gmail
#add and Modify the main.cf file using below command:
filename1="/etc/postfix/main.cf"
search="relayhost ="
replace="relayhost = [smtp.gmail.com]:587"
sed -i "s/$search/$replace/" $filename1

echo -e "\n# Enable SASL authentication \nsmtp_sasl_auth_enable = yes \n# Disallow methods that allow anonymous authentication \nsmtp_sasl_security_options = noanonymous \n# Location of sasl_passwd \nsmtp_sasl_password_maps = hash:/etc/postfix/sasl/sasl_passwd \n# Enable STARTTLS encryption \nsmtp_tls_security_level = encrypt \n# Location of CA certificates \nsmtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt" >> $filename1

systemctl restart postfix



#step 6: send mail using shell script

recipient="aloka.aj24@gmail.com"
subject="Test Email"
body="This is a test email sent via Postfix."

# Send email
echo -e "Subject: $subject\n$body" | /usr/sbin/sendmail -t $recipient

