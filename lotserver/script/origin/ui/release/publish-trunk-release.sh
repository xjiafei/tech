#!/bin/bash

#------------------------------------------------
#用途:trunk下  ui、supui、im、ALL release
#  
#参数1 ui      ; publish-trunk-release.sh   ui
#参数2 im      ; publish-trunk-release.sh   im
#参数3 support ; publish-trunk-release.sh   supui
#参数4 all     ; publish-trunk-release.sh   all
#------------------------------------------------
source /etc/profile

BACKUP_PATH="/root/backup"              #new目录保存最新编译版本的包，rollback目录保存原始备份包
SVN_PATH="/root/svn_trunk"
CFG_PATH="/usr/local/config"

function ui()
{
	
	kill -9 `ps aux | grep "/ui/" | grep java |grep -v grep | awk '{print $2}'`
	
	cd /opt/ui/webapps/ROOT/
	tar czf $BACKUP_PATH/rollback/ui/ui-winter-firefrog.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	
	cd front/
	rm -fr *
	mv $SVN_PATH/winter-firefrog-web/target/winter-firefrog-web.war /opt/ui/webapps/ROOT/front/
	unzip winter-firefrog-web.war
	\cp -p winter-firefrog-web.war $BACKUP_PATH/new/ui/
	rm -fr winter-firefrog-web.war
	
	rm -fr /opt/ui/webapps/ROOT/admin/*
	cp -fr /opt/ui/webapps/ROOT/front/* /opt/ui/webapps/ROOT/admin/
	
	/opt/ui/bin/startup.sh
	echo "UI Release Success。"
}


function support()
{

	kill -9 `ps aux | grep "/supUi/" | grep java |grep -v grep | awk '{print $2}'`

	cd /opt/supUi/webapps/ROOT/
	tar czf $BACKUP_PATH/rollback/supui/supui-ROOT.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	
	mv $SVN_PATH/winter-firefrog-support/target/ROOT.war /opt/supUi/webapps/ROOT/
	unzip ROOT.war
	\cp -p ROOT.war $BACKUP_PATH/new/supui/
	rm -fr ROOT.war

	/opt/supUi/bin/startup.sh
	echo "SUPPORT Release Success。"
}

function im()
{

	kill -9 `ps aux | grep "/im/" | grep java |grep -v grep | awk '{print $2}'`
	
	cd /opt/im/webapps/ROOT/
	tar czf $BACKUP_PATH/rollback/im/im-ROOT.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-firefrog-webim/target/ROOT.war /opt/im/webapps/ROOT/
	unzip ROOT.war
	\cp -p ROOT.war $BACKUP_PATH/new/im/
	rm -fr ROOT.war

	/opt/im/bin/startup.sh
	echo "IM Release Success。"
}

function all()
{
	ui
	support
	im
}

case $1 in
	"ui")
		ui
		;;
	"supui")
		support
		;;
	"im")
		im
		;;
	"all")
		all
		;;
	*)
		echo "not found trunk service release!"
		;;
esac

