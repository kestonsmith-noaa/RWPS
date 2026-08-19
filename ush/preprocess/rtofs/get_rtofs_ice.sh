#!/bin/bash

#Retrieve global RTOFS ice forecast and consolidate in single NetCDF filesin

module reset
module load PrgEnv-intel/8.5.0
module load intel/19.1.3.304
module load craype/2.7.17
module load cray-mpich/8.1.19
module load hdf5-C/1.14.0
module load netcdf-C/4.9.2
module load esmf-C/8.6.0
module load ve/hafs/2.1

pip list -v

#source rwpsenv

tmpdir="$COMINlocal/tmp.rtofsIce.$PDY"
filesin="$COMINrtofs/*ice.nc"
dirout="$COMINlocal/ice.$PDY.$cyc"
flout="$dirout/rtofs.ice.$PDY.nc"
#flout="$tmp/rtofs.ice.$PDY.nc"

mkdir $tmpdir
cp $filesin $tmpdir/
echo $tmpdir
echo $flout

PDYCC="${PDY}${cyc}"
echo $PDYCC
python rtofs/get_rtofs_ice_fcst.py $tmpdir $PDYCC $flout

## rm -rf $tmpdir
