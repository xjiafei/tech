#!/bin/bash
source /home/oracle/.bash_profile
KEYFILE=/home/oracle/script/.key1
ORACLE_SID=$1; export ORACLE_SID
DBUSR=$2; export DBUSR
SQLTEXT=$3; export SQLTEXT

DBPWD=`cat $KEYFILE | grep -i $ORACLE_SID | grep -i $DBUSR | awk '{print $3}'`

NOW=`date +%Y%m%d%H%M%S`
Log=/home/oracle/script/Log/${ORACLE_SID}_$SQLTEXT.log.$NOW

date > $Log

cd /home/oracle/script

sqlplus ${DBUSR}/${DBPWD} << EOF >> $Log
set echo on
set time on
set timing on

@$SQLTEXT

exit
EOF

find /home/oracle/script/Log/ -mtime +120 -name '*.log.*' -print|xargs -l rm -f


