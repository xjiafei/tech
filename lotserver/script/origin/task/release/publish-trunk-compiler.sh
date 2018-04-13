#!/bin/bash

#----------------------------------------
#用途:trunk下 RISK、CHART、TASK、ALL compile
#
#參數1 risk    ; publish-trunk-compiler.sh  risk
#參數2 task    ; publish-trunk-compiler.sh  task
#參數3 chart   ; publish-trunk-compiler.sh  chart
#參數4 all     ; publish-trunk-compiler.sh  all
#----------------------------------------

SVN_PATH="/root/svn_trunk"


function chart()
{
	cd $SVN_PATH
	svn up  --no-auth-cache --non-interactive

	cd winter-game-common
	mvn clean package install -Dmaven.test.skip=true 
	cd ../winter-game-chart
	mvn clean package -Dmaven.test.skip=true

}

function risk()
{
	cd $SVN_PATH
	svn up  --no-auth-cache --non-interactive

	cd winter-game-common
	mvn clean package install -Dmaven.test.skip=true 
	cd ../winter-game-risk
	mvn clean package -Dmaven.test.skip=true

}

function task()
{
	cd $SVN_PATH
	svn up  --no-auth-cache --non-interactive

	cd winter-game-common
	mvn clean package install -Dmaven.test.skip=true 
	cd ../winter-game-task
	mvn clean package -Dmaven.test.skip=true 

}


function all()
{
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
        "risk")
			delrest
			risk
			;;
        "chart")
			delrest
			chart
			;;
        "task")
			delrest
			task
			;;
        "all")
			delrest
			all
			;;
        *)
			echo "not found trunk service compile!"
			;;
esac




