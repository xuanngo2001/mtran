#!/bin/bash
set -e
# Description: Time different commands of mtran.
#   -Should I reboot for every run?
# Real, User and Sys process time statistics: http://stackoverflow.com/a/556411

SRC_DIR=$1
DEST_DIR=$2
TEST_CASE_DESC=$3

# Error handling.
if [ ! -d "${SRC_DIR}" ]; then echo "Error: Source directory: ${SRC_DIR}: no such directory. Aborted!"; exit 1; fi;
if [ ! -d "${DEST_DIR}" ]; then echo "Error: Destination directory: ${DEST_DIR}: no such directory. Aborted!"; exit 1; fi;
if [ -z "${TEST_CASE_DESC}" ]; then echo "Error: Please provide test case description. e.g.: Internal hard drive to external usb hard drive. Aborted!"; exit 1; fi;

SRC_DIR=$(readlink -ev "${SRC_DIR}")
DEST_DIR=$(readlink -ev "${DEST_DIR}")

# Stop if source and destination directory are the same.
if [ "${SRC_DIR}" = "${DEST_DIR}" ]; then echo "Error: Source and destination directory are the same. Aborted!"; exit 1; fi;

# Get test data directory statistic. Other stats: http://stackoverflow.com/a/12522322
SRC_SIZE=$(du -chs "${SRC_DIR}" | tail -n 1 | cut -f 1)
SRC_FILES=$(find "${SRC_DIR}" -type f | wc -l)
SRC_DIRS=$(find "${SRC_DIR}" -type d | wc -l)
SRC_STATS="${SRC_SIZE}, ${SRC_FILES} files, ${SRC_DIRS} dirs"
echo "Test data: ${SRC_STATS}"

DATE_STRING=$(date +"%Y-%m-%d_%0k.%M.%S")
COPY_CMDS=( cp tar tarbuffer tarpvbuffer rsync )
RESULTS_LOG=benchmark-results.log
for COPY_CMD in "${COPY_CMDS[@]}"
do

  # Create temporary test directory.
  TEST_DIR="${DEST_DIR}/${DATE_STRING}-${COPY_CMD}-${RANDOM}"
  mkdir -p "${TEST_DIR}"
  
  # Time the execution.
  echo "Run mtran ${COPY_CMD} ${SRC_DIR} ${TEST_DIR} ..."
  RUNTIME="$(date +%s)"               # Start timer.
  mtran ${COPY_CMD} "${SRC_DIR}" "${TEST_DIR}"
  RUNTIME="$(($(date +%s)-RUNTIME))"  # End timer.
  
  # Log execution time. Separator=;
  echo "${DATE_STRING}; ${TEST_CASE_DESC}; ${SRC_STATS}; ${COPY_CMD}; ${RUNTIME}" >> "${RESULTS_LOG}"
  
  # Cleanup
  rm -rf "${TEST_DIR}"
done