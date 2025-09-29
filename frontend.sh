#1/bin/bash
source ./common.sh
check_root

########Frontend Nginx########
dnf module disable nginx -y &>>$Logfile
Status $? " Disabling nginx "
dnf module enable nginx:1.24 -y &>>$Logfile
Status $? " enabling nginx MODULE "
dnf install nginx -y &>>$Logfile
Status $? " Installing nginx "

systemctl enable nginx &>>$Logfile
Status $? " Enabling nginx "
systemctl start nginx &>>$Logfile
Status $? " Starting nginx "

rm -rf /usr/share/nginx/html/* &>>$Logfile
Status $? "Removing default html "

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip
cd /usr/share/nginx/html 

unzip /tmp/frontend.zip &>>$Logfile

cp $DIR/nginx.conf /etc/nginx/nginx.conf &>>$Logfile
Status $? " Changing .conf file "
systemctl restart nginx &>>$Logfile
Status $? " Restarting for changes to apply in nginx "

TIMER