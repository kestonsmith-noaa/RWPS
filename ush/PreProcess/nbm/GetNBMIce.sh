#!/bin/bash

# This is just a place holder with notes for the time being. Notes on aws retrieval and processing are below
# This script takes rrfs grib2 forecast files, extracts 10m u and v wind
# components and outputs to netcdf. Comand line arguments are

module load intel-oneapi/2022.2.0.262
module load wgrib2/2.0.8


#source ../rwpsenv


#INPUT_DIR="/lfs/h3/mdl/ptmp/mdl.nbm/blend/v5.2/blend.$1/$2/grib2"

#ICE_FILE="$INPUT_DIR/blend.t$2z.icec.ak.grib2"

ICE_FILE="$COMINnbm/blend.t$2z.icec.ak.grib2"

#OUTPUT_DIR="$tmp/ice.$1.$2"
OUTPUT_DIR="$COMINlocal/ice.$1.$2"
OUTPUT_FILE="$OUTPUT_DIR/nbm.$1.$2.ice.ak.nc"

mkdir "$OUTPUT_DIR"
# Remove existing output file to avoid mixing old data
rm -f "$OUTPUT_FILE"

echo "writing ice from $INPUT_DIR to $OUTPUT_FILE"

wgrib2 "$ICE_FILE"  -match ":ICEC:" -netcdf "$OUTPUT_FILE"

echo "nbm ice processing complete for forecast date $1, cycle $2, domain ak"
echo "output written to: $OUTPUT_FILE"
