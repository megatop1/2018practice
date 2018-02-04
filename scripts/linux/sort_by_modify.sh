#!/bin/bash

#
# This script will recursively list all files in a specified path
# and sort them by newest last modified date to oldest.
#

if [[ $# == 0 ]]; then
    printf "Usage $0 [path]\n";
    exit 1;
fi

FIND_PATH=$1

find $FIND_PATH -type f -printf "%T+\t%p\n" | sort -r
