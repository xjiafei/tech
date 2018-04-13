#!/bin/bash

source /etc/profile

function RESTART()
{
	PID=`ps -ef | grep java | grep "/usr/local/dev/$1/" | grep -v grep | awk '{print $2}'` 
	kill -9 $PID
	sleep 2s
	PID=`ps -ef | grep java | grep "/usr/local/dev/$1/" | grep -v grep | awk '{print $2}'` 
	[[ -z $PID ]] || kill -9 $PID
	
	/usr/local/dev/$1/bin/startup.sh
}

echo ""
echo -ne "请选择要重启SERVICE的序号: 1) game, 2) game-web, 3) task, 4) risk, 5) chart, 6) all \t: "
read item
echo ""
#echo -ne "确定要重启吗？y), n)  \t: "
#read ask
ask="y"
if [ $ask == "y" -o $ask == "Y" ];then
	case $item in
		1)
			SERVICE="game"
			RESTART $SERVICE
			;;
		2)
			SERVICE="game-web"
			RESTART $SERVICE
			;;
		3)
			SERVICE="game-task"
			RESTART $SERVICE
			;;
		4)
			SERVICE="game-risk"
			RESTART $SERVICE
			;;
		5)
			SERVICE="game-chart"
			RESTART $SERVICE
			;;
		6)
			SERVICE=(game game-chart game-risk game-task game-web)
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
