#!/bin/bash

# This script retrieves global RTOFS and STOFS as netcdf files
# Requires environmental variables:
# PDY=YYYYMMDD, 
# cyc=00,06... two digit cycle number

cd ${HOMErwps}/ush/preprocess

if [ -v InputSource ]; then
    echo "InputSource = ${InputSource}"
else
    InputSource = "lfs"
fi

if [[ "${InputSource}" == *"AWS"* ]]; then
    rtofs/get_rtofs_aws.sh ${PDY} &
    stofs/get_stofs_aws.sh ${PDY} ${cyc} current &
else
    rtofs/get_rtofs.sh ${PDY} &
    stofs/get_stofs.sh ${PDY} ${cyc} current &
fi

wait;
