#!/bin/bash
set -e

#./benchmark-mtran.sh /media/master/apps/ /media/sf_shared/test-data/ "Same disk, diff partition"
./benchmark-mtran.sh /media/master/mywiki_deprecated/ /media/sf_shared/test-data/ "Same disk, diff partition"

./benchmark-graph.sh