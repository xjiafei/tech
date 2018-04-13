#!/bin/sh

####################使用說明##########################################
#
#使用方式 ./rollback.sh 回滚文件名 (提示：绝对路径、相对路径都可以)
#
######################################################################
source /etc/profile

function RollBack()
{
	PID=`ps -ef | grep java | grep "/$1/" | grep -v grep | awk '{print $2}'` 
	until [ -z $PID ]
	do
		kill -9 $PID
		sleep 2s
		PID=`ps -ef | grep java | grep "/$1/" | grep -v grep | awk '{print $2}'` 
		
	done
	
	rm -rf /opt/$1/webapps/ROOT/*
	tar -zxf /root/backup/rollback/$1/$2 -C /opt/$1/webapps/ROOT/
	/opt/$1/bin/startup.sh

}

FILE=$(basename $1)
echo ""
echo -ne "请选择要回滚SERVICE的序号: 1) UI, 2) IM, 3) supUi \t: "
read item
echo ""
echo -ne "确定要回滚吗？y), n)  \t: "
read ask
if [ $ask == "y" -o $ask == "Y" ];then
	case $item in
		1)
			SERVICE="ui"
			if [ -f "/root/backup/rollback/$SERVICE/$FILE" ]; then
				RollBack $SERVICE $FILE
			else
				echo "指定的文件不存在或选择回滚的Service和回滚文件不匹配！"
			fi
			;;
		2)
			SERVICE="im"
			if [ -f "/root/backup/rollback/$SERVICE/$FILE" ]; then
				RollBack $SERVICE $FILE
			else
				echo "指定的文件不存在或选择回滚的Service和回滚文件不匹配！"
			fi
			;;	
		3)
			SERVICE="supUi"
			if [ -f "/root/backup/rollback/$SERVICE/$FILE" ]; then
				RollBack $SERVICE $FILE
			else
				echo "指定的文件不存在或选择回滚的Service和回滚文件不匹配！"
			fi
			;;
		*)
			echo " invalid input, please check !!"
			;;
	esac
else
	echo "已取消回滚操作!"
fi
