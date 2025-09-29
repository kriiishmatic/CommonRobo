#!/bin/bash
App_name=payment
source ./common.sh
check_root
App_setup
Python_setup
systemd_setup
TIMER