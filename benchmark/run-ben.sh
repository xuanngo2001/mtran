#!/bin/bash
set -e

LOGFILE_DIR=./tmp-working

./benchmark-mtran.sh /media/master/apps/ /media/sf_shared/test-data/ "Same disk, diff partition"
./benchmark-mtran.sh /media/master/mywiki_deprecated/ /media/sf_shared/test-data/ "Same disk, diff partition"

./benchmark-graph.sh
./benchmark-dataset-group.sh  "${LOGFILE_DIR}"
./benchmark-graph-gnuplot.pg
./benchmark-results.sh