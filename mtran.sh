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
  
  SRC_DIR=$(readlink -e "${SRC_DIR}")
  DEST_DIR=$(readlink -e "${DEST_DIR}")
  
  echo "${SRC_DIR}"
  echo "${DEST_DIR}"
  
  
  
	case "${ACTION}" in
	  
	  # Copy
	  copy)
	    (cd "${SRC_DIR}"; tar cf - .) | (cd "${DEST_DIR}"; tar xpf -)
	    ;;

    # rsync
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