#!/bin/bash

#----------------------------------------
#用途:trunk下  ui、supui、im、ALL compile
#  
#參數1 ui      ; publish-trunk-compiler.sh   ui
#參數2 im      ; publish-trunk-compiler.sh   im
#參數3 support ; publish-trunk-compiler.sh   supui
#參數4 all     ; publish-trunk-compiler.sh   all
#----------------------------------------

SVN_PATH="/root/svn_trunk"

cp -frvp /usr/local/repository/com/winterframework $SVN_PATH/
rm -rf /usr/local/repository/com/winterframework/winter-rest

function ui()
{
	cd $SVN_PATH
	svn up --no-auth-cache --non-interactive
	cd winter-firefrog-web
	mvn clean package -Dmaven.test.skip=true

}


function support()
{
	cd $SVN_PATH/winter-game-common
	mvn clean package install -Dmaven.test.skip=true
	cd $SVN_PATH
	svn up --no-auth-cache --non-interactive
	cd winter-firefrog-support
	mvn clean package -Dmaven.test.skip=true

}

function im()
{
	cd $SVN_PATH/winter-game-common
	mvn clean package install -Dmaven.test.skip=true
	cd $SVN_PATH
	svn up --no-auth-cache --non-interactive
	cd winter-firefrog-webim
	mvn clean package -Dmaven.test.skip=true

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
		echo "not found trunk service compile!"
		;;
esac


