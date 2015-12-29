#!/bin/bash
set -e
# Description: Time different command of mtran.
#   -Should I reboot for every run?

SRC_DIR=$1
DEST_DIR=$2

# Error handling.
if [ ! -d "${SRC_DIR}" ]; then echo "Error: Source directory: ${SRC_DIR}: no such directory. Aborted!"; exit 1; fi;
if [ ! -d "${DEST_DIR}" ]; then echo "Error: Destination directory: ${DEST_DIR}: no such directory. Aborted!"; exit 1; fi;


SRC_DIR=$(readlink -ev "${SRC_DIR}")
DEST_DIR=$(readlink -ev "${DEST_DIR}")

# Stop if source and destination directory are the same.
if [ "${SRC_DIR}" = "${DEST_DIR}" ]; then echo "Error: Source and destination directory are the same. Aborted!"; exit 1; fi;

# Get source directory(test data directory) statistic.
SRC_SIZE=$(du -chs "${SRC_DIR}" | tail -n 1 | cut -f 1)
SRC_FILES=$(find "${SRC_DIR}" -type f | wc -l)
SRC_DIRS=$(find "${SRC_DIR}" -type d | wc -l)
SRC_STATS="Size=${SRC_SIZE}, files=${SRC_FILES}, directories=${SRC_DIRS}"
echo "Test data: ${SRC_STATS}"

DATE_STRING=$(date +"%Y-%m-%d_%0k.%M.%S")
COPY_CMDS=( cp tar tarbuffer rsync )
MASTER_LOG=excution-time-mtran.log
for COPY_CMD in "${COPY_CMDS[@]}"
do

  # Create temporary test directory.
  TEST_DIR="${DEST_DIR}/${DATE_STRING}-${COPY_CMD}-${RANDOM}"
  mkdir -p "${TEST_DIR}"
  
  # Create temporary log file.
  TMP_LOG=tmp-mtran.log
  
  # Time the execution.
  echo "time ./mtran ${COPY_CMD} ${SRC_DIR} ${TEST_DIR} ..."
  { time ./mtran ${COPY_CMD} "${SRC_DIR}" "${TEST_DIR}"; } 2>> "${TMP_LOG}"
  
  # Log execution time. Separator=;
  echo -n "${DATE_STRING}; ${SRC_STATS}; ${COPY_CMD}; " >> "${MASTER_LOG}"
  cat "${TMP_LOG}" | tr '\r\n' ' ' >> "${MASTER_LOG}"
  echo "" >> "${MASTER_LOG}"
  
  # Cleanup
  rm -rf "${TMP_LOG}"
  rm -rf "${TEST_DIR}"
done