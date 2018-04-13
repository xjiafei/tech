#!/bin/sh

#----------------------------------------
#用途:发布PHP前台
#----------------------------------------

source /etc/profile
cd /usr/local/nginx/html
#tar czf /root/backup/rollback/frontend_`date "+%Y%m%d%H%M_%S"`.tar.gz ./ --exclude="log"
#rm -rf /usr/local/nginx/html/application/config.php
/usr/bin/svn up
chown root:root /usr/local/nginx/html/ -R
chmod -R 755 /usr/local/nginx/html/
chmod -R 777 /usr/local/nginx/html/log
chmod -R 777 /usr/local/nginx/html/error
chmod -R 777 /usr/local/nginx/html/upload
chmod -R 777 /usr/local/nginx/html/application/views

