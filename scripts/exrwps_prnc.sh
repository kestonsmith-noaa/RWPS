#!/bin/sh
###############################################################################
# This script is run to set ww3_prnc_(field).inp files and runs waveprnc to 
# create binary input files for the ww3 forecast.
###############################################################################
set -x

cd ${DATA}

echo ' Start of rwps_prnc.sh at: '
date

set -x

#temporary directory before these are added to the fix archive
mod_def_dir=/lfs/h2/emc/couple/noscrub/keston.smith/rwps_mod_def/

readonly HOMErwps=$(cd "$(dirname "$(readlink -f -n "${BASH_SOURCE[0]}")")" && git rev-parse --show-toplevel)
export HOMErwps
export RWPSparm=${HOMErwps}/parm
export RWPSexec=${HOMErwps}/exec

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

# run www3prnc for each field
cp ${mod_def_dir}/rwps.${meshID}.mod_def.ww3 ${DATA}/mod_def.ww3

for field in "${fields[@]}"; do
    inpfile=${DATA}/ww3_prnc_$field.inp
    cp $inpfile ww3_prnc.inp
    ${RWPSexec}/waveprnc
    export err=$?; err_chk
done

msg="JOB $job HAS COMPLETED NORMALLY."
postmsg "$msg"
