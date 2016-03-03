#!/bin/bash
set -e
# Description: Create lot of files.
#   Reference: http://stackoverflow.com/questions/17034941/how-to-create-multiple-files-with-random-data-with-bash
# http://stackoverflow.com/questions/16039844/is-there-a-way-to-split-a-large-file-into-chunks-with-random-sizes

DEST_DIR=$1
TOTAL_SIZE_MB=$2
NUM_OF_FILES=$3

# Error handling.
if [ $# -ne 3 ]; then
  echo "Error: Missing arguments. Aborted!"
  echo " e.g.: $0 <test data directory> <total size in MB> <number of files>"
  echo " e.g.: $0 /path/to/hold/test/data/ 1024 1000"
  exit 1;
fi

if [ ! -d "${DEST_DIR}" ]; then
  echo "Error: Test data directory: ${DEST_DIR}: no such directory. Aborted!"
  exit 1;
fi

IS_NUMBER_RE='^[0-9]+$'
if ! [[ "${TOTAL_SIZE_MB}" =~ ${IS_NUMBER_RE} ]] ; then
   echo "Error: Total size: ${TOTAL_SIZE_MB} is not a number. Aborted!" >&2; exit 1
fi

if ! [[ "${NUM_OF_FILES}" =~ ${IS_NUMBER_RE} ]] ; then
   echo "Error: Number of files: ${NUM_OF_FILES} is not a number. Aborted!" >&2; exit 1
fi

DEST_DIR=$(readlink -ev "${DEST_DIR}")

# Create 1 big file and then split it.
DATE_STRING=$(date +"%Y-%m-%d_%0k.%M.%S")
FILE_PREFIX="$0_${DATE_STRING}_"
FILE_SUFFIX_LENGTH=${#NUM_OF_FILES}
FILE_BYTE_SIZE=$((${TOTAL_SIZE_MB}*1024*1024/${NUM_OF_FILES}))

if [ ${NUM_OF_FILES} -gt 10000 ]; then
  echo "Warning: You are creating a lot files(${NUM_OF_FILES}) in 1 directory. It will take a lot of times."
  read -p "Ctrl-c to cancel. Otherwise, hit Enter."
fi
(cd "${DEST_DIR}" && dd if=/dev/urandom status=none bs=1M count="${TOTAL_SIZE_MB}" | split -d -a "${FILE_SUFFIX_LENGTH}" -b "${FILE_BYTE_SIZE}" - "${FILE_PREFIX}")
