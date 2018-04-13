#!/bin/bash

APPNAME=(im ui supUi)
BACKUP_DIR="/home/log_backup"
DATE=`date  +%F -d "- 1day"`


for me in ${APPNAME[@]};do
	[[ -d $BACKUP_DIR/$me ]] || { mkdir -p $BACKUP_DIR/$me;chmod 700 $BACKUP_DIR/$me;}
	LOG_DIR="/opt/$me/logs"
	cd $LOG_DIR
	tar -zcf catalina.$DATE.out.tar.gz catalina.$DATE.out && rm -rf catalina.$DATE.out
	tar -zcf access_log.$DATE.tar.gz localhost_access_log.$DATE.txt && rm -rf localhost_access_log.$DATE.txt
	mv *.tar.gz $BACKUP_DIR/$me
done
