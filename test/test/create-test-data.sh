#!/bin/bash
set -e
# Description: Create test data.
#   Reference: http://stackoverflow.com/questions/17034941/how-to-create-multiple-files-with-random-data-with-bash
# http://stackoverflow.com/questions/16039844/is-there-a-way-to-split-a-large-file-into-chunks-with-random-sizes

DEST_DIR=$1

if [ -z "${DEST_DIR}" ]; then
  echo "Error: Please supply test data directory. Aborted!"
  exit 1;
fi

if [ ! -d "${DEST_DIR}" ]; then
  echo "Error: ${DEST_DIR}: no such directory. Aborted!"
  exit 1;
fi

DEST_DIR=$(readlink -ev "${DEST_DIR}")

cd "${DEST_DIR}"
dd if=/dev/urandom bs=4M count=2 | split -b 1024 -d -a 5

cd -



#FILE_NAME=1mfile
#dd if=/dev/urandom of="${FILE_NAME}" bs=4M count=2 >& /dev/null


#Create a 1GB.bin random content file: dd if=/dev/urandom of=1GB.bin bs=64M count=16 iflag=fullblock
# http://rajaseelan.com/2009/07/29/generate-files-with-random-content-and-size-in-bash/