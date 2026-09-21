#!/bin/bash

#Retrieve global RTOFS ice forecast and consolidate in single NetCDF filesin

PDY=${1}
cyc=${2}

#module reset
#module load PrgEnv-intel/8.5.0
#module load intel/19.1.3.304
#module load craype/2.7.17
#module load cray-mpich/8.1.19
#module load hdf5-C/1.14.0
#module load netcdf-C/4.9.2
#module load esmf-C/8.6.0
#module load ve/hafs/2.1

module load aws
pip list -v

#source rwpsenv

if [[ ! -v COMINlocal ]]; then
    COMINlocal="./"
    echo "COMINlocal set to current directory. Should have been set elsewhere"
else
    echo "COMINlocal set to ${COMINlocal}"
fi

tmpdir="${COMINlocal}/tmp.rtofsIce.${PDY}"
outdir="${COMINlocal}/ice.${PDY}.${cyc}"
flout="${outdir}/rtofs.ice.${PDY}.nc"

mkdir -p ${tmpdir}
mkdir -p ${outdir}

aws s3 cp --no-sign-request s3://noaa-nws-rtofs-pds/rtofs.${PDY}/ ${tmpdir}/  --recursive --exclude "*" --include "*_ice.nc"

PDYCC="${PDY}${cyc}"
echo ${PDYCC}

python rtofs/get_rtofs_ice_fcst.py ${tmpdir} ${PDYCC} ${flout}

# rm -rf ${tmpdir}
