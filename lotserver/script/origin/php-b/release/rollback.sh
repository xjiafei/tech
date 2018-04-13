#!/bin/sh

####################使用說明##########################################
#
#使用方式 ./rollback.sh 回滚文件名 (提示：绝对路径、相对路径都可以)
#
######################################################################
source /etc/profile

FILE=$(basename $1)
echo ""
echo -ne "确定要回滚【PHP后台】吗？y), n)  \t: "
read ask
if [ $ask == "y" -o $ask == "Y" ];then
	if [ -f "/root/backup/rollback/$FILE" ]; then
		cd /usr/local/nginx/html
		rm -rf * && rm -rf .svn/
		tar zxf /root/backup/rollback/$FILE -C /usr/local/nginx/html
		chown root:root /usr/local/nginx/html/ -R
		chmod -R 755 /usr/local/nginx/html/
		chmod -R 777 /usr/local/nginx/html/log
		chmod -R 777 /usr/local/nginx/html/error
		chmod -R 777 /usr/local/nginx/html/upload
		chmod -R 777 /usr/local/nginx/html/application/views
	else
		echo "指定的文件不存在！"
	fi
	;;

else
	echo "已取消回滚操作!"
fi
