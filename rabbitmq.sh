#!/bin/bash

source ./common.sh
check_root
cp $DIR/rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>>$Logfile
Status $? "Created rabbit.rep "
dnf install rabbitmq-server -y &>>$Logfile
Status $? "installing RabbitMQ "
systemctl enable rabbitmq-server &>>$Logfile
Status $? "Enabling RabbitMQ "
systemctl start rabbitmq-server &>>$Logfile
Status $? "Started RabbitMQ "
echo " $G Successfully installed and enabled RabbitMQ $N " &>>$Logfile
rabbitmqctl add_user roboshop roboshop123 &>>$Logfile
Status $? "Added System user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$Logfile
Status $? "Given Root permissions "

TIMER