#!/bin/bash

#-----------------------------
#用途：静态资源发布
#-----------------------------
bak_dir="/root/backup/rollback"

cd /home/img-server/static/
tar czf  "$bak_dir"/static_`date "+%Y%m%d%H%M_%S"`.tar.gz ./
/usr/bin/svn up
chmod 755 *
echo "JS Success OK!"
