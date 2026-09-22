#!/bin/bash

#Retrieve global RTOFS currents and consolidate into a single NetCDF file
# Requires environmental variables:
# {PDY}=YYYYMMDD, 
# call as:
# $ sh get_rtofs.sh 20260829
# COMINlocal = work directory to write output files to
# COMINrtofs = directory path to rtofs forecast


tmpdir="${COMINlocal}/tmp.rtofs.${PDY}"
filesin="${COMINrtofs}/*prog.nc"
flout="${COMINlocal}/rtofs.${PDY}.nc"

mkdir -p ${tmpdir}
cp ${filesin} ${tmpdir}/
python ${HOMErwps}/ush/preprocess/rtofs/get_rtofs_fcst.py ${tmpdir} ${flout}

