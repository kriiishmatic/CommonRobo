#!/bin/bash

source ./common.sh
check_root
dnf module disable redis -y &>>$Logfile
Status $? " Disabling redis "
dnf module enable redis:7 -y &>>$Logfile
Status $? " enabling redis "
dnf install redis -y &>>$Logfile
Status $? " installing redis "
sed -i -e 's/127\.0\.0\.1/0.0.0.0/' -e 's/protected-mode yes/protected-mode no/' /etc/redis/redis.conf
Status $? " changed allowed traffic"

systemctl enable redis &>>$Logfile
Status $? " enabling redis "
systemctl start redis &>>$Logfile
Status $? " starting redis "

TIMER