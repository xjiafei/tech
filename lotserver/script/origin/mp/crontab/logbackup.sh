#!/bin/bash
CMD=(nginx)
NGINX_LOG="/usr/local/nginx/logs"
NGINX_PIDFILE="$NGINX_LOG/nginx.pid"
BACKUP_DIR="/home/log_backup"
DATE=`date  +%F -d "- 1day"`

[[ -d $BACKUP_DIR ]] || { mkdir -p $BACKUP_DIR;chmod 700 $BACKUP_DIR;}
if [[ -f $NGINX_PIDFILE ]];then
        NGINX_PID=`cat $NGINX_PIDFILE`
else
        NGINX_PID=`ps ax | grep "nginx: master" | grep -v "grep" | awk '{print $1}'`
fi


for i in ${CMD[@]};do
        mkdir -p $BACKUP_DIR/$DATE/$i
done

mv $NGINX_LOG/*.log $BACKUP_DIR/$DATE/nginx &>/dev/null
kill -s USR1 $NGINX_PID

for i in ${CMD[@]};do
        cd $BACKUP_DIR/$DATE/$i && tar -czf $i.tar.gz *.log &>/dev/null
        rm -rf *.log
done
