#!/bin/bash

# This script takes rrfs grib2 forecast files, extracts 10m u and v wind
# components and outputs to netcdf. Comand line arguments are

#module load intel-oneapi/2022.2.0.262
#module load wgrib2/2.0.8

domain="oc"

OUTPUT_DIR="$COMINlocal/wind.$PDY.$cyc"
OUTPUT_FILE="$OUTPUT_DIR/nbm.$PDY.$cyc.wind10m.$domain.nc"

mkdir -p "$OUTPUT_DIR"
# Remove existing output file to avoid mixing old data
rm -f "$OUTPUT_FILE"

echo "writing 10m wind from $INPUT_DIR to $OUTPUT_FILE"

echo "nbm processing complete for forecast date $PDY, cycle $cyc, domain $domain"
echo "output written to: $OUTPUT_FILE"

#blendv5.0_oceanic_windspd_2026-05-27T00:00_2026-06-03T03:00.tif

nbmtmp=$tmp/nbm.$PDY.$cyc.$domain
mkdir -p $nbmtmp
aws s3 cp --no-sign-request s3://noaa-nbm-grib2-pds/blend.$PDY/$cyc/core/ $nbmtmp/ --recursive --exclude "*" --include "*.$domain.grib2"

# Loop through all items inside the target directory
for file_path in "$nbmtmp"/*; do
    # Extract only the filename from the full path
    filename=$(basename "$file_path")
    echo $file_path
    echo $filename
    filein=$nbmtmp/$filename
    wgrib2 $filein -match "(UGRD:10 m|VGRD:10 m)" -append -netcdf $OUTPUT_FILE
    
    # Print the filename
    echo "$filename"
done


#aws s3 cp s3://my-bucket/data/ . --recursive --exclude "*" --includ

#aws s3 cp --no-sign-request s3://noaa-nbm-grib2-pds/blend.20260524/00/core/ ./ --recursive --exclude "*" --include "*.oc.grib2"

#aws s3 cp s3://your-bucket-name/path/ . --recursive --exclude "*" --include "*.txt"


#aws s3 cp --no-sign-request s3://noaa-nbm-grib2-pds/blend.20260524/00/core/blend.t00z.core.f258.oc.grib2 ./
#WIND_FILE="blend.t00z.core.f258.oc.grib2"
#wgrib2 "$WIND_FILE" -match "(UGRD:10 m|VGRD:10 m)" -netcdf output.nc

#wgrib2 "$WIND_FILE"  -match ":UGRD:10 m:VGRD:10 m" -netcdf "$OUTPUT_FILE"
#wgrib2 blend.t00z.core.f003.oc.grib2 -match "(UGRD:10 m|VGRD:10 m)" -append -netcdf output.nc


#wgrib2 "$WIND_FILE"  -match ":VGRD:10 m" -append -netcdf "$OUTPUT_FILE"

#25:38322442:d=2026052400:UGRD:10 m above ground:258 hour fcst:
#26:39675712:d=2026052400:VGRD:10 m above ground:258 hour fcst:

#aws s3 ls --no-sign-request s3://noaa-nbm-grib2-pds/blend.20260524/00/core/aws s3 ls --no-sign-request s3://noaa-nbm-grib2-pds/blend.20260524/00/core/


#aws s3 ls --no-sign-request s3://noaa-nbm-grib2-pds/blend.t00z.core.f003.oc.grib2
#aws s3 cp --no-sign-request s3://noaa-nbm-pds/blendv5.0/oceanic/2026/05/27/0000/windspd/blendv5.0_oceanic_windspd_2026-05-27T00:00_2026-06-03T03:00.tif ./
#aws s3 cp --no-sign-request s3://noaa-nbm-pds/blendv5.0/oceanic/2026/05/27/0000/winddir/blendv5.0_oceanic_winddir_2026-05-27T00:00_2026-06-06T00:00.tif ./

 
