#!/bin/bash

#------------------------------------------------
#用途:branch下  api、ui、supui、im、ALL release
#  
#参数 api     ; branch-publish.sh   api
#参数 ui      ; branch-publish.sh   ui
#参数 im      ; branch-publish.sh   im
#参数 support ; branch-publish.sh   supui
#参数 iapi    ; branch-publish.sh   iapi
#参数 all     ; branch-publish.sh   all
#------------------------------------------------
source /etc/profile

BACKUP_PATH="/root/backup"              #new目录保存最新编译版本的包，rollback目录保存原始备份包
SVN_PATH="/home/hkdev/svn_dev"
CFG_PATH="/usr/local/config-dev"

cp -frvp /usr/local/repository/com/winterframework $SVN_PATH/
rm -rf /usr/local/repository/com/winterframework/winter-rest

#调用编译脚本
PWD_PATH="/home/hkdev/script"
source $PWD_PATH/dev-compiler.sh

function api()
{
	
	api_compile
	
	kill -9 `ps aux | grep "dev/api/" | grep java |grep -v grep | grep -v iapi | awk '{print $2}'`
	
	cd /usr/local/dev/api/webapps/ROOT/
	#tar czf $BACKUP_PATH/rollback/api/api-winter-firefrog.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-firefrog/target/winter-firefrog.war /usr/local/dev/api/webapps/ROOT/
	unzip winter-firefrog.war
	#\cp -p winter-firefrog.war $BACKUP_PATH/new/api/
	rm -fr winter-firefrog.war
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/api/webapps/ROOT/WEB-INF/spring-mvc.xml
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/api/webapps/ROOT/WEB-INF/classes/applicationContext-resource.xml
	
	/usr/local/dev/api/bin/startup.sh
	echo "API Release Success。"
}

function ui()
{
	ui_compile
	
	kill -9 `ps aux | grep "dev/ui/" | grep java |grep -v grep | awk '{print $2}'`
	
	cd /usr/local/dev/ui/webapps/ROOT/
	#tar czf $BACKUP_PATH/rollback/ui/ui-winter-firefrog.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	
	cd front/
	rm -fr *
	mv $SVN_PATH/winter-firefrog-web/target/winter-firefrog-web.war /usr/local/dev/ui/webapps/ROOT/front/
	unzip winter-firefrog-web.war
	#\cp -p winter-firefrog-web.war $BACKUP_PATH/new/ui/
	rm -fr winter-firefrog-web.war
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/ui/webapps/ROOT/front/WEB-INF/spring-mvc.xml
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/ui/webapps/ROOT/front/WEB-INF/classes/applicationContext.xml
	
	rm -fr /usr/local/dev/ui/webapps/ROOT/admin/*
	cp -fr /usr/local/dev/ui/webapps/ROOT/front/* /usr/local/dev/ui/webapps/ROOT/admin/
	
	/usr/local/dev/ui/bin/startup.sh
	echo "UI Release Success。"
}


function support()
{
	support_compile
	
	kill -9 `ps aux | grep "dev/supUi/" | grep java |grep -v grep | awk '{print $2}'`

	cd /usr/local/dev/supUi/webapps/ROOT/
	#tar czf $BACKUP_PATH/rollback/supui/supui-ROOT.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	
	mv $SVN_PATH/winter-firefrog-support/target/ROOT.war /usr/local/dev/supUi/webapps/ROOT/
	unzip ROOT.war
	#\cp -p ROOT.war $BACKUP_PATH/new/supui/
	rm -fr ROOT.war
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/supUi/webapps/ROOT/WEB-INF/spring-mvc.xml
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/supUi/webapps/ROOT/WEB-INF/classes/applicationContext-resource.xml

	/usr/local/dev/supUi/bin/startup.sh
	echo "SUPPORT Release Success。"
}

function im()
{
	im_compile
	
	kill -9 `ps aux | grep "dev/im/" | grep java |grep -v grep | awk '{print $2}'`
	
	cd /usr/local/dev/im/webapps/ROOT/
	#tar czf $BACKUP_PATH/rollback/im/im-ROOT.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-firefrog-webim/target/ROOT.war /usr/local/dev/im/webapps/ROOT/
	unzip ROOT.war
	#\cp -p ROOT.war $BACKUP_PATH/new/im/
	rm -fr ROOT.war
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/im/webapps/ROOT/WEB-INF/spring-mvc.xml
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/im/webapps/ROOT/WEB-INF/classes/applicationContext-resource.xml

	/usr/local/dev/im/bin/startup.sh
	echo "IM Release Success。"
}

function iapi()
{
	iapi_compile
	
	kill -9 `ps aux | grep "dev/iapi/" | grep java |grep -v grep | awk '{print $2}'`
	
	cd /usr/local/dev/iapi/webapps/ROOT/
	#tar czf $BACKUP_PATH/rollback/iapi/iapi-ROOT.war_`date "+%Y%m%d%H%M_%S"`.tar.gz ./* --exclude="logs"
	rm -fr *
	mv $SVN_PATH/winter-firefrog-phone/target/winter-firefrog-phone.war /usr/local/dev/iapi/webapps/ROOT/
	unzip winter-firefrog-phone.war
	rm -fr winter-firefrog-phone.war
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/iapi/webapps/ROOT/WEB-INF/spring-mvc.xml
	sed -i "s/\/usr\/local\/config/\/usr\/local\/config-dev/g" /usr/local/dev/iapi/webapps/ROOT/WEB-INF/classes/applicationContext.xml
	
	/usr/local/dev/iapi/bin/startup.sh
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

