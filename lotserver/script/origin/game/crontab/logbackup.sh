#!/bin/bash

APPNAME=(game)
BACKUP_DIR="/home/log_backup"
DATE=`date  +%F -d "- 1day"`

[[ -d $BACKUP_DIR ]] || { mkdir -p $BACKUP_DIR;chmod 700 $BACKUP_DIR;}

for me in ${APPNAME[@]};do
	LOG_DIR="/opt/$me/logs"
	cd $LOG_DIR
	tar -zcf catalina.$DATE.out.tar.gz catalina.$DATE.out && rm -rf catalina.$DATE.out
	tar -zcf access_log.$DATE.tar.gz localhost_access_log.$DATE.txt && rm -rf localhost_access_log.$DATE.txt
	mv *.tar.gz $BACKUP_DIR
done
