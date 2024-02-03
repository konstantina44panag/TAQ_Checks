#!/bin/bash
#COMPUTATION OF AVERAGE COMPRESSION RATES FOR EVERY YEAR:
set -eu
for year in $(seq 2007 1 2023) ; do
ssh panagopkonst@memos1.troias.offices.aueb.gr "cd ../../; ls -l /taq93-23/taq_msec${year}/m*/ctm_*" | awk '{print $9, $5}' | awk -F/ '{print $5, $6}' | sed 's/.gz//' | sed 's/.bz2//' |sort -n > memo_ctm_size
ssh wrds ls -l /wrdslin/nyse/taq_msec${year}/m*/ctm_*.sas7bdat |awk '{print $9, $5}' |awk  -F/ '{print $6,$7}'|sort -n >wrds_ctm_size
join wrds_ctm_size memo_ctm_size | awk '{print $0, $3 / $2 * 100}' >compression_rates
average=$(awk '{ sum += $4 } END { if (NR > 0) print sum/NR }' compression_rates)
result_110=$(awk -v average="$average" 'BEGIN {print average * 110 / 100}')
result_90=$(awk -v average="$average" 'BEGIN {print average * 90 / 100}')
awk '$4 > result_110 { print $1 }' result_110="$result_110" compression_rates >> check_files
awk '$4 < result_90 { print $1 }' result_90="$result_90" compression_rates >> check_files
done
cat check_files
