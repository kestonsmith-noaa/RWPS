#!/bin/bash 

# Setup and load modules 
module load PrgEnv-intel/8.1.0
module load craype/2.7.8
module load intel/19.1.3.304
module load cfp/2.0.4
module load prod_util/2.0.8
module load prod_envir/2.0.5

# 0.a Set necessary variables

# This script retrieves and processes forcing for a forecast period
#date=$1
#cycl=$2
#mesh=$3


##date=20260707 
##cycl=00
##mesh="../meshes/RWPS.V0a.small.msh"

meshname="${mesh##*/}"
meshname="${meshname: 0: -4}"

echo "retrieving and processing RWPS forcing for $PDY z$cyc for WW3 mesh $mesh"

rm FetchWinds.out ProcWinds.out FetchCurrents.out ProcCurrents.out FetchWaterLevel.out ProcWaterLevel.out

(
    echo "retrieving nbm and rrfs winds for $PDY z$cyc"
    sh GetWinds.sh $PDY $cyc  > FetchWinds.out
    echo "processing winds for $PDY z$cyc for $mesh"
    sh ProcessWinds.sh $PDY $cyc $mesh > ProcWinds.out
)&

(
    echo "retrieving rtofs and stofs currents for $PDY z$cyc"
    sh GetCurrents.sh $PDY $cyc > FetchCurrents.out
    echo "processing currents for $PDY z$cyc for $mesh"
    sh ProcessCurrents.sh $PDY $cyc $mesh  > ProcCurrents.out
)&

(
    echo "retrieving stofs water level for $PDY z$cyc"
    sh GetWaterLevel.sh $PDY $cyc > FetchWaterLevel.out
    echo "processing water level for $PDY z$cyc for $mesh"
    sh ProcessWaterLevel.sh $PDY $cyc $mesh  > ProcWaterLevel.out
)&

wait
echo "Finished preprocessing for $PDY z$cyc for $mesh"

cp $meshname.$PDY.$cyc.vel.stofsxrtofs.nc $meshname.$PDY.$cyc.current.nc
echo "current forcing file:  $meshname.$PDY.$cyc.current.nc"

cp $meshname.$PDY.$cyc.cwl.stofs.nc $meshname.$PDY.$cyc.waterlevel.nc
echo "water level forcing file:  $meshname.$PDY.$cyc.watterlevel.nc"

cp rwps_winds.$meshname.$PDY.$cyc/rwps.est.$meshname.$PDY.$cyc.wind10m.nc $meshname.$PDY.$cyc.wind.nc
echo "wind forcing file:  $meshname.$PDY.$cyc.wind.nc"

