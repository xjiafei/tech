#!/bin/bash

source /etc/profile

function RESTART()
{
	PID=`ps -ef | grep java | grep "/$1/" | grep -v grep | awk '{print $2}'` 
	kill -9 $PID
	sleep 2s
	PID=`ps -ef | grep java | grep "/$1/" | grep -v grep | awk '{print $2}'` 
	[[ -z $PID ]] || kill -9 $PID
	
	/opt/$1/bin/startup.sh
}

echo ""
echo -ne "请选择要重启SERVICE的序号: 1) UI, 2) IM, 3) supUi, 4) all \t: "
read item
echo ""
echo -ne "确定要重启吗？y), n)  \t: "
read ask
if [ $ask == "y" -o $ask == "Y" ];then
	case $item in
		1)
			SERVICE="ui"
			RESTART $SERVICE
			;;
		2)
			SERVICE="im"
			RESTART $SERVICE
			;;
		3)
			SERVICE="supUi"
			RESTART $SERVICE
			;;
		4)
			SERVICE=(ui im supUi)
			for me in ${SERVICE[@]};do
				RESTART $me
			done
			;;
		*)
			echo " invalid input, please check !!"
			;;
	esac
else
	echo "已取消操作!"
fi
