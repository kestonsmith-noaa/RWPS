#!/bin/bash

## This script retrieves global STOFS water level as netcdf file
# PDY=YYYYMMDD, 
# cyc=00,06... two digit cycle number

cd ${HOMErwps}/ush/preprocess

if [ -v InputSource ]; then
    echo "InputSource = ${InputSource}"
else
    InputSource = "lfs"
fi

if [[ "${InputSource}" == *"AWS"* ]]; then
    stofs/get_stofs_aws.sh ${PDY} ${cyc} waterlevel 
else
    stofs/get_stofs.sh ${PDY} ${cyc} waterlevel 
fi
