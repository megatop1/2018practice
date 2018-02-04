#!/bin/bash

#
# Simply runs md5sum --check against a file with md5sum formatted
# lines.
#

if [[ $# == 0 ]]; then
    printf "Usage $0 [integrity_file]\n";
    exit 1
fi

INTEGRITY_FILE=$1

md5sum --check $INTEGRITY_FILE
