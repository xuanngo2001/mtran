#!/bin/bash
set -e
# Description: Time different commands of mtran in both direction: from to and to from directories.
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

# FROM -> TO
  ./benchmark-mtran.sh "${SRC_DIR}"  "${DEST_DIR}" "${TEST_CASE_DESC}"

# TO -> FROM
	# Copy source directory to destination directory.
	mtran tar "${SRC_DIR}" "${DEST_DIR}"
	SRC_DIRNAME=$(basename "${SRC_DIR}")
	NEW_SRC_DIR="${DEST_DIR}/${SRC_DIRNAME}_$RANDOM"
	mv "${DEST_DIR}/${SRC_DIRNAME}" "${NEW_SRC_DIR}"
	
	./benchmark-mtran.sh "${NEW_SRC_DIR}"  "${SRC_DIR}" "${TEST_CASE_DESC}(R)"
