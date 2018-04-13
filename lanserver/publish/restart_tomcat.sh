#!/bin/bash

source /etc/profile

function RESTART()
{
	PID=`ps -ef | grep java | grep "/$1/" | grep -v grep | awk '{print $2}'` 
	kill -9 $PID
	sleep 2s
	PID=`ps -ef | grep java | grep "/$1/" | grep -v grep | awk '{print $2}'` 
	[[ -z $PID ]] || kill -9 $PID
	
	/opt/logistics/$1/bin/startup.sh
}

echo ""
echo -ne "请选择要重启SERVICE的序号: 1) app, 2) web, 3) device, 4) system, 5) transport, 0) all \t: "
read item
echo ""
echo -ne "确定要重启吗？y), n)  \t: "
read ask
if [ $ask == "y" -o $ask == "Y" ];then
	case $item in
		1)
			SERVICE="logistics-app"
			RESTART $SERVICE
			;;
		2)
			SERVICE="logistics-web"
			RESTART $SERVICE
			;;
		3)
			SERVICE="logistics-device"
			RESTART $SERVICE
			;;
                4)
                        SERVICE="logistics-system"
                        RESTART $SERVICE
                        ;;
                5)
                        SERVICE="logistics-transport"
                        RESTART $SERVICE
                        ;;
		0)
			SERVICE=(logistics-app logistics-web logistics-device logistics-system logistics-transport)
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


