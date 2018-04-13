#/bin/bash

#----------------------------------------
#trunk: logistics-base logistics-dto        logistics-server logistics-common logistics-app logistics-device logistics-task
#    logistics-manage logistics-api logistics-portal
#
#logistics-publish.sh 参数
#参数：server app device task manage api portal all
#
#----------------------------------------

if [[ $2 = "trunk" ]];then
 SVNPATH="/usr/local/logistics/svn"
elif [[ $2 = "other" ]];then
 SVNPATH="/usr/local/logistics/svn_branch_other"
elif [[ $2 = "bugfix" ]];then
 SVNPATH="/usr/local/logistics/svn_bugfix"
elif [[ $2 = "dt" ]];then
 SVNPATH="/usr/local/logistics/svn_branch_distribution"
else
 SVNPATH="/usr/local/logistics/svn"
fi


function system()
{
        kill -9  `ps -ef | grep java | grep logistics-system | awk -F" " '{print $2}'`

        localPath=/usr/local/logistics
        serverPath=/opt/logistics/logistics-system
        cd "$serverPath"/webapps/ROOT
        mv "$serverPath"/logs/catalina.out "$serverPath"/logs/catalina.out_`date +"%Y%m%d%H:%M%S"`
        rm -fr META-INF WEB-INF
        cp -rf $SVNPATH/logistics-system/target/logistics-system.war "$localPath"/war/backup/logistics-system_`date +"%Y%m%d%H:%M%S"`.war
        cp $SVNPATH/logistics-system/target/logistics-system.war "$serverPath"/webapps/ROOT
        unzip -o logistics-system.war
        rm -fr logistics-system.war
        cp -fr "$localPath"/conf/db.properties "$localPath"/conf/redis.properties WEB-INF/classes/
        cp -fr "$localPath"/conf/application/application-system.properties  WEB-INF/classes/application.properties
	cp -fr "$localPath"/conf/log4j.properties  WEB-INF/classes/log4j.properties
        cd ../../bin
        ./startup.sh
}

function device()
{
        kill -9  `ps -ef | grep java | grep logistics-device | awk -F" " '{print $2}'`
        localPath=/usr/local/logistics
        serverPath=/opt/logistics/logistics-device
        cd "$serverPath"/webapps/ROOT
        mv "$serverPath"/logs/catalina.out "$serverPath"/logs/catalina.out_`date +"%Y%m%d%H:%M%S"`
        rm -fr META-INF WEB-INF
        cp -rf $SVNPATH/logistics-device/target/logistics-device.war "$localPath"/war/backup/logistics-device_`date +"%Y%m%d%H:%M%S"`.war
        cp $SVNPATH/logistics-device/target/logistics-device.war "$serverPath"/webapps/ROOT
        unzip -o logistics-device.war
        rm -fr logistics-device.war
        cp -fr "$localPath"/conf/db.properties "$localPath"/conf/redis.properties WEB-INF/classes/
        cp -fr "$localPath"/conf/application/application-device.properties  WEB-INF/classes/application.properties
	cp -fr "$localPath"/conf/log4j.properties  WEB-INF/classes/log4j.properties
        cd ../../bin
        ./startup.sh

}

function transport()
{
        kill -9  `ps -ef | grep java | grep logistics-transport | awk -F" " '{print $2}'`

        localPath=/usr/local/logistics
        serverPath=/opt/logistics/logistics-transport
        cd "$serverPath"/webapps/ROOT
        mv "$serverPath"/logs/catalina.out "$serverPath"/logs/catalina.out_`date +"%Y%m%d%H:%M%S"`
        rm -fr META-INF WEB-INF
        cp -rf $SVNPATH/logistics-transport/target/logistics-transport.war "$localPath"/war/backup/logistics-transport_`date +"%Y%m%d%H:%M%S"`.war
        cp $SVNPATH/logistics-transport/target/logistics-transport.war "$serverPath"/webapps/ROOT
        unzip -o logistics-transport.war
        rm -fr logistics-transport.war
        cp -fr "$localPath"/conf/db.properties "$localPath"/conf/redis.properties WEB-INF/classes/
        cp -fr "$localPath"/conf/application/application-transport.properties  WEB-INF/classes/application.properties
	cp -fr "$localPath"/conf/log4j.properties  WEB-INF/classes/log4j.properties
        cd ../../bin
        ./startup.sh

}

function app()
{
        kill -9  `ps -ef | grep java | grep logistics-app | awk -F" " '{print $2}'`

        localPath=/usr/local/logistics
        serverPath=/opt/logistics/logistics-app
        cd "$serverPath"/webapps/ROOT
        mv "$serverPath"/logs/catalina.out "$serverPath"/logs/catalina.out_`date +"%Y%m%d%H:%M%S"`
        rm -fr META-INF WEB-INF
        cp -rf $SVNPATH/logistics-app/target/logistics-app.war "$localPath"/war/backup/logistics-app_`date +"%Y%m%d%H:%M%S"`.war
        cp $SVNPATH/logistics-app/target/logistics-app.war "$serverPath"/webapps/ROOT
        unzip -o logistics-app.war
        rm -fr logistics-app.war
        cp -fr "$localPath"/conf/db.properties "$localPath"/conf/redis.properties  WEB-INF/classes/
        cp -fr "$localPath"/conf/application/application-app.properties  WEB-INF/classes/application.properties
	cp -fr "$localPath"/conf/log4j-info.properties  WEB-INF/classes/log4j.properties
        cd ../../bin
        ./startup.sh

}
function web()
{
        kill -9  `ps -ef | grep java | grep logistics-web | awk -F" " '{print $2}'`

        localPath=/usr/local/logistics
        serverPath=/opt/logistics/logistics-web
        cd "$serverPath"/webapps/ROOT
        mv "$serverPath"/logs/catalina.out "$serverPath"/logs/catalina.out_`date +"%Y%m%d%H:%M%S"`
        rm -fr META-INF WEB-INF
        cp -rf $SVNPATH/logistics-web/target/logistics-web.war "$localPath"/war/backup/logistics-web_`date +"%Y%m%d%H:%M%S"`.war
        cp $SVNPATH/logistics-web/target/logistics-web.war "$serverPath"/webapps/ROOT
        unzip -o logistics-web.war
        rm -fr logistics-web.war
        cp -fr "$localPath"/conf/db.properties "$localPath"/conf/redis.properties WEB-INF/classes/
        cp -fr "$localPath"/conf/application/application-web.properties  WEB-INF/classes/application.properties
	cp -fr "$localPath"/conf/log4j-info.properties  WEB-INF/classes/log4j.properties
        cd ../../bin
        ./startup.sh

}
function portal()
{
        kill -9  `ps -ef | grep java | grep logistics-portal | awk -F" " '{print $2}'`

        localPath=/usr/local/logistics
        serverPath=/opt/logistics/logistics-portal
        cd "$serverPath"/webapps/ROOT
        mv "$serverPath"/logs/catalina.out "$serverPath"/logs/catalina.out_`date +"%Y%m%d%H:%M%S"`
        rm -fr META-INF WEB-INF
        cp -rf $SVNPATH/logistics-portal/target/logistics-portal.war "$localPath"/war/backup/logistics-portal_`date +"%Y%m%d%H:%M%S"`.war
        cp $SVNPATH/logistics-portal/target/logistics-portal.war "$serverPath"/webapps/ROOT
        unzip -o logistics-portal.war
        rm -fr logistics-portal.war
        cp -fr "$localPath"/conf/db.properties "$localPath"/conf/redis.properties WEB-INF/classes/
        cp -fr "$localPath"/conf/application/application-portal.properties  WEB-INF/classes/application.properties
	cp -fr "$localPath"/conf/log4j.properties  WEB-INF/classes/log4j.properties
        cd ../../bin
        ./startup.sh

}
function all()
{
        system
        transport
        app
        device
        task
        web
	portal
}


case $1 in
        "system")
                system;;
        "transport")
                transport;;
        "device")
                device;;
        "task")
                task;;
        "app")
                app;;
        "web")
                web;;
	"portal")
                portal;;
        "all")
                all;;
        *)
                echo "not exists the project!";;
esac
