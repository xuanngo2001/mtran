#!/bin/bash
set -e
# Description: Deploy mtran.

BIN_DIR=/usr/local/bin
yes | cp -v mtran.sh "${BIN_DIR}" 
(cd "${BIN_DIR}" && rm -f mtran && ln -s mtran.sh mtran)
