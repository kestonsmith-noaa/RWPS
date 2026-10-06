#!/bin/bash

# This script takes rrfs grib2 forecast files, extracts 10m u and v wind
# components and outputs to netcdf. Comand line arguments are

PDY=$1
cyc=$2
domain=$3

#domain="oc"

if [[ ! -v tmp ]]; then
    tmp="./"
    echo "tmp set to current directory. Should have been set elsewhere"
else
    echo "tmp set to $tmp"
fi

HOMErwps=$(cd "$(dirname "$(readlink -f -n "${BASH_SOURCE[0]}")")" && git rev-parse --show-toplevel)

source $HOMErwps/ush/preprocess/load_modules_preprocess.sh


OUTPUT_DIR="${tmp}/wind.${PDY}.${cyc}"
OUTPUT_FILE="${OUTPUT_DIR}/nbm.${PDY}.${cyc}.wind10m.${domain}.nc"

mkdir -p "${OUTPUT_DIR}"
# Remove existing output file to avoid mixing old data
rm -f "${OUTPUT_FILE}"

echo "writing 10m wind from $INPUT_DIR to $OUTPUT_FILE"

echo "nbm processing complete for forecast date ${PDY}, cycle ${cyc}, domain ${domain}"
echo "output written to: $OUTPUT_FILE"

#blendv5.0_oceanic_windspd_2026-05-27T00:00_2026-06-03T03:00.tif

nbmtmp=${tmp}/nbm.${PDY}.${cyc}.${domain}
mkdir -p ${nbmtmp}
#aws s3 cp --no-sign-request s3://noaa-nbm-grib2-pds/blend.${PDY}/${cyc}/core/ ${nbmtmp}/ --recursive --exclude "*" --include "*.${domain}.grib2"
$AWS s3 cp --no-sign-request s3://noaa-nbm-grib2-pds/blend.${PDY}/${cyc}/core/ ${nbmtmp}/ --recursive --exclude "*" --include "*.${domain}.grib2"

# Loop through all items inside the target directory
if [[ ${MACHINE_ID} = hera* ]]; then
    module load wgrib2/3.1.3_wmo
fi

for file_path in "$nbmtmp"/*; do
    # Extract only the filename from the full path
    filename=$(basename "$file_path")
    echo $file_path
    echo $filename
    filein=$nbmtmp/${filename}
    wgrib2 ${filein} -match "(UGRD:10 m|VGRD:10 m)" -append -netcdf ${OUTPUT_FILE}
    
    # Print the filename
    echo "${filename}"
done

