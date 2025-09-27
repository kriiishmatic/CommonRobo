#!/bin/bash
#colours
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

##### Variables #####
App_name=catalogue
mongodIP=mongod.kriiishmatic.fun
DIR=$PWD

USERID=$(id -u)

if [ $USERID -ne 0 ]; then
    echo -e " $R Get sudo access BOZO $N "
    exit 3
fi

#creating logs files
####################

shell_log="/var/log/robo-project"

mkdir -p $shell_log

#removing .sh from file
#######################

Remove_sh=$( echo $0 | cut -d "." -f1 )

Logfile="$shell_log/$Remove_sh.log"
##Time taken ####
echo " Script started at :: $(date) " | tee -a $Logfile
Start=$( date +%s )

Status(){
    if [ $1 -ne 0 ]; then
    echo -e " $R Failed $N  $2  " | tee -a $Logfile
    exit 1
else
    echo -e "$G Sucessfully $N $2 " | tee -a $Logfile
fi
}

##### MONGODBINSTALLSTION #########
mongo_installation(){
    cp mongo.repo /etc/yum.repos.d/mongo.repo
Status $? "created repo "

dnf install mongodb-org -y &>>$Logfile
Status $? "Installed mongodb::sure"

systemctl enable mongod &>>$Logfile

systemctl start mongod &>>$Logfile
Status $? "Start Mongod Hurray!!"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
Status $? "Allowing remote connections: kek "

systemctl restart mongod &>>$Logfile
Status $? " Mongod restarted and ready to go "

}

Nodejs_setup(){
    dnf module disable nodejs -y &>>$Logfile
    Status $? "Disabled the node"
    dnf module enable nodejs:20 -y &>>$Logfile
    Status $? "enabled the node"
    dnf install nodejs -y &>>$Logfile
    Status $? "installed the node"
    npm install &>>$Logfile
    Status $? "installed the DEPENDENCIES"


}

App_setup(){
    id roboshop &>>$Logfile
    if [ $? -ne 0 ]; then
useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop
    else
    echo -e " Already installed $Y SKIPPED! $N "
    fi
    mkdir -p /app 
    Status $? "Creating directory"
    curl -o /tmp/$App_name.zip https://roboshop-artifacts.s3.amazonaws.com/$App_name-v3.zip 
    Status $? "Dowloadting code zip"
    cd /app 
    rm -rf /app/*
    Status $? "Removed previous code"
    unzip /tmp/$App_name.zip &>>$Logfile
    Status $? "unzipping latest code"
}

systemd_setup(){
   cp $DIR/$App_name.service /etc/systemd/system/$App_name.service
    Status $? "Copied $App_name service"
    systemctl daemon-reload
    Status $? "Demonic reload"
    systemctl enable $App_name &>>$Logfile
    Status $? "Enabled the node"
    systemctl start $App_name &>>$Logfile
    Status $? "Start it " 
}

app_restart(){
    systemctl restart $App_name
    Status $? "Restarted $App_name"
}

TIMER(){

End=$( date +%s )
Time=$(( $Start - $End ))
echo -e " Time Taken to setup ::: $G $Time $N "

}