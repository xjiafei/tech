#!/bin/bash

#-----------------------------
#用途： MP移动端发布
#-----------------------------
bak_dir="/data/backup/rollback"


echo ""
echo -ne "请选择要发布ERVICE的序号: 1) MP Interface, 2) MP Admin, 3) all \t: "
read item
echo ""

bak_dir="/data/backup/rollback"

cd /data/svn_baokai/static/
rm -f static.tar.gz
svn up  --no-auth-cache --non-interactive
tar zcvf static.tar.gz ./




function interface_update()
{
	cd /data/svn_baokai/static/interface
	rm -f mp-interface.tar.gz
	svn up  --no-auth-cache --non-interactive
	tar zcvf mp-interface.tar.gz ./	
}
function moblieAdmin_update()
{
	cd /usr/local/nginx/html/moblieAdmin/interface
	tar czf  "$bak_dir"/moblieAdmin_`date "+%Y%m%d%H%M_%S"`.tar.gz ./
	/usr/bin/svn up |tee -a /root/script/release/svn.log	 
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
