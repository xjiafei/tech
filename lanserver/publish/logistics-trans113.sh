#!/bin/bash

#----------------------------------------
#efamily-trans113.sh 参数
#参数：server app device task manage api
#
#----------------------------------------

 SVNPATH="/usr/local/efamily/svn"

echo $SVNPATH

if [ $1 = "server" ];then
 WAR_PATH="efamily-server/target/efamily-server.war"
elif [ $1 = "app" ];then
 WAR_PATH="efamily-app/target/efamily-app.war"
elif [ $1 = "device" ];then
 WAR_PATH="efamily-device/target/efamily-device.war" 
elif [ $1 = "task" ];then
 WAR_PATH="efamily-task/target/efamily-task.war" 
elif [ $1 = "manage" ];then
 WAR_PATH="efamily-manage/target/efamily-manage.war" 
elif [ $1 = "ccontrol" ];then
 WAR_PATH="efamily-ccontrol/target/efamily-ccontrol.war"
elif [ $1 = "dispatch" ];then
 WAR_PATH="efamily-dispatch/target/efamily-dispatch.war"
elif [ $1 = "notification" ];then
 WAR_PATH="efamily-notification/target/efamily-notification.war"
elif [ $1 = "api" ];then
 WAR_PATH="efamily-api/target/efamily-api.war"  
elif [ $1 = "institution" ];then
 WAR_PATH="efamily-institution/target/efamily-institution.war"
elif [ $1 = "http" ];then
 WAR_PATH="efamily-http/target/efamily-http.war"
else
 echo "parameter invalid."
 exit 0
fi

SERVER_IP=112.74.213.113
TARGET_PATH=/usr/local/efamily/war

echo "$SVNPATH"/"$WAR_PATH"

scp -r "$SVNPATH"/"$WAR_PATH" root@"$SERVER_IP":"$TARGET_PATH"
