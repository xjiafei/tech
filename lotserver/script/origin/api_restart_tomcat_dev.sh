#!/bin/bash

source /etc/profile

function RESTART()
{
	PID=`ps -ef | grep java | grep "dev/$1/" | grep -v grep | awk '{print $2}'` 
	kill -9 $PID
	sleep 2s
	PID=`ps -ef | grep java | grep "dev/$1/" | grep -v grep | awk '{print $2}'` 
	[[ -z $PID ]] || kill -9 $PID
	
	/usr/local/dev/$1/bin/startup.sh
}

echo ""
echo -ne "请选择要重启SERVICE的序号: 1) api, 2) im, 3) supUi, 4) ui, 5) iapi, 6) all \t: "
read item
echo ""
#echo -ne "确定要重启吗？y), n)  \t: "
#read ask
ask="y"
if [ $ask == "y" -o $ask == "Y" ];then
	case $item in
		1)
			SERVICE="api"
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
			SERVICE="ui"
			RESTART $SERVICE
			;;
		5)
			SERVICE="iapi"
			RESTART $SERVICE
			;;
		6)
			SERVICE=(api im supUi ui iapi)
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
