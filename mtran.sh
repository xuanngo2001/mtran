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
  
  echo "${SRC_DIR}"
  echo "${DEST_DIR}"
  
  
	case "${ACTION}" in
	  
	  # tar: 0m49.923s, 0m46.756s
	  tar|copy)
	    (cd "${SRC_DIR}"; tar cf - .) | (cd "${DEST_DIR}"; tar xpf -)
	    ;;

    # tar & buffer:
    tarbuffer|copyusb)
    (cd "${SRC_DIR}" && tar cf - .) | pv -trab -B 500M | (cd "${DEST_DIR}" && tar xpSf -)
      ;;
      
    # rsync: 0m57.197s, 0m53.659s
    rsync)
      rsync -a -W "${SRC_DIR}" "${DEST_DIR}"
      ;;
	    
    # cp: 0m48.305s
    cp)
      cp -a "${SRC_DIR}" "${DEST_DIR}"
      ;;
      	    
	  *)
	    echo "ERROR: Unknown action=>${ACTION}"
	    exit 1
	    ;;
	esac
  
}


F_MASS_TRANSFER "$@"