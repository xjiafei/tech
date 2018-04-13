#!/bin/sh

#----------------------------------------
#用途:发布PHP前台
#----------------------------------------
source /etc/profile
ROOT_DIR="/usr/local/nginx/html"


cd /data/svn/frontend
svn up --no-auth-cache --non-interactive |tee /root/script/release/svn.log
cd $ROOT_DIR
tar czf /root/backup/rollback/frontend/frontend_`date "+%Y%m%d%H%M_%S"`.tar.gz ./ --exclude="log"
rm -rf `ls|grep -v interface|grep -v moblieAdmin` && rm -rf .svn && rm -rf .htaccess
#rm -rf $ROOT_DIR/application/config.php
cp -pr /data/svn/frontend/* $ROOT_DIR && cp -pr /data/svn/frontend/*.htaccess $ROOT_DIR
chown root:root $ROOT_DIR/ -R
chmod -R 755 $ROOT_DIR/
chmod -R 777 $ROOT_DIR/log
chmod -R 777 $ROOT_DIR/error
chmod -R 777 $ROOT_DIR/upload
chmod -R 777 $ROOT_DIR/application/views
