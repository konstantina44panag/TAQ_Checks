#!/bin/bash
#Run this script after the compression_rates_{filetype} script,
#to check the files with extreme compression rates for corruption
for line in $(cat check_files); do
ssh panagopkonst@memos1.troias.offices.aueb.gr "cd ../../; find /taq93-23/ -type f -name '${line}.*' -exec sh -c 'if [ -e {} ]; then if echo {} | grep -q \".gz$\"; then gzip -t -v {}; elif echo {} | grep -q \".bz2$\"; then bzip2 -t -v {}; fi; fi' \;"
done
rm check_files