#!/bin/bash
source ~oracle/.bash_profile

LOG_FILE=/tmp/tablespace.out
RMAN=$ORACLE_HOME/bin/rman
CONN=" target / nocatalog"

$RMAN $CONN <<EOF
crosscheck backup;

delete force noprompt expired backup;
delete force noprompt obsolete ;
delete force noprompt backupset completed before 'sysdate-7';

EOF