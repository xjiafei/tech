#!/bin/bash

#----------------------------------------
#用途:trunk下 WEB、ALL compile
#  
#參數1 web     ; publish-trunk-compiler.sh  web
#參數2 all     ; publish-trunk-compiler.sh  all
#----------------------------------------

SVN_PATH="/root/svn_trunk"

function web()
{
	cd $SVN_PATH
	svn up  --no-auth-cache --non-interactive

	cd winter-game-common
	mvn clean package install -Dmaven.test.skip=true
	cd ../winter-game-web
	mvn clean package -Dmaven.test.skip=true

}

function all()
{
	web
}

function delrest()
{
	cp -frvp /usr/local/repository/com/winterframework $SVN_PATH/
	rm -fr /usr/local/repository/com/winterframework/winter-rest
}

case $1 in
	"web")
		delrest
		web
		;;
	"all")
		delrest
		all
		;;
	*)
		echo "not found trunk service compile!";;
esac

