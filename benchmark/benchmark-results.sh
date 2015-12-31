#!/bin/bash
set -e
# Description: Extract command details from mtran.sh and add it benchmark-results.md.

MTRAN_SCRIPT=$(whereis mtran | cut -d ' ' -f2)
if [ -z "${MTRAN_SCRIPT}" ]; then echo "Error: mtran is not found. Aborted!"; exit 1; fi

echo "${MTRAN_SCRIPT}"

BENCHMARK_RESULTS_MD=benchmark-results.md
# Delete all lines after '# Commands code'
sed -i '/# Commands code/,$d' "${BENCHMARK_RESULTS_MD}"
echo '# Commands code' >> "${BENCHMARK_RESULTS_MD}"
echo '```bash' >>"${BENCHMARK_RESULTS_MD}"
  sed -n '/^ *case "${ACTION}" in/, /^ *esac$/p' "${MTRAN_SCRIPT}" >>"${BENCHMARK_RESULTS_MD}"
echo '```' >>"${BENCHMARK_RESULTS_MD}"