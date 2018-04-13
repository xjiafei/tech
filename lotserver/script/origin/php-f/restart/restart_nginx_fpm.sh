#!/bin/bash

source /etc/profile

pkill nginx && pkill php-fpm
sleep 2s
PID=`ps -ef |grep nginx |grep -v grep`
until [ -z $PID ]
do
	pkill nginx
	sleep 2s
	PID=`ps -ef |grep nginx |grep -v grep`
done

PID=`ps -ef |grep php-fpm |grep -v grep`
until [ -z $PID ]
do
	pkill php-fpm
	sleep 2s
	PID=`ps -ef |grep php-fpm |grep -v grep`
done

/usr/local/php5.3.3/sbin/php-fpm  -c /usr/local/php5.3.3/etc/php.ini  -y /usr/local/php5.3.3/etc/php-fpm.conf 
sleep 2s
/usr/local/nginx/sbin/nginx

