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

#PSURGE_FILE=$COMINpsurge/psurge.t${1}${2}z.al052026_e$3_inc_agl.h102.conus_625m.grib2
date=$1
cyc=$2
prcntl=$3
domain=$4

#PSURGE_FILE=$COMINpsurge/psurge.t${date}${cyc}z.al052026_e${prcntl}_inc_agl.h102.${domain}_*.grib2
PSURGE_FILE=$COMINpsurge/psurge.t${date}${cyc}z.*_e${prcntl}_inc_dat.*.${domain}_*.grib2

OUTPUT_DIR="$COMINlocal/psurge.$1.$2"
OUTPUT_FILE="$OUTPUT_DIR/psurge.$1.$2.e$3.$4.nc"

mkdir -p "$OUTPUT_DIR"
# Remove existing output file to avoid mixing old data
rm -f "$OUTPUT_FILE"

echo "getting psurge waterlevel from $PSURGE_FILE"
echo "writing output to $OUTPUT_FILE"
if [[ $prcntl -eq 10 ]]; then
    varname="SURGE"
else
    varname="TCSRG$3"
fi
flin=$(ls $PSURGE_FILE)
#wgrib2 "$PSURGE_FILE"  -match ":SURGE:" -netcdf "$OUTPUT_FILE"
echo "wgrib2 $PSURGE_FILE  -match :$varname: -netcdf $OUTPUT_FILE"
#wgrib2 "$PSURGE_FILE"  -match ":$varname:" -netcdf "$OUTPUT_FILE"
wgrib2 $flin  -match ":$varname:" -netcdf "$OUTPUT_FILE"

#TCSRG50, SURGE

echo "psurge waterlevel processing complete for forecast date $1, cycle $2 and probability of exceedance e$3 for domain $domain"
echo "output written to: $OUTPUT_FILE"
