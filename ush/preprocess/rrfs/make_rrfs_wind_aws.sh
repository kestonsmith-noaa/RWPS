#!/bin/bash

# This script takes rrfs grib2 forecast files, extracts 10m u and v wind
# components and outputs to netcdf. Comand line arguments are
# forecast time: YYYYMMDD
# forecast cycle: CC
# frecast region: hi,pr,na,ak or conus
#
# For example call as:
# sh MakeRRFSWind.sh 20260428 00 pr
# to produce output file:
# rrfs.20260428.00.wind10m.pr.nc
#

domain="hi"
echo "MakeRRFSWind.sh fetching rrfs : time = $PDY, cycle = $cyc, domain = $domain"

module load intel-oneapi/2022.2.0.262
module load wgrib2/2.0.8

#specific dates of retrospectives
if [[ $PDY -ge 20240103 && $PDY -le 20240208 ]]; then season="winter"; fi
if [[ $PDY -ge 20240502 && $PDY -le 20240531 ]]; then season="spring"; fi
if [[ $PDY -ge 20240701 && $PDY -le 20240731 ]]; then season="summer"; fi

#season="winter" # 20240103 -20240208
#season="spring" # 20240502 -20240531  
#season="summer" # 20240701 -20240731

#INPUT_DIR="/lfs/h1/ops/para/com/rrfs/v1.0/rrfs.$1/$2"
INPUT_DIR="$COMINrrfs"
OUTPUT_DIR="$COMINlocal/wind.$PDY.$cyc"
OUTPUT_FILE="$OUTPUT_DIR/rrfs.$PDY.$cyc.wind10m.$domain.nc"

mkdir -p "$OUTPUT_DIR"
# Remove existing output file to avoid mixing old data
rm -f "$OUTPUT_FILE"

rrfstmp=$tmp/rrfs.$PDY.$cyc.$domain
mkdir -p $rrfstmp
#aws s3 cp --no-sign-request s3://noaa-nbm-grib2-pds/blend.$PDY/$cyc/core/ $nbmtmp/ --recursive --exclude "*" --include "*.$domain.grib2"
aws s3 cp --no-sign-request s3://noaa-rrfs-pds/retro_output_final/$season/rrfs.$PDY/$cyc/ $rrfstmp --recursive --exclude "*" --include "*.$domain.grib2"

#aws s3 cp --no-sign-request s3://noaa-rrfs-pds/retro_output_final/winter/rrfs.20240109/00/rrfs.t00z.prslev.f001.ak.grib2 ./
#aws s3 cp --no-sign-request s3://noaa-rrfs-pds/retro_output_final/winter/rrfs.20240109/00/rrfs.t00z.prslev.f001.$domain.grib2 ./
# Loop through all items inside the target directory
for file_path in "$rrfstmp"/*; do
    # Extract only the filename from the full path
    filename=$(basename "$file_path")
    echo $file_path
    echo $filename
    filein=$rrfstmp/$filename
#    wgrib2 $filein -match "(UGRD:10 m|VGRD:10 m)" -append -netcdf $OUTPUT_FILE
    wgrib2 $filein -match "(UGRD:10 m above ground|VGRD:10 m above ground)" -append -netcdf $OUTPUT_FILE
    
    # Print the filename
    echo "$filename"
done

