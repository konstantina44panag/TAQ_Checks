#!/bin/bash
#Completeness Check FOR DATA 2007-2023 of the form:
#/wrdslin/nyse/taq_msecYYYY/mYYYYMM/complete_nbbo_YYYYMMDD.sas7bdat
#/wrdslin/nyse/taq_msecYYYY/mYYYYMM/ctm_YYYYMMDD.sas7bdat
#/wrdslin/nyse/taq_msecYYYY/mYYYYMM/mastm_YYYYMMDD.sas7bdat
#Code:
set -eu
for year in $(seq 2007 1 2023) ; do
 for m in $(seq 1 1 12) ; do
    month=$(printf '%02d' $m)
    ssh wrds ls /wrdslin/nyse/taq_msec$year/m$year$month >wrds_all
    ssh panagopkonst@memos1.troias.offices.aueb.gr "cd ../../; ls /taq93-23/taq_msec${year}/m$year$month " >memo
    egrep '^(complete_nbbo|mastm|ctm).*sas7bdat$' wrds_all |sort -n >wrds_data 
    sed 's/.gz//' memo |sed 's/.bz2//' | sort -n >memo_data
    comm -13 memo_data wrds_data >only_wrds
 done
done
cat only_wrds

