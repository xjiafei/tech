#!/bin/bash

#----------------------------------------
#用途:trunk下 RISK、CHART、TASK、ALL compile
#
#參數1 risk    ; publish-trunk-compiler.sh  risk
#參數2 task    ; publish-trunk-compiler.sh  task
#參數3 chart   ; publish-trunk-compiler.sh  chart
#參數4 all     ; publish-trunk-compiler.sh  all
#----------------------------------------

SVN_PATH="/data/svn_baokai"


function api()
{
	cd $SVN_PATH
        cd winter-firefrog
	svn up  --no-auth-cache --non-interactive

	mvn clean package -Dmaven.test.skip=true

}

function iapi()
{
        cd $SVN_PATH

        cd winter-game-common
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
        cd ../winter-firefrog-phone
        svn up  --no-auth-cache --non-interactive
        mvn clean package -Dmaven.test.skip=true

}
function im()
{
        cd $SVN_PATH

        cd winter-game-common
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
        cd ../winter-firefrog-webim
        svn up  --no-auth-cache --non-interactive
        mvn clean package -Dmaven.test.skip=true

}

function supui()
{
        cd $SVN_PATH
        cd winter-game-common
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
        cd ../winter-firefrog-support
        svn up  --no-auth-cache --non-interactive
        mvn clean package -Dmaven.test.skip=true

}

function ui()
{
        cd $SVN_PATH

        cd winter-firefrog-web
        svn up  --no-auth-cache --non-interactive
        mvn clean package -Dmaven.test.skip=true

}

function game()
{
        cd $SVN_PATH

        cd winter-game-common
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
        cd ../winter-game
        svn up  --no-auth-cache --non-interactive
        mvn clean package -Dmaven.test.skip=true

}
function web()
{
        cd $SVN_PATH

        cd winter-game-common
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
        cd ../winter-game-web
        svn up  --no-auth-cache --non-interactive
        mvn clean package -Dmaven.test.skip=true

}

function chart()
{
        cd $SVN_PATH

        cd winter-game-common
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
        cd ../winter-game-chart
        svn up  --no-auth-cache --non-interactive
        mvn clean package -Dmaven.test.skip=true

}

function risk()
{
	cd $SVN_PATH

	cd winter-game-common
        svn up  --no-auth-cache --non-interactive
	mvn clean package install -Dmaven.test.skip=true 
	cd ../winter-game-risk
        svn up  --no-auth-cache --non-interactive
	mvn clean package -Dmaven.test.skip=true

}

function task()
{
	cd $SVN_PATH

	cd winter-game-common
        svn up  --no-auth-cache --non-interactive
	mvn clean package install -Dmaven.test.skip=true 
	cd ../winter-game-task
        svn up  --no-auth-cache --non-interactive
	mvn clean package -Dmaven.test.skip=true 

}


function all()
{
        api
        iapi
        im
        supui
        ui
        game
        web
	risk
	chart
	task
}

function delrest()
{

cp -frvp /usr/local/repository/com/winterframework $SVN_PATH/
rm -fr /usr/local/repository/com/winterframework/winter-rest

}

case $1 in
        "api")
                        api
                        ;;
        "iapi")
                        iapi
                        ;;
        "im")
                        im
                        ;;
        "supui")
                        supui
                        ;;
        "ui")
			ui
			;;
        "game")
                        game
                        ;;
        "web")
                        web
                        ;;
        "risk")
                        risk
                        ;;
        "chart")
			chart
			;;
        "task")
			task
			;;
        "all")
			all
			;;
        *)
			echo "not found trunk service compile!"
			;;
esac




