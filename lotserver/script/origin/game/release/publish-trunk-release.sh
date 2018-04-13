#!/bin/bash

#-----------------------------------------------
#用途:trunk下 GAME、ALL release
#  
#参数1 game    ; publish-trunk-release.sh  game
#参数2 all     ; publish-trunk-release.sh  all
#-----------------------------------------------
source /etc/profile

BACKUP_PATH="/root/backup"		#new目录保存最新编译版本的包，rollback目录保存原始备份包
SVN_PATH="/root/svn_trunk"
CFG_PATH="/usr/local/config"

function game()
{

	kill -9  `ps -ef | grep java | grep -v game- | grep -v grep | awk -F" " '{print $2}'`

	cd /opt/game/webapps/ROOT/
	tar -zcf $BACKUP_PATH/rollback/game/winter-game.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-game/target/winter-game.war /opt/game/webapps/ROOT/
	unzip winter-game.war
	\cp -p winter-game.war $BACKUP_PATH/new/game/
	rm -fr winter-game.war
	rm -fr WEB-INF/lib/winter-game-common-1.0.jar
	cp -fr $SVN_PATH/winter-game-common/target/winter-game-common-1.0.jar WEB-INF/lib/
	
	\cp -f $CFG_PATH/game/*.properties  WEB-INF/classes/
	/opt/game/bin/startup.sh
}

function all()
{
        game
}


case $1 in
        "game")
                game
		;;
        "all")
                all
                ;;
        *)
                echo "not found trunk service release!";;
esac
