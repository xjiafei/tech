#!/bin/bash
source ~oracle/.bash_profile

LOG_FILE=/home/oracle/backup/Log/BK${ORACLE_SID}_`date +%Y%m%d%H%M%S`.log
RMAN=$ORACLE_HOME/bin/rman
CONN=" target / nocatalog"

$RMAN $CONN <<EOF >> $LOG_FILE
run {
allocate channel c1 type disk;
backup database format '/home/oracle/backup/BK%d_%s_%p_%T.bkp';
sql 'alter system archive log current';

backup archivelog until time 'sysdate-1' format '/home/oracle/backup/BK%d_%s_%p_%T.al';

backup FORMAT '/home/oracle/backup/BK%d_%s_%p_%T.ctl'
CURRENT CONTROLFILE;
release channel c1;
}

EOF


