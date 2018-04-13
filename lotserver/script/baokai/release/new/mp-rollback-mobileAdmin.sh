#!/bin/sh

####################使用說明##########################################
#
#使用方式 ./rollback.sh 回滚文件名 (提示：绝对路径、相对路径都可以)
#
######################################################################
source /etc/profile

FILE=$(basename $1)
echo ""
echo -ne "确定要回滚【MP】吗？y), n)  \t: "
read ask
if [ $ask == "y" -o $ask == "Y" ];then
	if [ -f "/data/backup/rollback/moblieAdmin/interface/$FILE" ]; then
		cd /usr/local/nginx/html/moblieAdmin/interface
		rm -rf * && rm -rf .svn/
		tar zxf /data/backup/rollback/moblieAdmin/interface/$FILE -C /usr/local/nginx/html
		chown root:root /usr/local/nginx/html/ -R
	else
		echo "指定的文件不存在！"
	fi
	;;

else
	echo "已取消回滚操作!"
fi
