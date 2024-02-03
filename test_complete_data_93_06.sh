#!/bin/bash
set -eu
#Completeness Check FOR DATA 1993-2006 of the form:
#/wrdslin/taq.YYYY/taqYYa{monthLetterIdentifier}/sasdata/div_YYYYMM.sas7bdat
#/wrdslin/taq.YYYY/taqYYa{monthtterIdentifier}/sasdata/mast_YYYYMM.sas7bdat
#/wrdslin/taq.YYYY/taqYYa{monthIdentifier}/sasdata/cq_YYYYMMDD.sas7bdat
for year in $(seq 1993 1 2006) ; do
y=$(printf '%02d' $(expr $year \% 100) )
if [ $year -lt 2004 ] ; then
ssh  panagopkonst@memos1.troias.offices.aueb.gr ls /nyse/nyse/taq${year}taq${y}d/  >memo
ssh wrds ls /wrdslin/taq.$year/taq${y}d/sasdata/ >wrds_all
egrep '^(div|mast|cq).*sas7bdat$'  wrds_all >wrds_data 
sed 's/.gz//' memo |sed 's/.bz2//' |sort -n >memo_data
comm -13 memo_data wrds_data >only_wrds
for line in $(cat only_wrds) ; do
echo $line >>missingfiles
done
fi
if [ $year == 2004 ]   ; then
for i in a b; do
ssh  panagopkonst@memos1.troias.offices.aueb.gr ls /nyse/nyse/taq${year}taq$y${i}d/ >memo
ssh wrds ls /wrdslin/taq.$year/taq$y${i}d/sasdata/ >wrds_all
egrep '^(div|mast|cq).*sas7bdat$'  wrds_all >wrds_data
sed 's/.gz//' memo |sed 's/.bz2//' |sort -n >memo_data
comm -13 memo_data wrds_data >only_wrds
for line in $(cat only_wrds) ; do
echo $line >>missingfiles
done
done
fi
if [ $year -gt  2004 ]   ; then
for i in a b c ; do
ssh  panagopkonst@memos1.troias.offices.aueb.gr ls /nyse/nyse/taq${year}taq$y${i}d/ >memo
ssh wrds ls /wrdslin/taq.$year/taq$y${i}d/sasdata/ >wrds_all
egrep '^(div|mast|cq).*sas7bdat$'  wrds_all >wrds_data
sed 's/.gz//' memo |sed 's/.bz2//' |sort -n >memo_data
comm -13 memo_data wrds_data >only_wrds
for line in $(cat only_wrds) ; do
echo $line >>missingfiles
done
done
fi
done
cat missingfiles

