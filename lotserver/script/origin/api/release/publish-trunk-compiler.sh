#!/bin/bash

#----------------------------------------
#用途:trunk下  api、ALL compile
#  
#參數1 api     ; publish-trunk-compiler.sh   api
#參數2 all     ; publish-trunk-compiler.sh   all
#----------------------------------------

SVN_PATH="/root/svn_trunk"

cp -frvp /usr/local/repository/com/winterframework $SVN_PATH/
rm -rf /usr/local/repository/com/winterframework/winter-rest

function api()
{
	cd $SVN_PATH
	svn up --no-auth-cache --non-interactive
	cd winter-firefrog
	mvn clean package -Dmaven.test.skip=true

}

function iapi()
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
		echo "not found trunk service compile!"
		;;
esac

