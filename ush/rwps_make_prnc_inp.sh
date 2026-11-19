#!/bin/bash
################################################################################
# This script creates WW3 ww3_prind_(filed).inp files for RWPS
#
################################################################################

echo ' Start of rwps_make_prnc_inp.sh at: '
date

set -x

mod_def_dir=/lfs/h2/emc/couple/noscrub/keston.smith/rwps_mod_def/
#rwps.oc_500m_10km.mod_def.ww3

readonly HOMErwps=$(cd "$(dirname "$(readlink -f -n "${BASH_SOURCE[0]}")")" && git rev-parse --show-toplevel)
export HOMErwps
RWPSparm=${HOMErwps}/parm
RWPSexec=${HOMErwps}/exec

fields=("current" "ice" "level" "wind")

# path relative to run directory, $DATA
COMOUTrel="."

for field in "${fields[@]}"; do
    inpfile=${DATA}/ww3_prnc_$field.inp

    cp ${RWPSparm}/ww3_prnc_$field.inp.tmpl ${inpfile}

    sed -i "s|NET|${NET}|g" ${inpfile}
    sed -i "s|CYC|${cyc}|g" ${inpfile}
    sed -i "s|MESHID|${meshID}|g" ${inpfile}
    sed -i "s|COMOUT|${COMOUTrel}|g" ${inpfile}

    cat   ${inpfile}
    export err=$?; err_chk

    cp $inpfile ${COMOUT}/
done

cp ${mod_def_dir}/rwps.${meshID}.mod_def.ww3 ${DATA}/mod_def.ww3

cd ${DATA}
for field in "${fields[@]}"; do
    inpfile=${DATA}/ww3_prnc_$field.inp
    cp $inpfile ww3_prnc.inp
    ${RWPSexec}/waveprnc
    export err=$?; err_chk
done

msg="JOB $job HAS COMPLETED NORMALLY."
postmsg "$msg"
