#!/bin/bash

#-----------------------------
#用途：静态资源发布
#-----------------------------
bak_dir="/data/backup/rollback"

cd /data/svn/static
svn up --no-auth-cache --non-interactive |tee /root/script/release/svn.log
cd /home/img-server/static/
tar czf  "$bak_dir"/static/static_`date "+%Y%m%d%H%M_%S"`.tar.gz ./
rm -rf * && rm -rf .svn
cp -pr /data/svn/static/* /home/img-server/static/
