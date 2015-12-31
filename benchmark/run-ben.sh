#!/bin/bash
set -e
./benchmark-mtran.sh /media/master/apps/ /media/sf_shared/test-data/ "Same disk, diff partition"
./benchmark-graph.sh