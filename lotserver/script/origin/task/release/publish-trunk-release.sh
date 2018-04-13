#!/bin/bash

#------------------------------------------------
#用途:trunk下 RISK、CHART、TASK、ALL release
#
#参数1 risk    ; publish-trunk-release.sh  risk
#参数2 task    ; publish-trunk-release.sh  task
#参数3 chart   ; publish-trunk-release.sh  chart
#参数4 all     ; publish-trunk-release.sh  all
#------------------------------------------------
source /etc/profile

BACKUP_PATH="/root/backup"              #new目录保存最新编译版本的包，rollback目录保存原始备份包
SVN_PATH="/root/svn_trunk"
CFG_PATH="/usr/local/config"


function chart()
{

	kill -9  `ps -ef | grep java | grep chart | grep -v grep | awk -F" " '{print $2}'`

	cd /opt/game-chart/webapps/ROOT
	tar czf $BACKUP_PATH/rollback/game-chart/winter-game-chart-1.0.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-game-chart/target/winter-game-chart-1.0.war /opt/game-chart/webapps/ROOT
	unzip winter-game-chart-1.0.war
	\cp winter-game-chart-1.0.war $BACKUP_PATH/new/game-chart/
	rm -fr winter-game-chart-1.0.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	\cp -f $CFG_PATH/game-chart/db.properties $CFG_PATH/game-chart/redis.properties $CFG_PATH/game-chart/application.properties WEB-INF/classes/ 
	
	/opt/game-chart/bin/startup.sh

}

function risk()
{

	kill -9  `ps -ef | grep java | grep risk | grep -v grep | awk -F" " '{print $2}'`

	cd /opt/game-risk/webapps/ROOT
	tar czf $BACKUP_PATH/rollback/game-risk/winter-game-risk.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-game-risk/target/winter-game-risk.war /opt/game-risk/webapps/ROOT
	unzip winter-game-risk.war
	\cp winter-game-risk.war $BACKUP_PATH/new/game-risk/
	rm -fr winter-game-risk.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	\cp -f $CFG_PATH/game-risk/db.properties $CFG_PATH/game-risk/redis.properties $CFG_PATH/game-risk/application.properties WEB-INF/classes/
	
	/opt/game-risk/bin/startup.sh

}

function task()
{

	kill -9  `ps -ef | grep java | grep task | grep -v grep | awk -F" " '{print $2}'`

	cd /opt/game-task/webapps/ROOT
	tar czf $BACKUP_PATH/rollback/game-task/winter-game-task-1.0.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-game-task/target/winter-game-task.war /opt/game-task/webapps/ROOT
	unzip winter-game-task.war
	\cp winter-game-task.war $BACKUP_PATH/new/game-task/
	rm -fr winter-game-task.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	cp -fr $CFG_PATH/game-task/*.properties WEB-INF/classes/
	
	/opt/game-task/bin/startup.sh

}


function all()
{
	risk
	chart
	task
}

case $1 in
        "risk")
			risk
			;;
        "chart")
			chart
			;;
        "task")
			task
			;;
        "all")
			all
			;;
        *)
			echo "not found trunk service release!";;
esac


