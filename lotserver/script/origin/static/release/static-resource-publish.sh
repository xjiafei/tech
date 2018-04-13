#!/bin/bash

#-----------------------------
#用途：静态资源发布
#-----------------------------
bak_dir="/root/backup/rollback"
> /root/script/release/svn.log

cd /root/svn_trunk
/usr/bin/svn up |tee /root/script/release/svn.log
cd /home/img-server/static/
tar czf  "$bak_dir"/static_`date "+%Y%m%d%H%M_%S"`.tar.gz ./
rm -rf * && rm -rf .svn
cp -pr /root/svn_trunk/* /home/img-server/static/ && cp -pr /root/svn_trunk/.svn /home/img-server/static/
chmod 755 *
/root/script/crontab/static_rsync.sh
