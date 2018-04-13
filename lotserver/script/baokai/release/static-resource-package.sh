#!/bin/bash

#-----------------------------
#用途：静态资源发布
#-----------------------------
bak_dir="/data/backup/rollback"

cd /data/svn_baokai/static/
rm -f static.tar.gz
svn up  --no-auth-cache --non-interactive
tar zcvf static.tar.gz ./
