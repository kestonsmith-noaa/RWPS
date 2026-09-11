#!/bin/bash

#Retrieve global RTOFS currents and consolidate into a single NetCDF file
# Requires environmental variables:
# PDY=YYYYMMDD, 
# call as:
# $ sh get_rtofs.sh 20260829
# COMINlocal = work directory to write output files to
# COMINrtofs = directory path to rtofs forecast


cd $HOMErwps/ush/preprocess

tmpdir="$COMINlocal/tmp.rtofs.$PDY"
filesin="$COMINrtofs/*prog.nc"
flout="$COMINlocal/rtofs.$PDY.nc"

mkdir -p $tmpdir
cp $filesin $tmpdir/
python rtofs/get_rtofs_fcst.py $tmpdir $flout

