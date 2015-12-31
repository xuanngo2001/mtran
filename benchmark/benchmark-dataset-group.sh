#!/bin/bash
set -e
# Description: Group data per test case description & dataset

LOGFILE_DIR=$1

if [ ! -d "${LOGFILE_DIR}" ]; then echo "Error: Log file directory: ${LOGFILE_DIR}: no such directory. Aborted!"; exit 1; fi

LOGFILE_DIR=$(readlink -ev "${LOGFILE_DIR}")

while IFS='' read -r LOGFILE || [[ -n "$LOGFILE" ]]; do    
  sort -t ';' -k2,2 -k3,3 "${LOGFILE}" -o "${LOGFILE}"
done < <( find "${LOGFILE_DIR}" -type f -name "*.log" )
 

