#!/bin/sh

####################使用說明##########################################
#
#使用方式 ./rollback.sh 回滚文件名 (提示：绝对路径、相对路径都可以)
#
######################################################################
source /etc/profile

function RollBack()
{
	if [ $1 == "game" ];then
		PID=`ps -ef | grep java |grep $1 | grep -v game- | grep -v grep | awk '{print $2}'` 
		until [ -z $PID ]
		do
			kill -9 $PID
			sleep 2s
			PID=`ps -ef | grep java |grep $1 | grep -v game- | grep -v grep | awk '{print $2}'`
			
		done
	else
		PID=`ps -ef | grep java | grep $1 | grep -v grep | awk '{print $2}'` 
		until [ -z $PID ]
		do
			kill -9 $PID
			sleep 2s
			PID=`ps -ef | grep java | grep $1 | grep -v grep | awk '{print $2}'` 
			
		done
	fi

	rm -rf /data/java/$1/webapps/ROOT/*
	tar -zxf /data/backup/rollback/$1/$2 -C /data/java/$1/webapps/ROOT/
	/data/java/$1/bin/startup.sh

}

FILE=$(basename $1)
echo ""
echo -ne "请选择要回滚SERVICE的序号: 1) api, 2) iapi, 3) im, 4) supui, 5) ui, 6) game, 7) web, 8) chart, 9) risk, 10) task \t: "
read item
echo ""
echo -ne "确定要回滚吗？y), n)  \t: "
read ask
if [ $ask == "y" -o $ask == "Y" ];then
	case $item in
		1)
			SERVICE="api"
			if [ -f "/data/backup/rollback/$SERVICE/$FILE" ]; then
				RollBack $SERVICE $FILE
			else
				echo "指定的文件不存在或选择回滚的Service和回滚文件不匹配！"
			fi
			;;
		2)
			SERVICE="iapi"
			if [ -f "/data/backup/rollback/$SERVICE/$FILE" ]; then
				RollBack $SERVICE $FILE
			else
				echo "指定的文件不存在或选择回滚的Service和回滚文件不匹配！"
			fi
			;;
		3)
			SERVICE="im"
			if [ -f "/data/backup/rollback/$SERVICE/$FILE" ]; then
				RollBack $SERVICE $FILE
			else
				echo "指定的文件不存在或选择回滚的Service和回滚文件不匹配！"
			fi
			;;
		4)
			SERVICE="supui"
			if [ -f "/data/backup/rollback/$SERVICE/$FILE" ]; then
				RollBack $SERVICE $FILE
			else
				echo "指定的文件不存在或选择回滚的Service和回滚文件不匹配！"
			fi
			;;
		5)
			SERVICE="ui"
			if [ -f "/data/backup/rollback/$SERVICE/$FILE" ]; then
				RollBack $SERVICE $FILE
			else
				echo "指定的文件不存在或选择回滚的Service和回滚文件不匹配！"
			fi
			;;
		6)
			SERVICE="game"
			if [ -f "/data/backup/rollback/$SERVICE/$FILE" ]; then
				RollBack $SERVICE $FILE
			else
				echo "指定的文件不存在或选择回滚的Service和回滚文件不匹配！"
			fi
			;;
		7)
			SERVICE="web"
			if [ -f "/data/backup/rollback/$SERVICE/$FILE" ]; then
				RollBack $SERVICE $FILE
			else
				echo "指定的文件不存在或选择回滚的Service和回滚文件不匹配！"
			fi
			;;
		8)
			SERVICE="game-chart"
			if [ -f "/data/backup/rollback/$SERVICE/$FILE" ]; then
				RollBack $SERVICE $FILE
			else
				echo "指定的文件不存在或选择回滚的Service和回滚文件不匹配！"
			fi
			;;
		9)
			SERVICE="game-risk"
			if [ -f "/data/backup/rollback/$SERVICE/$FILE" ]; then
				RollBack $SERVICE $FILE
			else
				echo "指定的文件不存在或选择回滚的Service和回滚文件不匹配！"
			fi
			;;	
		10)
			SERVICE="game-task"
			if [ -f "/data/backup/rollback/$SERVICE/$FILE" ]; then
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