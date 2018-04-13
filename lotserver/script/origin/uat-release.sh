#!/bin/bash

#------------------------------------------------
#用途:branch下  api、ui、supui、im、ALL release
#  
#参数 api     ; branch-publish.sh   api
#参数 ui      ; branch-publish.sh   ui
#参数 im      ; branch-publish.sh   im
#参数 support ; branch-publish.sh   supui
#参数 all     ; branch-publish.sh   all
#------------------------------------------------
source /etc/profile

BACKUP_PATH="/root/backup"              #new目录保存最新编译版本的包，rollback目录保存原始备份包
SVN_PATH="/root/svn_uat"
CFG_PATH="/usr/local/config"

cp -frvp /usr/local/repository/com/winterframework $SVN_PATH/
rm -rf /usr/local/repository/com/winterframework/winter-rest

#调用编译脚本
source /root/script/release/uat-compiler.sh

function api()
{
	
	api_compile
	
	kill -9 `ps aux | grep "opt/api/" | grep java |grep -v grep | grep -v iapi | awk '{print $2}'`
	
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

function ui()
{
	ui_compile
	
	kill -9 `ps aux | grep "opt/ui/" | grep java |grep -v grep | awk '{print $2}'`
	
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
	support_compile
	
	kill -9 `ps aux | grep "opt/supUi/" | grep java |grep -v grep | awk '{print $2}'`

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
	im_compile
	
	kill -9 `ps aux | grep "opt/im/" | grep java |grep -v grep | awk '{print $2}'`
	
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

function iapi()
{
	iapi_compile
	
	kill -9 `ps aux | grep "opt/iapi/" | grep java |grep -v grep | awk '{print $2}'`
	
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
	ui
	support
	im
	iapi
}

case $1 in
	"api")
		api
		;;
	"ui")
		ui
		;;
	"supui")
		support
		;;
	"im")
		im
		;;
	"iapi")
		iapi
		;;
	"all")
		all
		;;
	*)
		echo "not found branch service release!"
		;;
esac

chown -R hkdev /usr/local/repository/com/winterframework