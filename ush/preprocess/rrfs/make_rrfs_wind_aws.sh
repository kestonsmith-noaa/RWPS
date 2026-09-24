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

PDY=$1
cyc=$2
domain=$3

echo "MakeRRFSWind.sh fetching rrfs : time = ${PDY}, cycle = ${cyc}, domain = ${domain}"

module load intel-oneapi/2022.2.0.262
module load wgrib2/2.0.8

#specific dates of retrospectives
if [[ ${PDY} -ge 20240108 && ${PDY} -le 20240208 ]]; then season="winter"; fi
if [[ ${PDY} -ge 20240502 && ${PDY} -le 20240531 ]]; then season="spring"; fi
if [[ ${PDY} -ge 20240701 && ${PDY} -le 20240731 ]]; then season="summer"; fi

#season="winter" # 20240103 -20240208
#season="spring" # 20240502 -20240531  
#season="summer" # 20240701 -20240731

if [[ ! -v tmp ]]; then
    tmp="./"
    echo "tmp set to current directory. Should have been set elsewhere"
else
    echo "tmp set to $tmp"
fi

OUTPUT_DIR="${tmp}/wind.${PDY}.${cyc}"
OUTPUT_FILE="${OUTPUT_DIR}/rrfs.${PDY}.${cyc}.wind10m.${domain}.nc"

mkdir -p "${OUTPUT_DIR}"
# Remove existing output file to avoid mixing old data
rm -f "${OUTPUT_FILE}"

rrfstmp=${tmp}/rrfs.${PDY}.${cyc}.${domain}
mkdir -p ${rrfstmp}

echo "aws s3 cp --no-sign-request s3://noaa-rrfs-pds/retro_output_final/${season}/rrfs.${PDY}/${cyc}/ ${rrfstmp} --recursive --exclude * --include *.${domain}.grib2 "
aws s3 cp --no-sign-request s3://noaa-rrfs-pds/retro_output_final/${season}/rrfs.${PDY}/${cyc}/ ${rrfstmp} --recursive --exclude "*" --include "*.${domain}.grib2"

#aws s3 cp --no-sign-request s3://noaa-rrfs-pds/retro_output_final/winter/rrfs.20240109/00/rrfs.t00z.prslev.f001.ak.grib2 ./
#aws s3 cp --no-sign-request s3://noaa-rrfs-pds/retro_output_final/winter/rrfs.20240109/00/rrfs.t00z.prslev.f001.${domain}.grib2 ./
# Loop through all items inside the target directory
if [[ ${MACHINE_ID} = hera* ]]; then
    module load wgrib2/3.1.3_wmo
fi
for file_path in "${rrfstmp}"/*; do
    # Extract only the filename from the full path
    
    filename=$(basename "${file_path}")
    echo $file_path
    echo $filename
    filein=${rrfstmp}/${filename}

    wgrib2 $filein -match "(UGRD:10 m above ground|VGRD:10 m above ground)" -append -netcdf ${OUTPUT_FILE}
    echo "$filename"
done

#rm -rf $rrfstmp

