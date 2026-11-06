#!/bin/bash
################################################################################
# This script creates WW3 ww3_prind_(filed).inp files for RWPS
#
################################################################################

echo ' Start of rwps_make_prnc_inp.sh at: '
date

set -x

fields=("current" "ice" "level" "wind")

for field in "${fields[@]}"; do
    sed -e "s/COMOUT/${COMOUT}/g" \
        -e "s/NET/${NET}/g" \
        -e "s/CYC/${cyc}/g" \
        -e "s/MESHID/${meshID}/g" \
        "${RWPSfix}/ww3_prnc_ice.inp.tmpl" > ww3_prnc_$field.inp
    cat  ww3_prnc_$field.inp
#    export err=$?; err_chk
done

msg="JOB $job HAS COMPLETED NORMALLY."
postmsg "$msg"
