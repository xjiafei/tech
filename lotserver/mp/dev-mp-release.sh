#!/bin/bash

#-----------------------------
#用途： MP移动端发布
#-----------------------------

echo ""
echo -ne "请选择要发布ERVICE的序号: 1) MP Interface, 2) MP Admin, 3) all \t: "
read item
echo ""

function interface_update()
{
	cd /usr/local/nginx/html/interface-dev
	/usr/bin/svn up |tee /home/hkdev/script/svn.log	
}
function moblieAdmin_update()
{
	cd /usr/local/nginx/html/moblieAdmin-dev/interface
	/usr/bin/svn up |tee -a /home/hkdev/script/svn.log	 
}

case $item in
	1)
		interface_update
		;;
	2)
		moblieAdmin_update
		;;
	3)
		interface_update
		moblieAdmin_update
		;;
	*)
		echo " invalid input, please check !!"
		echo ""
		;;
esac

chown -R hkdev /usr/local/nginx/html/interface-dev
chown -R hkdev /usr/local/nginx/html/moblieAdmin-dev