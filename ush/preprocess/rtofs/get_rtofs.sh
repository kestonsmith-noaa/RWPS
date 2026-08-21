#!/bin/bash

#Retrieve global RTOFS currents and consolidate into a single NetCDF file

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

cd $RWPSroot/ush/preprocess

tmpdir="$COMINlocal/tmp.rtofs.$PDY"
filesin="$COMINrtofs/*prog.nc"
flout="$COMINlocal/rtofs.$PDY.nc"

mkdir -p $tmpdir
cp $filesin $tmpdir/
python rtofs/get_rtofs_fcst.py $tmpdir $flout

#rm -rf $tmpdir
