#!/bin/bash
source ~oracle/.bash_profile

LOG_FILE=/tmp/tablespace.out
RMAN=$ORACLE_HOME/bin/rman
CONN=" target / nocatalog"

$RMAN $CONN <<EOF
run {
 allocate channel t1 type disk;
 backup
   incremental level 0
   format '/home/oracle/backup/%d_t%t_s%s_p%p'
   database
   include current controlfile for standby;
 backup current controlfile tag='database backup';
 sql 'alter system archive log current';
 release channel t1;
crosscheck backup;

delete force noprompt backupset completed before 'sysdate-7';
}
exit
EOF