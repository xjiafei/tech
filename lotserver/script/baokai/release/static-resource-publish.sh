#!/bin/bash

#-----------------------------
#用途：静态资源发布
#-----------------------------
bak_dir="/data/backup/rollback"

cd /home/img-server/static/
tar czf  "$bak_dir"/statuc/static_`date "+%Y%m%d%H%M_%S"`.tar.gz ./
rm  -rf *
cp /data/svn/static/static.tar.gz ./
tar xvf static.tar.gz ./
rm -f static.tar.gz
