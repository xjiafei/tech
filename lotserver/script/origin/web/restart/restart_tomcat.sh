#!/bin/bash

source /etc/profile

function RESTART()
{
	PID=`ps -ef | grep java | grep $1 | grep -v grep | awk '{print $2}'` 
	kill -9 $PID
	sleep 2s
	PID=`ps -ef | grep java | grep $1 | grep -v grep | awk '{print $2}'` 
	[[ -z $PID ]] || kill -9 $PID
	
	/opt/$1/bin/startup.sh
}

echo ""
echo -ne "请选择要重启SERVICE的序号: 1) game-web \t: "
read item
echo ""
echo -ne "确定要重启吗？y), n)  \t: "
read ask
if [ $ask == "y" -o $ask == "Y" ];then
	case $item in
		1)
			SERVICE="game-web"
			RESTART $SERVICE
			;;

		*)
			echo " invalid input, please check !!"
			;;
	esac
else
	echo "已取消操作!"
fi
