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

BACKUP_PATH="/data/backup"              #new目录保存最新编译版本的包，rollback目录保存原始备份包
SVN_PATH="/data/svn"
CFG_PATH="/usr/local/config"


function api()
{

        kill -9  `ps -ef | grep java | grep "/api/" | grep -v grep | awk -F" " '{print $2}'`

        cd /data/java/api/webapps/ROOT
        tar czf $BACKUP_PATH/rollback/api/winter-firefrog.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
        rm -fr *
        mv $SVN_PATH/winter-firefrog/target/winter-firefrog.war /data/java/api/webapps/ROOT
        unzip winter-firefrog.war
        \cp winter-firefrog.war $BACKUP_PATH/new/api/
        rm -fr winter-firefrog.war
       
        /data/java/api/bin/startup.sh
}

function iapi()
{

        kill -9  `ps -ef | grep java | grep "/iapi/" | grep -v grep | awk -F" " '{print $2}'`

        cd /data/java/iapi/webapps/ROOT
        tar czf $BACKUP_PATH/rollback/iapi/winter-firefrog-phone.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
        rm -fr *
        mv $SVN_PATH/winter-firefrog-phone/target/winter-firefrog-phone.war /data/java/iapi/webapps/ROOT
        unzip winter-firefrog-phone.war
        \cp winter-firefrog-phone.war $BACKUP_PATH/new/iapi/
        rm -fr winter-firefrog-phone.war
        rm -fr WEB-INF/lib/winter-game-common-1.0.jar
        cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/ 

        /data/java/iapi/bin/startup.sh
}

function im()
{

	kill -9 `ps aux | grep "/im/" | grep java |grep -v grep | awk '{print $2}'`
	
	cd /data/java/im/webapps/ROOT/
	tar czf $BACKUP_PATH/rollback/im/im-ROOT.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-firefrog-webim/target/ROOT.war /data/java/im/webapps/ROOT/
	unzip ROOT.war
	\cp -p ROOT.war $BACKUP_PATH/new/im/
	rm -fr ROOT.war

	/data/java/im/bin/startup.sh
	echo "IM Release Success。"
}

function supui()
{

	kill -9 `ps aux | grep "/supUi/" | grep java |grep -v grep | awk '{print $2}'`

	cd /data/java/supUi/webapps/ROOT/
	tar czf $BACKUP_PATH/rollback/supui/supui-ROOT.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	
	mv $SVN_PATH/winter-firefrog-support/target/ROOT.war /data/java/supUi/webapps/ROOT/
	unzip ROOT.war
	\cp -p ROOT.war $BACKUP_PATH/new/supui/
	rm -fr ROOT.war

	/data/java/supUi/bin/startup.sh
	echo "SUPPORT Release Success。"
}
function ui()
{
	
	kill -9 `ps aux | grep "/ui/" | grep java |grep -v grep | awk '{print $2}'`
	
	cd /data/java/ui/webapps/ROOT/
	tar czf $BACKUP_PATH/rollback/ui/ui-winter-firefrog.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	
	cd front/
	rm -fr *
	mv $SVN_PATH/winter-firefrog-web/target/winter-firefrog-web.war /data/java/ui/webapps/ROOT/front/
	unzip winter-firefrog-web.war
	\cp -p winter-firefrog-web.war $BACKUP_PATH/new/ui/
	rm -fr winter-firefrog-web.war
	
	rm -fr /data/java/ui/webapps/ROOT/admin/*
	cp -fr /data/java/ui/webapps/ROOT/front/* /data/java/ui/webapps/ROOT/admin/
	
	/data/java/ui/bin/startup.sh
	echo "UI Release Success。"
}

function game()
{

	kill -9  `ps -ef | grep java | grep game | grep -v game- | grep -v grep | awk -F" " '{print $2}'`

	cd /data/java/game/webapps/ROOT/
	tar -zcf $BACKUP_PATH/rollback/game/winter-game.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-game/target/winter-game.war /data/java/game/webapps/ROOT/
	unzip winter-game.war
	\cp -p winter-game.war $BACKUP_PATH/new/game/
	rm -fr winter-game.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	
	\cp -f $CFG_PATH/game/*.properties  WEB-INF/classes/
	/data/java/game/bin/startup.sh
}


function web()
{

	kill -9  `ps -ef | grep java | grep web | grep -v grep | awk -F" " '{print $2}'`

	cd /data/java/game-web/webapps/ROOT/
	tar czf $BACKUP_PATH/rollback/game-web/winter-game-web.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	
	cd front/
	rm -rf *
	cp -fr $SVN_PATH/winter-game-web/target/winter-game-web.war /data/java/game-web/webapps/ROOT/front/
	unzip winter-game-web.war
	\cp -p winter-game-web.war $BACKUP_PATH/new/game-web/
	rm -fr winter-game-web.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	\cp -f $CFG_PATH/game-web/*.properties WEB-INF/classes/
	
	rm -fr /data/java/game-web/webapps/ROOT/admin/*
	cp -fr /data/java/game-web/webapps/ROOT/front/* /data/java/game-web/webapps/ROOT/admin/
	/data/java/game-web/bin/startup.sh

}

function chart()
{

	kill -9  `ps -ef | grep java | grep chart | grep -v grep | awk -F" " '{print $2}'`

	cd /data/java/game-chart/webapps/ROOT
	tar czf $BACKUP_PATH/rollback/game-chart/winter-game-chart.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-game-chart/target/winter-game-chart.war /data/java/game-chart/webapps/ROOT
	unzip winter-game-chart.war
	\cp winter-game-chart.war $BACKUP_PATH/new/game-chart/
	rm -fr winter-game-chart.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	\cp -f $CFG_PATH/game-chart/db.properties $CFG_PATH/game-chart/redis.properties $CFG_PATH/game-chart/application.properties WEB-INF/classes/ 
	
	/data/java/game-chart/bin/startup.sh

}

function risk()
{

	kill -9  `ps -ef | grep java | grep risk | grep -v grep | awk -F" " '{print $2}'`

	cd /data/java/game-risk/webapps/ROOT
	tar czf $BACKUP_PATH/rollback/game-risk/winter-game-risk.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-game-risk/target/winter-game-risk.war /data/java/game-risk/webapps/ROOT
	unzip winter-game-risk.war
	\cp winter-game-risk.war $BACKUP_PATH/new/game-risk/
	rm -fr winter-game-risk.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	\cp -f $CFG_PATH/game-risk/db.properties $CFG_PATH/game-risk/redis.properties $CFG_PATH/game-risk/application.properties WEB-INF/classes/
	
	/data/java/game-risk/bin/startup.sh

}

function task()
{

	kill -9  `ps -ef | grep java | grep task | grep -v grep | awk -F" " '{print $2}'`

	cd /data/java/game-task/webapps/ROOT
	tar czf $BACKUP_PATH/rollback/game-task/winter-game-task.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-game-task/target/winter-game-task.war /data/java/game-task/webapps/ROOT
	unzip winter-game-task.war
	\cp winter-game-task.war $BACKUP_PATH/new/game-task/
	rm -fr winter-game-task.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	cp -fr $CFG_PATH/game-task/*.properties WEB-INF/classes/
	
	/data/java/game-task/bin/startup.sh

}


function all()
{
	api
	iapi
	im
	supui
	ui
	game
	web
	risk
	chart
	task
}

case $1 in
	"api")
			api
			;;
	"iapi")
			iapi
			;;
	"im")
			im
			;;
	"supui")
			supui
			;;
	"ui")
			ui
			;;
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
			echo "not found trunk service release!";;
esac


