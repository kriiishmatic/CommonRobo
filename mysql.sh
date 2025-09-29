#!/bin/bash
sorce ./common.sh
check_root
dnf install mysql-server -y &>>$Logfile
Status $? "Installing MYSQL"
systemctl enable mysqld &>>$Logfile
Status $? "Enabling MYSQL"
systemctl start mysqld &>>$Logfile
Status $? "Starting MYSQL"
mysql_secure_installation --set-root-pass RoboShop@1 &>>$Logfile
Status $? "Setting password"
TIMER