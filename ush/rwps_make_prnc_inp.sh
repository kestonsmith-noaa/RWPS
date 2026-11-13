#!/bin/bash
################################################################################
# This script creates WW3 ww3_prind_(filed).inp files for RWPS
#
################################################################################

echo ' Start of rwps_make_prnc_inp.sh at: '
date

set -x
readonly HOMErwps=$(cd "$(dirname "$(readlink -f -n "${BASH_SOURCE[0]}")")" && git rev-parse --show-toplevel)
export HOMErwps
RWPSparm=${HOMErwps}/parm
fields=("current" "ice" "level" "wind")

for field in "${fields[@]}"; do
    sed -e "s/COMOUT/${COMOUT}/g" \
        -e "s/NET/${NET}/g" \
        -e "s/CYC/${cyc}/g" \
        -e "s/MESHID/${meshID}/g" \
        "${RWPSparm}/ww3_prnc_ice.inp.tmpl" > ${RWPSparm}/ww3_prnc_$field.inp
    cat  ww3_prnc_$field.inp
#    export err=$?; err_chk
done

msg="JOB $job HAS COMPLETED NORMALLY."
postmsg "$msg"
