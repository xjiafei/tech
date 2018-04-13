#!/bin/bash

#----------------------------------------
#用途:trunk下  game、ALL compile
#  
#參數1 game    ; publish-trunk-compiler.sh   game
#參數4 all     ; publish-trunk-compiler.sh   all
#----------------------------------------

SVN_PATH="/root/svn_trunk"

function game()
{
	cd $SVN_PATH
	#svn up  --no-auth-cache --non-interactive

	cd winter-game-common
	mvn clean package install -Dmaven.test.skip=true
	cd ../winter-game
	mvn clean package -Dmaven.test.skip=true

}

function all()
{
        game
}

function delrest()
{

cp -frvp /usr/local/repository/com/winterframework $SVN_PATH/
rm -fr /usr/local/repository/com/winterframework/winter-rest

}

case $1 in
	"game")
		delrest
		game
		;;
        "all")
                all
                ;;
	*)
		echo "not found trunk service compile!"
		;;
esac

