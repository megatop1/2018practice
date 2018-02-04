#!/bin/bash

#
# Web applications should be owned by the apache or webdev user,
# and should have specific file/folder permissions to mitigate the
# effectiveness of some attacks. This script will automate the
# mitigation.
#

if [[ $# == 0 ]]; then
    printf "Usage $0 [webroot] [user] [group]\n";
    exit 1;
fi

WEBROOT=$1
USER=$2
GROUP=$3

function update_file_perms
{
    for file in $(find $WEBROOT -type f); do
        chmod 640 $file;
    done
}

function update_dir_perms
{
    for dir in $(find $WEBROOT -type d); do
        chmod 750 $dir;
    done
}

# Update user and group
chown -R $USER.$GROUP $WEBROOT

update_dir_perms
update_file_perms
