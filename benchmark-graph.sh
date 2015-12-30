#!/bin/bash
set -e
# Description: Graph execution time different commands of mtran.

EXE_TIME_LOG=$1
EXE_TIME_LOG=excution-time-mtran.log

# Error handling.
if [ ! -f "${EXE_TIME_LOG}" ]; then echo "Error: Execution time log: ${SRC_DIR}: no such file. Aborted!"; exit 1; fi;

EXE_TIME_LOG=$(readlink -ev "${EXE_TIME_LOG}")


# Set working directory.
WORK_DIR="./tmp-working"
mkdir -p "${WORK_DIR}"
WORK_DIR=$(readlink -ev "${WORK_DIR}")


# Separate runtimes of each command in its respective file.
COPY_CMDS=( cp tar tarbuffer tarpvbuffer rsync )
for COPY_CMD in "${COPY_CMDS[@]}"
do
  grep -F "; ${COPY_CMD};" "${EXE_TIME_LOG}" > "${WORK_DIR}/${COPY_CMD}.log"
done