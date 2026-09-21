#!/bin/bash

# This script retrieves ice forecasts for global RTOFS and Alaska NBM as netcdf files
# PDY=YYYYMMDD, 
# cyc=00,06... two digit cycle number

cd ${HOMErwps}/ush/preprocess

if [ -v InputSource ]; then
    echo "InputSource = ${InputSource}"
else
    InputSource = "lfs"
fi

if [[ "${InputSource}" == *"AWS"* ]]; then
    sh rtofs/get_rtofs_ice_aws.sh ${PDY} ${cyc} &
    sh nbm/get_nbm_ice_aws.sh ${PDY} ${cyc} &
else
    sh rtofs/get_rtofs_ice.sh ${PDY} ${cyc} &
    sh nbm/get_nbm_ice.sh ${PDY} ${cyc} &
wait;
