#!/bin/bash

App_name=maven
App_setup
Maven_setup
systemd_setup

########### Installing Mysql #################
dnf install mysql -y &>>$Logfile
Status $? "Installed mysql "

mysql -h $MysqlDomain -uroot -pRoboShop@1 -e 'use cities' &>>$Logfile
if [ $? -ne 0 ]; then
    mysql -h $MysqlDomain -uroot -pRoboShop@1 < /app/db/schema.sql &>>$Logfile
    mysql -h $MysqlDomain -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$Logfile
    mysql -h $MysqlDomain -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$Logfile
else
    echo -e " Database Schema is already Loaded $Y skiping $N "
fi
app_restart
TIMER
