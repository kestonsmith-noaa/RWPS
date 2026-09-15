#!/bin/bash

######################################################################
# retrieve psurge waterlevel at a particular probability of exceedance 
# bash get_psurge.sh PDY cyc exceedance level
# eg. bash get_psurge.sh 20260901 12 10
# or 
# eg. bash get_psurge.sh 20260901 12 50
######################################################################
#COMINpsurge=/lfs/h1/ops/prod/com/psurge/v3.2/psurge.20260901

#PSURGE_FILE=$COMINpsurge/psurge.t${PDY}${cyc}z.al052026_e${psurge_prcntl}_inc_agl.h102.conus_625m.grib2
PSURGE_FILE=$COMINpsurge/psurge.t${1}${2}z.al052026_e$3_inc_agl.h102.conus_625m.grib2

OUTPUT_DIR="$COMINlocal/psurge.$1.$2"
OUTPUT_FILE="$OUTPUT_DIR/psurge.$1.$2.e$3.nc"

mkdir -p "$OUTPUT_DIR"
# Remove existing output file to avoid mixing old data
rm -f "$OUTPUT_FILE"

echo "getting psurge waterlevel from $PSURGE_FILE"
echo "writing output to $OUTPUT_FILE"
if [[ $3 -eq 10 ]]; then
    varname="SURGE"
else
    varname="TCSRG$3"
fi

wgrib2 "$PSURGE_FILE"  -match ":$varname:" -netcdf "$OUTPUT_FILE"

#TCSRG50, SURGE

echo "psurge waterlevel processing complete for forecast date $1, cycle $2 and probability of exceedance level e$3"
echo "output written to: $OUTPUT_FILE"
