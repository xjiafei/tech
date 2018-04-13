#!/bin/sh

#----------------------------------------
#用途:发布PHP前台
#----------------------------------------
source /etc/profile
ROOT_DIR="/usr/local/nginx/html"

cp -pr /root/svn_trunk/* $ROOT_DIR && cp -pr /root/svn_trunk/.svn $ROOT_DIR && cp -pr /root/svn_trunk/*.htaccess $ROOT_DIR
chown root:root $ROOT_DIR/ -R
chmod -R 755 $ROOT_DIR/
chmod -R 777 $ROOT_DIR/log
chmod -R 777 $ROOT_DIR/error
chmod -R 777 $ROOT_DIR/upload
chmod -R 777 $ROOT_DIR/application/views
