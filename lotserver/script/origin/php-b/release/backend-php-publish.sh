#!/bin/sh

#----------------------------------------
#用途:发布PHP后台
#----------------------------------------
source /etc/profile
ROOT_DIR="/usr/local/nginx/html"

> /root/script/release/svn.log

cd $ROOT_DIR
tar czf /root/backup/rollback/backend_`date "+%Y%m%d%H%M_%S"`.tar.gz ./ --exclude="log"
rm -rf * && rm -rf .svn && rm -rf .htaccess
#rm -rf $ROOT_DIR/application/config.php
cd /root/svn_trunk
/usr/bin/svn up |tee /root/script/release/svn.log
cp -pr /root/svn_trunk/* $ROOT_DIR && cp -pr /root/svn_trunk/.svn $ROOT_DIR && cp -pr /root/svn_trunk/*.htaccess $ROOT_DIR
chown root:root $ROOT_DIR/ -R
chmod -R 755 $ROOT_DIR/
chmod -R 777 $ROOT_DIR/log
chmod -R 777 $ROOT_DIR/error
chmod -R 777 $ROOT_DIR/upload
chmod -R 777 $ROOT_DIR/application/views
