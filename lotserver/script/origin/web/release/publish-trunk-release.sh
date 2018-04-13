#!/bin/bash

#----------------------------------------------
#用途:trunk下 WEB、ALL release
#  
#参数1 web     ; publish-trunk-release.sh  web
#参数2 all     ; publish-trunk-release.sh  all
#----------------------------------------------
source /etc/profile

BACKUP_PATH="/root/backup"              #new目录保存最新编译版本的包，rollback目录保存原始备份包
SVN_PATH="/root/svn_trunk"
CFG_PATH="/usr/local/config"

function web()
{

	kill -9  `ps -ef | grep java | grep web | grep -v grep | awk -F" " '{print $2}'`

	cd /opt/game-web/webapps/ROOT/
	tar czf $BACKUP_PATH/rollback/game-web/winter-game-web.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	
	cd front/
	rm -rf *
	cp -fr $SVN_PATH/winter-game-web/target/winter-game-web.war /opt/game-web/webapps/ROOT/front/
	unzip winter-game-web.war
	\cp -p winter-game-web.war $BACKUP_PATH/new/game-web/
	rm -fr winter-game-web.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	\cp -f $CFG_PATH/game-web/*.properties WEB-INF/classes/
	
	rm -fr /opt/game-web/webapps/ROOT/admin/*
	cp -fr /opt/game-web/webapps/ROOT/front/* /opt/game-web/webapps/ROOT/admin/
	/opt/game-web/bin/startup.sh

}

function all()
{
	web
}

case $1 in
	"web")
		web
		;;
	"all")
		all
		;;
	*)
		echo "not found trunk service release!";;
esac

