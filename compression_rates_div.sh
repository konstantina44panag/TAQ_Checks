#!/bin/bash
#COMPUTATION OF AVERAGE COMPRESSION RATES FOR EVERY YEAR:
for year in $(seq 1993 1 2006) ; do 
y=$(printf '%02d' $(expr $year \% 100) )
ssh panagopkonst@memos1.troias.offices.aueb.gr "cd ../../; ls -l /taq93-23/taq${year}taq$y*/div_*" | awk '{print $9, $5}' | awk -F/ '{print $4, $5}' | sed 's/.gz//' | sed 's/.bz2//' > memo_size
ssh wrds ls -l /wrdslin/taq.$year/taq*d/sasdata/div* |awk '{print $9,$5}' |awk -F/ '{print $6, $7}' |sed 's/.gz//'| sed 's/.bz2//' >wrds_size
join wrds_size memo_size | awk '{print $0, $3 / $2 * 100}' >compression_rates
average=$(awk '{ sum += $4 } END { if (NR > 0) print sum/NR }' compression_rates)
result_110=$(awk -v average="$average" 'BEGIN {print average * 110 / 100}')
result_90=$(awk -v average="$average" 'BEGIN {print average * 90 / 100}')
awk '$4 > result_110 { print $1 }' result_110="$result_110" compression_rates >> check_files
awk '$4 < result_90 { print $1 }' result_90="$result_90" compression_rates >> check_files
done
cat check_files
