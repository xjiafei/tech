#!/bin/bash
source ~/.bash_profile
KEYFILE=/home/oracle/script/.key1
ORACLE_SID=$1; export ORACLE_SID
DBUSR=$2; export DBUSR
DBPWD=`cat $KEYFILE | grep -i $ORACLE_SID | grep -i $DBUSR | awk '{print $3}'`

NOW=`date +%Y%m%d%H%M%S`
Log=/home/oracle/script/Log/${ORACLE_SID}_baobiao.log.$NOW

cd /home/oracle/script/

sqlplus $DBUSR/$DBPWD <<eof >> $Log
set timing on feedback on
set time on
set echo on

@baobiao.sql
exit

eof

find /home/oracle/script/Log/ -mtime +60 -name '${ORACLE_SID}_baobiao.log.*' -print|xargs -l rm -f

