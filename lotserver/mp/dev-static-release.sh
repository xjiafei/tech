#!/bin/bash

#-----------------------------
#用途：静态资源发布
#-----------------------------
bak_dir="/root/backup/rollback"
> /home/hkdev/script/svn.log

cd /home/img-dev/static/
#tar czf  "$bak_dir"/static_`date "+%Y%m%d%H%M_%S"`.tar.gz ./
/usr/bin/svn up |tee /home/hkdev/script/svn.log
chmod 755 *
chown -R hkdev /home/img-dev/*

