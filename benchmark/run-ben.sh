#!/bin/bash
set -e

LOGFILE_DIR=./tmp-working

# 257M
#./benchmark-mtran-2ways.sh /media/master/apps/               /media/sf_shared/test-data/ "Same HD: VM HD to shared/"

# 500M
./benchmark-mtran-2ways.sh /media/master/mywiki_deprecated/  /media/sf_shared/test-data/ "Same HD: VM HD to shared/"

# 803M
./benchmark-mtran-2ways.sh /media/master/github/opwr         /media/imdb/                "Same HD: VM part. to VM part."


./benchmark-graph.sh
./benchmark-dataset-group.sh  "${LOGFILE_DIR}"
./benchmark-graph-gnuplot.pg
./benchmark-results.sh