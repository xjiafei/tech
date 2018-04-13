#!/bin/bash

source /etc/profile

function KILL()
{
	PID=`ps -ef | grep java | grep "/$1/" | grep -v grep | awk '{print $2}'` 
	kill -9 $PID
	sleep 2s
	PID=`ps -ef | grep java | grep "/$1/" | grep -v grep | awk '{print $2}'` 
	[[ -z $PID ]] || kill -9 $PID
	
}

echo ""
echo -ne "请选择要停止SERVICE的序号: 1) app, 2) web, 3) device, 4) system, 5) transport, 0) all \t: "
read item
echo ""
echo -ne "确定要停止吗？y), n)  \t: "
read ask
if [ $ask == "y" -o $ask == "Y" ];then
	case $item in
		1)
			SERVICE="logistics-app"
			KILL $SERVICE
			;;
		2)
			SERVICE="logistics-web"
			KILL $SERVICE
			;;
		3)
			SERVICE="logistics-device"
			KILL $SERVICE
			;;
                4)
                        SERVICE="logistics-system"
                        KILL $SERVICE
                        ;;
                5)
                        SERVICE="logistics-transport"
                        KILL $SERVICE
                        ;;
		0)
			SERVICE=(logistics-app logistics-web logistics-device logistics-system logistics-transport)
			for me in ${SERVICE[@]};do
				KILL $me
			done
			;;
		*)
			echo " invalid input, please check !!"
			;;
	esac
else
	echo "已取消操作!"
fi


