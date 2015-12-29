#!/bin/bash
set -e
# Description: Mass copy and verify files integrity.

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
  
  # Stop if source and destination directory are the same.
  if [ "${SRC_DIR}" = "${DEST_DIR}" ]; then echo "Error: Source and destination directory are the same. Aborted!"; exit 1; fi;
  
  ACTION=$(tr '[:upper:]' '[:lower:]')  # Lowercase to avoid case typo.
  case "${ACTION}" in

    # cp: plain copy.
    cp)
      cp -au "${SRC_DIR}" "${DEST_DIR}"
      ;;
    
    # tar: use tar to copy.
    tar|copy)
      (cd "${SRC_DIR}"; tar cf - .) | (cd "${DEST_DIR}"; tar xpSf -)
      ;;

    # tar & buffer: use tar and buffer to copy when 1 of the device is slower than the other 1.
    tarbuffer|copyusb)
      (cd "${SRC_DIR}" && tar cf - .) | pv -q -B 500M | (cd "${DEST_DIR}" && tar xpSf -)
      ;;
      
    # rsync: Don't use sparse with rsync: http://stackoverflow.com/a/13266131
    rsync)
      rsync -a -W "${SRC_DIR}" "${DEST_DIR}"
      ;;
      
            
    *)
      echo "ERROR: Unknown action=>${ACTION}"
      exit 1
      ;;
  esac
  
}


F_MASS_TRANSFER "$@"