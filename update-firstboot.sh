#!/bin/bash
set -e
# Description: Update mtran.sh to firstboot project

mtran_bin_dir=$(readlink -ev "/media/master/github/firstboot/apps/mtran/run/")
yes | cp -v mtran.sh "${mtran_bin_dir}" 
