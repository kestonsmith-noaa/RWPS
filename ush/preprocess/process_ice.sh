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


inpdir=$tmp/ice.$PDY.$cyc

nbmice=$inpdir/nbm.$PDY.$cyc.ice.ak.nc
rtofsice=$inpdir/rtofs.ice.$PDY.nc


rtofs_wghts="$fix/InterpolationWeights.$meshname.rtofs.ice.nc"
rtofs_dists="$fix/DistToBndy.$meshname.rtofs.ice.nc"
nbm_ak_wghts="$fix/InterpolationWeights.$meshname.nbm.ak.nc"
nbm_ak_dists="$fix/DistToBndy.$meshname.nbm.ak.nc"

rtofs_rwps="$tmp/$meshname.$PDY.ice.rtofs.nc"
rtofs_rwps_ti="$tmp/$meshname.$PDY.$cyc.ice.rtofs.ti.nc"

nbm_rwps="$tmp/$meshname.$PDY.$cyc.ice.nbm.ak.nc"
nbm_rwps_ti="$tmp/$meshname.$PDY.$cyc.ice.nbm.ak.ti.nc"

varnames="ICEC_surface"

#rwps_ice="$frc/$meshname.$PDY.$cyc.ice.rtofsxnbm.nc"
rwps_ice="$frc/$meshname.$PDY.$cyc.ice.nc"

## NBM AK domain interpolation
## NOTE WE ARE USING THE RRFS ak WEIGHTS HERE NEED TO RELABEL AND RECOMPUTE FOR NBM AK DOMAIN
## DIFFERENCES ARE SMALL. posional distance ~200m on 3km grid roughly

#../../fix/DistToBndy.rwps.oc_1500m_30km.nbm.ak.nc


if [ ! -f "$nbm_ak_wghts" ]; then
    echo "missing nbm ak interpolation weights file: $nbm_ak_wghts"
    echo "compute with script ComputeUnstrToRWPSInterpWeights.sh"
    exit 1
fi

if [ ! -f "$nbm_ak_dists" ]; then
    echo "missing nbm ak  distance to boundary file: $nbm_ak_dists"
    echo "compute with script ComputeUnstrToRWPSInterpWeights.sh"
    exit 1
fi

# no extrapolation
python InterpolateWithWeights.py $nbmice $nbm_ak_wghts $nbm_rwps $varnames -1 &

## RTOFS interpolation

if [ ! -f "$rtofs_wghts" ]; then
    echo "missing rtofs interpolation weights file: $rtofs_wghts"
    echo "compute with script ComputeGridToRWPSInterpWeights.py"
    exit 2
fi
if [ ! -f "$rtofs_dists" ]; then
    echo "missing stofs distance to boundary file: $rtofs_dists"
    echo "compute with script ComputeUnstrToRWPSInterpWeights.py"
    exit 2
fi

# extrapolate with 0 as fill
echo "$rtofsice"
python InterpolateWithWeights.py $rtofsice $rtofs_wghts $rtofs_rwps $varnames 0 &

wait;

python AddMeshGeomToFile.py $rtofs_rwps $mesh
python AddMeshGeomToFile.py $nbm_rwps $mesh

#python AddErrVarToFile.py $rtofs_rwps $rtofs_dists 100.:1.:50.:250.:50.
#python AddErrVarToFile.py $stofs_rwps $stofs_dists 1.:100.:50.:250.

#interpolate from stofs to common stofs and rtofs times within range of stofs time
python InterpTime.py $rtofs_rwps $nbm_rwps $rtofs_rwps_ti $varnames False &

#interpolate from rtofs to common stofs and rtofs times within range of stofs time
#values out of range are extrapolated to assuming persistance
python InterpTime.py $rtofs_rwps $nbm_rwps $nbm_rwps_ti $varnames True &

wait

#uniform variance of 100.
python AddErrVarToFile.py $rtofs_rwps_ti $rtofs_dists 100.

#interior variance of 4., boundary variance fof 400., transition lengthscale 9. km
python AddErrVarToFile.py $nbm_rwps_ti $nbm_ak_dists 4.:400.:9.

python BayesForecastUpdate.py $rtofs_rwps_ti $nbm_rwps_ti $rwps_ice $varnames
