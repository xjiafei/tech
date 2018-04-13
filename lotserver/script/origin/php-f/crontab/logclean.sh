#!/bin/bash

BACKUP_DIR="/home/log_backup"
find $BACKUP_DIR -name "*.tar.gz" -type f -mtime +30
