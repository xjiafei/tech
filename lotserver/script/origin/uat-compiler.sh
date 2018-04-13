#!/bin/bash

#----------------------------------------
#用途:branch下  api 、ui、supui、im、ALL compile
# 
#參數 api     ; branch-compiler.sh   api
#參數 ui      ; branch-compiler.sh   ui
#參數 im      ; branch-compiler.sh   im
#參數 support ; branch-compiler.sh   supui
#參數 all     ; branch-compiler.sh   all
#----------------------------------------

SVN_PATH="/root/svn_uat"

cp -frvp /usr/local/repository/com/winterframework $SVN_PATH/
rm -rf /usr/local/repository/com/winterframework/winter-rest

function api_compile()
{
	cd $SVN_PATH
	svn up --no-auth-cache --non-interactive
	cd winter-firefrog
	mvn clean package -Dmaven.test.skip=true

}

function ui_compile()
{
	cd $SVN_PATH
	svn up --no-auth-cache --non-interactive
	cd winter-firefrog-web
	mvn clean package -Dmaven.test.skip=true

}


function support_compile()
{
	cd $SVN_PATH/winter-game-common
	mvn clean package install -Dmaven.test.skip=true
	cd $SVN_PATH
	svn up --no-auth-cache --non-interactive
	cd winter-firefrog-support
	mvn clean package -Dmaven.test.skip=true

}

function im_compile()
{
	cd $SVN_PATH/winter-game-common
	mvn clean package install -Dmaven.test.skip=true
	cd $SVN_PATH
	svn up --no-auth-cache --non-interactive
	cd winter-firefrog-webim
	mvn clean package -Dmaven.test.skip=true

}

function iapi_compile()
{
	cd $SVN_PATH/winter-game-common
	mvn clean package install -Dmaven.test.skip=true
	cd $SVN_PATH
	svn up --no-auth-cache --non-interactive
	cd winter-firefrog-phone
	mvn clean package -Dmaven.test.skip=true
}

function all()
{
	api_compile
	ui_compile
	support_compile
	im_compile
	iapi_compile
}

case $1 in
	"api")
		api_compile
		;;
	"ui")
		ui_compile
		;;
	"supui")
		support_compile
		;;
	"im")
		im_compile
		;;
	"iapi")
		iapi_compile
		;;
	"all")
		all
		;;
	*)
		echo "not found branch service compile!"
		;;
esac


