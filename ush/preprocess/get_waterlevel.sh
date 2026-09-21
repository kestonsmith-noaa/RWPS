#!/bin/bash

## This script retrieves global STOFS water level as netcdf file
# PDY=YYYYMMDD, 
# cyc=00,06... two digit cycle number

cd ${DATA}
${HOMErwps}/ush/preprocess/stofs/get_stofs.sh ${PDY} ${cyc} waterlevel 
