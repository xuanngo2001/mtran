#!/bin/bash
set -e
# Description: Graph execution time different commands of mtran.

EXE_TIME_LOG=$1
EXE_TIME_LOG=excution-time-mtran.log

# Error handling.
if [ ! -f "${EXE_TIME_LOG}" ]; then echo "Error: Execution time log: ${SRC_DIR}: no such file. Aborted!"; exit 1; fi;

EXE_TIME_LOG=$(readlink -ev "${EXE_TIME_LOG}")


# Set working directory.
WORK_DIR="./tmp-working"
mkdir -p "${WORK_DIR}"
WORK_DIR=$(readlink -ev "${WORK_DIR}")



PLOT_CMD="plot"
COPY_CMDS=( cp tar tarbuffer tarpvbuffer rsync )
for COPY_CMD in "${COPY_CMDS[@]}"
do
  COPY_CMD_LOG="${WORK_DIR}/${COPY_CMD}.log"
  # Separate runtimes of each command in its respective file.
  grep -F "; ${COPY_CMD};" "${EXE_TIME_LOG}" > "${COPY_CMD_LOG}"
    COPY_CMD_LOG=$(readlink -ev "${COPY_CMD_LOG}")
    
  # Build plot commands. 
  PLOT_CMD="${PLOT_CMD} \"${COPY_CMD_LOG}\" using 1:5 title \"${COPY_CMD}\","
done

GNUPLOT_PG=benchmark-graph-gnuplot.pg
# Delete last plot command.
sed -i 's/^plot .*//' "${GNUPLOT_PG}"
# Delete the last comma(,) and add plot command.
echo "${PLOT_CMD}" | sed 's/,$//' >> "${GNUPLOT_PG}"

# Execute gnuplot.
./benchmark-graph-gnuplot.pg