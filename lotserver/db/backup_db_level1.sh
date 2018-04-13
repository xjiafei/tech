source ~oracle/.bash_profile

LOG_FILE=/home/oracle/backup/Log/BK_${ORACLE_SID}_`date +%Y%m%d%H%M%S`.log
RMAN=$ORACLE_HOME/bin/rman
CONN=" target / nocatalog"

$RMAN $CONN <<EOF >> $LOG_FILE
run {
allocate channel c1 type disk;
backup as compressed backupset incremental level 1  format '/home/oracle/backup/BK_%d_%T_%s_%p_level1.bkp' database;
sql 'alter system archive log current';
BACKUP ARCHIVELOG ALL NOT BACKED UP 1 TIMES FORMAT '/home/oracle/backup/BK_%d_%T_%s_%p.al';
backup CURRENT CONTROLFILE FORMAT '/home/oracle/backup/BK_%d_%T_%s_%p.ctl' ;
BACKUP CURRENT CONTROLFILE FOR STANDBY FORMAT '/home/oracle/backup/BK_STBY_%d_%T_%s_%p.ctl' ;
delete force noprompt backupset completed before 'sysdate-7';
delete noprompt copy of archivelog until time 'sysdate-7';
release channel c1;
}

EOF

find /home/oracle/backup/Log/ -mtime +60 -name 'BK*.log' -print|xargs -l rm -f
find /home/oracle/backup/ -mtime +7 -name 'BK*.bkp' -print|xargs -l rm -f
find /home/oracle/backup/ -mtime +7 -name 'BK*.al'  -print|xargs -l rm -f
find /home/oracle/backup/ -mtime +7 -name 'BK*.ctl' -print|xargs -l rm -f
