#!/bin/bash

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

source ./rwpsenv

meshname="${mesh##*/}"
meshname="${meshname: 0: -4}"

stofslev="$tmp/stofs.$PDY.$cyc/stofs_2d_glo.t${cyc}z.fields.cwl.nc"
stofs_wghts="$fix/InterpolationWeights.$meshname.stofs.nc"
stofs_dists="$fix/DistToBndy.$meshname.stofs.nc"

stofs_rwps="$frc/$meshname.$PDY.$cyc.cwl.stofs.nc"
waterlevel_rwps="$frc/$meshname.$PDY.$cyc.cwl.waterlevel.nc"
stofs_rwps=$waterlevel_rwps
varnames="zeta"

## STOFS interpolation

if [ ! -f "$stofs_wghts" ]; then
    echo "missing stofs interpolation weights file: $stofs_wghts"
    echo "compute with script ComputeUnstrToRWPSInterpWeights.sh"
    exit 1
fi
if [ ! -f "$stofs_dists" ]; then
    echo "missing stofs distance to boundary file: $stofs_dists"
    echo "compute with script ComputeUnstrToRWPSInterpWeights.sh"
    exit 1
fi

python InterpolateWithWeights.py $stofslev $stofs_wghts $stofs_rwps $varnames 0 
python AddMeshGeomToFile.py $stofs_rwps $mesh
python AddErrVarToFile.py $stofs_rwps $stofs_dists 1.

