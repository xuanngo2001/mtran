#!/bin/bash
set -e
# Description: Mass copy and verify files integrity.
#   Copy SOURCE_DIR to DESTINATION_DIR

function F_MASS_TRANSFER()
{
  local ACTION=$1
  local SRC_DIR=$2
  local DEST_DIR=$3
  
  # Error handling.
  if [ -z "${ACTION}" ]; then echo "Error: Action can't be empty. Aborted!"; exit 1; fi;
  if [ ! -d "${SRC_DIR}" ]; then echo "Error: Source directory: ${SRC_DIR}: no such directory. Aborted!"; exit 1; fi;
  if [ ! -d "${DEST_DIR}" ]; then echo "Error: Destination directory: ${DEST_DIR}: no such directory. Aborted!"; exit 1; fi;
  
  
  SRC_DIR=$(readlink -ev "${SRC_DIR}")
  DEST_DIR=$(readlink -ev "${DEST_DIR}")
  

  SRC_BASE_DIR=$(dirname "${SRC_DIR}")
  SRC_DIR_NAME=$(basename "${SRC_DIR}")

  # Stop if trying to copy to itself.
  if [ "${SRC_BASE_DIR}" = "${DEST_DIR}" ]; then echo "Error: Trying to copy to itself. Aborted!"; exit 1; fi;

  ACTION=$(echo "${ACTION}" | tr '[:upper:]' '[:lower:]')  # Lowercase to avoid case typo.
  case "${ACTION}" in

    # cp: plain copy.
    cp)
      cp -au "${SRC_DIR}" "${DEST_DIR}"
      ;;
    
    # tar: use tar to copy.
    tar)
      tar -C "${SRC_BASE_DIR}" -cf - "${SRC_DIR_NAME}" | tar -C "${DEST_DIR}" -xpSf -
      ;;

    # tar & buffer: use tar and buffer to copy when 1 of the device is slower than the other 1.
    tarpvbuffer)
      tar -C "${SRC_BASE_DIR}" -cf - "${SRC_DIR_NAME}" | pv -q -B 1024M | tar -C "${DEST_DIR}" -xpSf -
      ;;

    # tar & buffer: use tar and buffer to copy when 1 of the device is slower than the other 1.
    tarbuffer)
      tar -C "${SRC_BASE_DIR}" -cf - "${SRC_DIR_NAME}" | buffer -m 8M | tar -C "${DEST_DIR}" -xpSf -
      ;;

    # rsync: Don't use sparse with rsync: http://stackoverflow.com/a/13266131
    rsync)
      rsync -a -W "${SRC_DIR}" "${DEST_DIR}"
      ;;
    
    diff)
      diff -r "${SRC_DIR}" "${DEST_DIR}/${SRC_DIR_NAME}"
      ;;
            
    *)
      echo "ERROR: Unknown action=>${ACTION}"
      exit 1
      ;;
  esac
  
}


F_MASS_TRANSFER "$@"