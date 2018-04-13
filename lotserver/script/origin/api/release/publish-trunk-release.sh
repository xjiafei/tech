#!/bin/bash

#-------------------------------------------------
#用途:trunk下  api、ALL release
#  
#参数1 api     ; publish-trunk-release.sh   api
#参数2 all     ; publish-trunk-release.sh   all
#-------------------------------------------------
source /etc/profile

BACKUP_PATH="/root/backup"              #new目录保存最新编译版本的包，rollback目录保存原始备份包
SVN_PATH="/root/svn_trunk"
CFG_PATH="/usr/local/config"

function api()
{
	
	kill -9 `ps aux | grep "/api/" | grep java |grep -v grep | grep -v iapi | awk '{print $2}'`
	
	cd /opt/api/webapps/ROOT/
	tar czf $BACKUP_PATH/rollback/api/api-winter-firefrog.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-firefrog/target/winter-firefrog.war /opt/api/webapps/ROOT/
	unzip winter-firefrog.war
	\cp -p winter-firefrog.war $BACKUP_PATH/new/api/
	rm -fr winter-firefrog.war
	
	/opt/api/bin/startup.sh
	echo "API Release Success。"
}

function iapi()
{
	
	kill -9 `ps aux | grep "/iapi/" | grep java |grep -v grep | awk '{print $2}'`
	
	cd /opt/iapi/webapps/ROOT/
	tar czf $BACKUP_PATH/rollback/iapi/iapi-ROOT.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-firefrog-phone/target/winter-firefrog-phone.war /opt/iapi/webapps/ROOT/
	unzip winter-firefrog-phone.war
	rm -fr winter-firefrog-phone.war
	
	/opt/iapi/bin/startup.sh
	echo "IAPI Release Success。"
}

function all()
{
	api
	iapi
}

case $1 in
	"api")
		api
		;;
	"iapi")
		iapi
		;;
	"all")
		all
		;;
	*)
		echo "not found trunk service release!"
		;;
esac

