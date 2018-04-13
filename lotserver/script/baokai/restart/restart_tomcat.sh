#!/bin/bash

source /etc/profile

function RESTART()
{
	PID=`ps -ef | grep java | grep "/$1/" | grep -v grep | awk '{print $2}'` 
	kill -9 $PID
	sleep 2s
	PID=`ps -ef | grep java | grep "/$1/" | grep -v grep | awk '{print $2}'` 
	[[ -z $PID ]] || kill -9 $PID
	
	/data/java/$1/bin/startup.sh
}

echo ""
echo -ne "请选择要重启SERVICE的序号: 1) api, 2) iapi, 3) im, 4) supui, 5) ui, 6) game, 7) web, 8) chart, 9) risk, 10) task, 0) all \t: "
read item
echo ""
echo -ne "确定要重启吗？y), n)  \t: "
read ask
if [ $ask == "y" -o $ask == "Y" ];then
	case $item in
		1)
			SERVICE="api"
			RESTART $SERVICE
			;;
		2)
			SERVICE="iapi"
			RESTART $SERVICE
			;;
		3)
			SERVICE="im"
			RESTART $SERVICE
			;;
                4)
                        SERVICE="supUi"
                        RESTART $SERVICE
                        ;;
                5)
                        SERVICE="ui"
                        RESTART $SERVICE
                        ;;
                6)
                        SERVICE="game"
                        RESTART $SERVICE
                        ;;
                7)
                        SERVICE="game-web"
                        RESTART $SERVICE
                        ;;
                8)
                        SERVICE="game-chart"
                        RESTART $SERVICE
                        ;;
                9)
                        SERVICE="game-risk"
                        RESTART $SERVICE
                        ;;
                10)
                        SERVICE="game-task"
                        RESTART $SERVICE
                        ;;
		0)
			SERVICE=(api iapi im supUi ui game game-web game-chart game-risk game-task)
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


