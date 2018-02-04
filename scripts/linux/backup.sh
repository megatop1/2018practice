#!/bin/bash

#
# Creates tarball backups of important directories.
#

BACKUP_DIRS=("/etc")
IFS=':' read -r -a BIN_PATHS <<< "$PATH"
BACKUP_DIRS+=(${BIN_PATHS[@]})

if [[ -d /var/www ]]; then
    BACKUP_DIRS+=("/var/www");
fi

# Create backup directory
BACKUP_LOC="backup_$(date +"%Y-%m-%d_%H-%M-%S")"
mkdir $BACKUP_LOC && cd $BACKUP_LOC

for dir in ${BACKUP_DIRS[@]}; do
    echo "Backing up $dir...";
    tar -czf $(uuidgen).tar.gz $dir 2>/dev/null;
done
