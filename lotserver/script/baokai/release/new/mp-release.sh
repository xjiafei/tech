#!/bin/bash

#-----------------------------
#用途： MP移动端发布
#-----------------------------
bak_dir="/data/backup/rollback"


echo ""
echo -ne "请选择要发布ERVICE的序号: 1) MP Interface, 2) MP Admin, 3) all \t: "
read item
echo ""

function interface_update()
{
	cd /data/svn/interface
	svn up --no-auth-cache --non-interactive |tee /root/script/release/svn.log
	cd /usr/local/nginx/html/interface
	tar czf  "$bak_dir"/interface/interface_`date "+%Y%m%d%H%M_%S"`.tar.gz ./
	rm -rf * && rm -rf .svn
	cp -pr /data/svn/interface/* /usr/local/nginx/html/interface/
}
function moblieAdmin_update()
{
	cd /data/svn/moblieAdmin/interface
	svn up --no-auth-cache --non-interactive |tee /root/script/release/svn.log
	cd /usr/local/nginx/html/moblieAdmin/interface
	tar czf  "$bak_dir"/moblieAdmin/interface_`date "+%Y%m%d%H%M_%S"`.tar.gz ./
	rm -rf * && rm -rf .svn
	cp -pr /data/svn/moblieAdmin/interface/* /usr/local/nginx/html/moblieAdmin/interface/ 
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
