#!/bin/bash
App_name=catalogue
mongodIP=mongod.kriiishmatic.fun
DIR=$PWD
App_setup
Nodejs_setup
systemd_setup

cp $DIR/mongo.repo /etc/yum.repos.d/mongo.repo
Status $? "Mongo repo is here"

dnf install mongodb-mongosh -y &>>$Logfile
Status $? "installed the mongoin in $App_name "

INDEX=$(mongosh $mongodIP --quiet --eval "db.getMongo().getDBNames().indexOf('$App_name')") #### this one gives you a value 0 and nehatice
if [ $INDEX -le 0 ]; then
mongosh --host $mongodIP </app/db/master-data.js
    else
echo -e " Already loaded products and masterdata so $Y skipping $N "
fi
app_restart
TIMER
