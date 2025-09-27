#!/bin/bash

App_name=user
#!/bin/bash

source ./common.sh
App_name=user
mongodIP=mongod.kriiishmatic.fun
DIR=$PWD

check_root
App_setup
Nodejs_setup
systemd_setup
app_restart
TIMER
