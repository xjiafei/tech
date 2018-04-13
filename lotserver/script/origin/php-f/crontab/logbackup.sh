#!/bin/bash

LOG_DIR="/usr/local/nginx/html/log"
BACKUP_DIR="/home/log_backup"
DATE=`date  +%F -d "- 1day"`

[[ -d $BACKUP_DIR ]] || { mkdir -p $BACKUP_DIR;chmod 700 $BACKUP_DIR;}
cd $LOG_DIR
tar -zcf $DATE.log.tar.gz $DATE.log && rm -rf $DATE.log
tar -zcf error_log.$DATE.log.tar.gz error_log.$DATE.log && rm -rf error_log.$DATE.log
mv *.tar.gz $BACKUP_DIR
