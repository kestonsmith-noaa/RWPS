#!/bin/bash

# This script takes rrfs grib2 forecast files, extracts 10m u and v wind
# components and outputs to netcdf. Comand line arguments are

module load intel-oneapi/2022.2.0.262
module load wgrib2/2.0.8

INPUT_DIR="/lfs/h3/mdl/ptmp/mdl.nbm/blend/v5.2/blend.$1/$2/grib2"
INPUT_DIR="/lfs/h3/mdl/ptmp/mdl.nbm/blend/v5.2/blend.$1/$2/grib2"

WSPD_FILE="$COMINnbm/blend.t$2z.wspd.$3.grib2"
WDIR_FILE="$COMINnbm/blend.t$2z.wdir.$3.grib2"

OUTPUT_DIR="wind.$1.$2"
OUTPUT_DIR="$COMINlocal/wind.$1.$2"
OUTPUT_FILE="$OUTPUT_DIR/nbm.$1.$2.wind10m.$3.nc"

mkdir -p "$OUTPUT_DIR"
# Remove existing output file to avoid mixing old data
rm -f "$OUTPUT_FILE"

echo "writing 10m wind from $INPUT_DIR to $OUTPUT_FILE"

wgrib2 "$WSPD_FILE"  -match ":WIND:10 m" -netcdf "$OUTPUT_FILE"
wgrib2 "$WDIR_FILE"  -match ":WDIR:10 m" -append -netcdf "$OUTPUT_FILE"

echo "nbm processing complete for forecast date $1, cycle $2, domain $3"
echo "output written to: $OUTPUT_FILE"
blendv5.0_oceanic_windspd_2026-05-27T00:00_2026-06-03T03:00.tif


aws s3 cp --no-sign-request s3://noaa-nbm-grib2-pds/blend.20260524/00/core/blend.t00z.core.f258.oc.grib2 ./
WIND_FILE="blend.t00z.core.f258.oc.grib2"
wgrib2 "$WIND_FILE" -match "(UGRD:10 m|VGRD:10 m)" -netcdf output.nc

wgrib2 "$WIND_FILE"  -match ":UGRD:10 m:VGRD:10 m" -netcdf "$OUTPUT_FILE"
#wgrib2 "$WIND_FILE"  -match ":VGRD:10 m" -append -netcdf "$OUTPUT_FILE"

#25:38322442:d=2026052400:UGRD:10 m above ground:258 hour fcst:
#26:39675712:d=2026052400:VGRD:10 m above ground:258 hour fcst:

#aws s3 ls --no-sign-request s3://noaa-nbm-grib2-pds/blend.20260524/00/core/aws s3 ls --no-sign-request s3://noaa-nbm-grib2-pds/blend.20260524/00/core/


#aws s3 ls --no-sign-request s3://noaa-nbm-grib2-pds/blend.t00z.core.f003.oc.grib2
#aws s3 cp --no-sign-request s3://noaa-nbm-pds/blendv5.0/oceanic/2026/05/27/0000/windspd/blendv5.0_oceanic_windspd_2026-05-27T00:00_2026-06-03T03:00.tif ./
#aws s3 cp --no-sign-request s3://noaa-nbm-pds/blendv5.0/oceanic/2026/05/27/0000/winddir/blendv5.0_oceanic_winddir_2026-05-27T00:00_2026-06-06T00:00.tif ./

 
