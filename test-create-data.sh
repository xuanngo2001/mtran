#!/bin/bash
set -e
# Description: Test mtran.sh
#   Copy SOURCE_DIR to DESTINATION_DIR

TEST_SRC_DIR="test-src"
  
function F_TEST_MTRAN()
{
  local ACTION=$1

  ACTION=$(echo "${ACTION}" | tr '[:upper:]' '[:lower:]')  # Lowercase to avoid case typo.
  case "${ACTION}" in

    # Create test data.
    create-test-data)
      F_CREATE_TEST_DATA
      ;;
            
    *)
      echo "${SCRIPT_NAME}: Error: Unknown action=>${ACTION}"
      exit 1
      ;;
  esac

}

function F_CREATE_TEST_DATA()
{
	# Create test-src directory.
	rm -rf "${TEST_SRC_DIR}"
	mkdir -p "${TEST_SRC_DIR}"
	
	# Create files in test-src/
	touch "${TEST_SRC_DIR}/regular-file.txt"
	
	echo "Test data created:"
	find "${TEST_SRC_DIR}" -exec echo "   "{} \;
}

F_TEST_MTRAN "$@"