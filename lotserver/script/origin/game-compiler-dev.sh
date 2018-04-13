#!/bin/bash

#----------------------------------------
#用途:branch下 GAME、GAME-WEB、RISK、CHART、TASK、ALL compile
#
#參數 game    ; branch-compiler.sh  game
#參數 web	  ; branch-compiler.sh  web
#參數 risk    ; branch-compiler.sh  risk
#參數 task    ; branch-compiler.sh  task
#參數 chart   ; branch-compiler.sh  chart
#參數 all     ; branch-compiler.sh  all
#----------------------------------------

SVN_PATH="/home/hkdev/svn_dev"

function game_compile()
{
	cd $SVN_PATH
	rm -rf $SVN_PATH/winter-game/src/main/java/com/winterframework/firefrog/game/web/controller/ECController.java
	svn up  --no-auth-cache --non-interactive
	sed -i "s/http:\/\/em.wbwqc/http:\/\/em-dev.wbwqc/g" $SVN_PATH/winter-game/src/main/java/com/winterframework/firefrog/game/web/controller/ECController.java
	cd winter-game-common
	mvn clean package install -Dmaven.test.skip=true
	cd ../winter-game
	mvn clean package -Dmaven.test.skip=true

}

function web_compile()
{
	cd $SVN_PATH
	svn up  --no-auth-cache --non-interactive

	cd winter-game-common
	mvn clean package install -Dmaven.test.skip=true
	cd ../winter-game-web
	mvn clean package -Dmaven.test.skip=true

}

function chart_compile()
{
	cd $SVN_PATH
	svn up  --no-auth-cache --non-interactive

	cd winter-game-common
	mvn clean package install -Dmaven.test.skip=true 
	cd ../winter-game-chart
	mvn clean package -Dmaven.test.skip=true

}

function risk_compile()
{
	cd $SVN_PATH
	svn up  --no-auth-cache --non-interactive

	cd winter-game-common
	mvn clean package install -Dmaven.test.skip=true 
	cd ../winter-game-risk
	mvn clean package -Dmaven.test.skip=true

}

function task_compile()
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
	game_compile
	web_compile
	risk_compile
	chart_compile
	task_compile
}

function delrest()
{

cp -frvp /usr/local/repository/com/winterframework $SVN_PATH/
rm -fr /usr/local/repository/com/winterframework/winter-rest

}

case $1 in
	"game")
		delrest
		game_compile
		;;
	"web")
		delrest
		web_compile
		;;
	"risk")
		delrest
		risk_compile
		;;
	"chart")
		delrest
		chart_compile
		;;
	"task")
		delrest
		task_compile
		;;
	"all")
		delrest
		all
		;;
	*)
		echo "not found branch service compile!"
		;;
esac


