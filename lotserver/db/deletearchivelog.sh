#!/bin/bash
source ~oracle/.bash_profile

RMAN=$ORACLE_HOME/bin/rman
CONN=" target / nocatalog"

$RMAN $CONN <<EOF

crosscheck archivelog all;
delete noprompt copy of archivelog until time 'sysdate-7';
delete expired archivelog all;

EOF