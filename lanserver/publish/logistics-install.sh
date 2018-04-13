#!/bin/bash

#----------------------------------------
#trunk: logistics-base logistics-dto        logistics-server logistics-common logistics-app logistics-device logistics-task
#    logistics-manage logistics-api logistics-portal
#
#logistics-install.sh 参数
#参数：base dto server common app device task manage api portal all
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

echo "$SVNPATH"

function base()
{
        cd $SVNPATH        
        cd logistics-base
        svn up  --no-auth-cache --non-interactive

        mvn clean package install -Dmaven.test.skip=true
}


function dto()
{
        cd $SVNPATH                              
        cd logistics-dto
        svn up  --no-auth-cache --non-interactive

        mvn clean package install -Dmaven.test.skip=true
}


function common()
{
        cd $SVNPATH  
        cd logistics-base
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true

        cd ../logistics-dto
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
                            
        cd ../logistics-common
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
}

function system()
{
        cd $SVNPATH
 
        cd logistics-base
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true

        cd ../logistics-dto
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true

        cd ../logistics-common
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true

        cd ../logistics-system
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
}

function transport()
{
        cd $SVNPATH
 
        cd logistics-base
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true

        cd ../logistics-dto
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true

        cd ../logistics-common
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true

        cd ../logistics-transport
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
}

function device()
{
        cd $SVNPATH

        cd logistics-base
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
        
        cd ../logistics-dto
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
        
        cd ../logistics-common
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true

        cd ../logistics-device
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
}

function app()
{
        cd $SVNPATH
        
        cd logistics-base
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true

        cd ../logistics-dto
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true

        cd ../logistics-common
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true

        cd ../logistics-app
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
}

function web()
{
        cd $SVNPATH

        cd logistics-base
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
        
        cd ../logistics-dto
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
        
        cd ../logistics-web
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
}

function portal()
{
        cd $SVNPATH

        cd logistics-base
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
        
        cd ../logistics-dto
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
        
        cd ../logistics-portal
        svn up  --no-auth-cache --non-interactive
        mvn clean package install -Dmaven.test.skip=true
}
function all()
{
        base
        dto
        common
        system
        transport
        app
        device
        web
	portal
}

case $1 in
        "base")
                base;;
        "dto")
                dto;;
        "common")
                common;;
        "system")
                system;;
        "transport")
                transport;;
        "device")
                device;;
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
