#!/bin/sh

#----------------------------------------
#用途:发布PHP前台
#----------------------------------------

source /etc/profile
cd /usr/local/dev
#tar czf /root/backup/rollback/frontend_`date "+%Y%m%d%H%M_%S"`.tar.gz ./ --exclude="log"
#rm -rf /usr/local/dev/application/config.php
/usr/bin/svn up
chown hkdev:hkdev /usr/local/dev/ -R
chmod -R 755 /usr/local/dev/
chmod -R 777 /usr/local/dev/log
chmod -R 777 /usr/local/dev/error
chmod -R 777 /usr/local/dev/upload
chmod -R 777 /usr/local/dev/application/views

sed -i "s/\/usr\/local\/conf\//\/usr\/local\/conf-dev\//g" /usr/local/dev/application/config.php
sed -i "s/\/usr\/local\/conf\//\/usr\/local\/conf-dev\//g" /usr/local/dev/application/blockmode.php
#sed -i "s/6379/16379/g" /usr/local/dev/application/redis.php
#sed -i "s/6379/16379/g" /usr/local/dev/application/bootstrap.php
#sed -i "s/6379/16379/g" /usr/local/dev/application/lib/Rediska/Connection.php

