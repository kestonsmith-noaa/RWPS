#!/bin/bash
# This script retrieves ice forecasts for global RTOFS and Alaska NBM as netcdf files
cd $HOMErwps/ush/preprocess
sh rtofs/get_rtofs_ice.sh $PDY $cyc &

if [[ $mixed_ice_forcing -eq 1 ]]; then
    sh nbm/get_nbm_ice.sh $PDY $cyc &
fi
wait;
