#!/bin/sh

####################使用說明##########################################
#
#使用方式 ./rollback.sh 回滚文件名 (提示：绝对路径、相对路径都可以)
#
######################################################################
source /etc/profile

FILE=$(basename $1)
echo ""
echo -ne "确定要回滚【STATIC】吗？y), n)  \t: "
read ask
if [ $ask == "y" -o $ask == "Y" ];then
	if [ -f "/data/backup/rollback/static/$FILE" ]; then
		cd /home/img-server/static
		rm -rf * && rm -rf .svn/
		tar zxf /data/backup/rollback/static/$FILE -C /home/img-server/static
		chown root:root /home/img-server/static/ -R
	else
		echo "指定的文件不存在！"
	fi
	;;

else
	echo "已取消回滚操作!"
fi
