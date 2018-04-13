#!/bin/bash

#------------------------------------------------
#用途:branch下GAME、GAME-WEB、RISK、CHART、TASK、ALL release
#
#参数 game    ; publish-trunk-release.sh  game
#参数 web     ; publish-trunk-release.sh  web
#参数 risk    ; publish-trunk-release.sh  risk
#参数 task    ; publish-trunk-release.sh  task
#参数 chart   ; publish-trunk-release.sh  chart
#参数 all     ; publish-trunk-release.sh  all
#------------------------------------------------
source /etc/profile

BACKUP_PATH="/root/backup"              #new目录保存最新编译版本的包，rollback目录保存原始备份包
SVN_PATH="/home/hkdev/svn_dev"
CFG_PATH="/usr/local/config-dev"

cp -frvp /usr/local/repository/com/winterframework $SVN_PATH/
rm -fr /usr/local/repository/com/winterframework/winter-rest

#调用编译脚本
PWD_PATH="/home/hkdev/script"
source $PWD_PATH/dev-compiler.sh



function game()
{
	game_compile
	
	kill -9  `ps -ef | grep java |grep "dev/game/" | grep -v "dev/game-" | grep -v grep | awk -F" " '{print $2}'`

	cd /usr/local/dev/game/webapps/ROOT/
	#tar -zcf $BACKUP_PATH/rollback/game/winter-game.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-game/target/winter-game.war /usr/local/dev/game/webapps/ROOT/
	unzip winter-game.war
	#\cp -p winter-game.war $BACKUP_PATH/new/game/
	rm -fr winter-game.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	
	\cp -f $CFG_PATH/game/*.properties  WEB-INF/classes/
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/game/webapps/ROOT/WEB-INF/spring-mvc.xml
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/game/webapps/ROOT/WEB-INF/classes/applicationContext-resource.xml
	
	/usr/local/dev/game/bin/startup.sh
}

function web()
{
	web_compile
	
	kill -9  `ps -ef | grep java | grep "dev/game-web/" | grep -v grep | awk -F" " '{print $2}'`

	cd /usr/local/dev/game-web/webapps/ROOT/
	#tar czf $BACKUP_PATH/rollback/game-web/winter-game-web.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	
	cd front/
	rm -rf *
	cp -fr $SVN_PATH/winter-game-web/target/winter-game-web.war /usr/local/dev/game-web/webapps/ROOT/front/
	unzip winter-game-web.war
	#\cp -p winter-game-web.war $BACKUP_PATH/new/game-web/
	rm -fr winter-game-web.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	\cp -f $CFG_PATH/game-web/*.properties WEB-INF/classes/
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/game-web/webapps/ROOT/front/WEB-INF/spring-mvc.xml
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/game-web/webapps/ROOT/front/WEB-INF/classes/applicationContext.xml
	
	rm -fr /usr/local/dev/game-web/webapps/ROOT/admin/*
	cp -fr /usr/local/dev/game-web/webapps/ROOT/front/* /usr/local/dev/game-web/webapps/ROOT/admin/
		
	/usr/local/dev/game-web/bin/startup.sh

}


function chart()
{
	chart_compile
	
	kill -9  `ps -ef | grep java | grep "dev/game-chart/" | grep -v grep | awk -F" " '{print $2}'`

	cd /usr/local/dev/game-chart/webapps/ROOT
	#tar czf $BACKUP_PATH/rollback/game-chart/winter-game-chart-1.0.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-game-chart/target/winter-game-chart-1.0.war /usr/local/dev/game-chart/webapps/ROOT
	unzip winter-game-chart-1.0.war
	#\cp winter-game-chart-1.0.war $BACKUP_PATH/new/game-chart/
	rm -fr winter-game-chart-1.0.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	\cp -f $CFG_PATH/game-chart/db.properties $CFG_PATH/game-chart/redis.properties $CFG_PATH/game-chart/application.properties WEB-INF/classes/ 
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/game-chart/webapps/ROOT/WEB-INF/spring-mvc.xml
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/game-chart/webapps/ROOT/WEB-INF/classes/applicationContext-resource.xml
	
	/usr/local/dev/game-chart/bin/startup.sh

}

function risk()
{
	risk_compile
	
	kill -9  `ps -ef | grep java | grep "dev/game-risk/" | grep -v grep | awk -F" " '{print $2}'`

	cd /usr/local/dev/game-risk/webapps/ROOT
	#tar czf $BACKUP_PATH/rollback/game-risk/winter-game-risk.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-game-risk/target/winter-game-risk.war /usr/local/dev/game-risk/webapps/ROOT
	unzip winter-game-risk.war
	#\cp winter-game-risk.war $BACKUP_PATH/new/game-risk/
	rm -fr winter-game-risk.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	\cp -f $CFG_PATH/game-risk/db.properties $CFG_PATH/game-risk/redis.properties $CFG_PATH/game-risk/application.properties WEB-INF/classes/
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/game-risk/webapps/ROOT/WEB-INF/classes/applicationContext-resource.xml
	
	/usr/local/dev/game-risk/bin/startup.sh

}

function task()
{
	task_compile

	kill -9  `ps -ef | grep java | grep "dev/game-task/" | grep -v grep | awk -F" " '{print $2}'`

	cd /usr/local/dev/game-task/webapps/ROOT
	#tar czf $BACKUP_PATH/rollback/game-task/winter-game-task-1.0.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-game-task/target/winter-game-task.war /usr/local/dev/game-task/webapps/ROOT
	unzip winter-game-task.war
	#\cp winter-game-task.war $BACKUP_PATH/new/game-task/
	rm -fr winter-game-task.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	cp -fr $CFG_PATH/game-task/*.properties WEB-INF/classes/
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/game-task/webapps/ROOT/WEB-INF/classes/applicationContext-resource.xml
	
	/usr/local/dev/game-task/bin/startup.sh

}


function all()
{
	game
	web
	risk
	chart
	task
}

case $1 in
	"game")
		game
		;;
	"web")
		web
		;;
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
		echo "not found branch service release!";;
esac


