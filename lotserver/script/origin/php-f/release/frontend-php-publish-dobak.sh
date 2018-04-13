#!/bin/sh

#----------------------------------------
#用途:发布PHP前台
#----------------------------------------
source /etc/profile
ROOT_DIR="/usr/local/nginx/html"

cd $ROOT_DIR
tar czf /root/backup/rollback/frontend_`date "+%Y%m%d%H%M_%S"`.tar.gz ./ --exclude="log"
rm -rf * && rm -rf .svn && rm -rf .htaccess
#rm -rf $ROOT_DIR/application/config.php
