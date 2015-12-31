#!/bin/bash
set -e

LOGFILE_DIR=./tmp-working

# 257M
#./benchmark-mtran.sh /media/master/apps/ /media/sf_shared/test-data/ "Same disk: VM HD to shared dir"

# 500M
#./benchmark-mtran.sh /media/master/mywiki_deprecated/ /media/sf_shared/test-data/ "Same disk: VM HD to shared dir"

# 803M
#./benchmark-mtran.sh /media/master/github/opwr /media/imdb/ "Same disk: VM part. to VM part."

# 
#./benchmark-mtran.sh /media/master/github/opwr /media/master/github/fedca_proqc/ "Same disk: VM part. to VM part."

./benchmark-mtran.sh /media/master/github/opwr /media/imdb/ "Same disk: VM part. to VM part."
./benchmark-mtran.sh /media/master/apps/ /media/sf_shared/test-data/ "Same disk: VM HD to shared dir"
./benchmark-mtran.sh /media/master/mywiki_deprecated/ /media/sf_shared/test-data/ "Same disk: VM HD to shared dir"
./benchmark-mtran.sh /media/master/github/opwr /media/master/github/fedca_proqc/ "Same disk: VM part. to VM part."

./benchmark-mtran.sh /media/master/github/opwr /media/master/github/fedca_proqc/ "Same disk: VM part. to VM part."
./benchmark-mtran.sh /media/master/apps/ /media/sf_shared/test-data/ "Same disk: VM HD to shared dir"
./benchmark-mtran.sh /media/master/github/opwr /media/imdb/ "Same disk: VM part. to VM part."
./benchmark-mtran.sh /media/master/mywiki_deprecated/ /media/sf_shared/test-data/ "Same disk: VM HD to shared dir"

./benchmark-mtran.sh /media/master/apps/ /media/sf_shared/test-data/ "Same disk: VM HD to shared dir"
./benchmark-mtran.sh /media/master/mywiki_deprecated/ /media/sf_shared/test-data/ "Same disk: VM HD to shared dir"
./benchmark-mtran.sh /media/master/github/opwr /media/master/github/fedca_proqc/ "Same disk: VM part. to VM part."
./benchmark-mtran.sh /media/master/github/opwr /media/imdb/ "Same disk: VM part. to VM part."

./benchmark-mtran.sh /media/master/mywiki_deprecated/ /media/sf_shared/test-data/ "Same disk: VM HD to shared dir"
./benchmark-mtran.sh /media/master/github/opwr /media/imdb/ "Same disk: VM part. to VM part."
./benchmark-mtran.sh /media/master/apps/ /media/sf_shared/test-data/ "Same disk: VM HD to shared dir"
./benchmark-mtran.sh /media/master/github/opwr /media/master/github/fedca_proqc/ "Same disk: VM part. to VM part."

./benchmark-mtran.sh /media/master/apps/ /media/sf_shared/test-data/ "Same disk: VM HD to shared dir"
./benchmark-mtran.sh /media/master/github/opwr /media/imdb/ "Same disk: VM part. to VM part."
./benchmark-mtran.sh /media/master/mywiki_deprecated/ /media/sf_shared/test-data/ "Same disk: VM HD to shared dir"
./benchmark-mtran.sh /media/master/github/opwr /media/master/github/fedca_proqc/ "Same disk: VM part. to VM part."

./benchmark-graph.sh
./benchmark-dataset-group.sh  "${LOGFILE_DIR}"
./benchmark-graph-gnuplot.pg
./benchmark-results.sh