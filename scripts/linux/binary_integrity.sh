#!/bin/bash

#
# Iterates thru all binaries in every directory specified by the
# PATH variable, and creates a md5sum of each binary. The output
# file can be used with the check_integrity.sh script to verify
# that no file has been modified.
#

OUTPUT_FILE="bin_integrity.txt"

IFS=':' read -r -a BIN_PATHS <<< "$PATH"

# Clear output file
printf '' > $OUTPUT_FILE

# Iterate binary paths and create checksum of each binary
for path in ${BIN_PATHS[@]}; do
    for file in $(find $path -type f); do
        echo $(md5sum $file) >> $OUTPUT_FILE;
    done
done
