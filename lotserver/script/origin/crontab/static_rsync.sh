#!/bin/bash

LOGPATH="/root/script/rsync_log"
DATE=`/bin/date +"%Y%m%d"`
YESTERDAYDATE=`/bin/date +"%Y%m%d" --date="- 1day"`
STATICPATH="/home/img-server/"
DATELOG=`/bin/date +"%Y%m%d %H:%M:%S"`

#update tw server to cdn proxy 
echo "$DATELOG Rsync start" >> $LOGPATH/rsync_$DATE.log 2>& 1
/usr/bin/rsync -avrtpP --exclude=".svn" --password-file=/etc/rsyncd.pwd --delete $STATICPATH staticproxy@118.184.51.47::static >> $LOGPATH/rsync_$DATE.log 2>& 1
/usr/bin/rsync -avrtpP --exclude=".svn" --password-file=/etc/rsyncd.pwd --delete $STATICPATH staticproxy@59.188.69.194::static >> $LOGPATH/rsync_$DATE.log 2>& 1
echo "$DATELOG Rsync done" >> $LOGPATH/rsync_$DATE.log 2>& 1
echo " " >> $LOGPATH/rsync_$DATE.log 2>& 1

cd $LOGPATH
/bin/rm -fr *$YESTERDAYDATE*
sync;echo 2 > /proc/sys/vm/drop_caches

