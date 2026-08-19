#!/bin/bash
#PBS -N ESMPy
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A NWPS-DEV
#PBS -l walltime=00:05:00
#PBS -l select=1:ncpus=8:mem=128G
#PBS -l place=excl
#PBS -l debug=true

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

##filein=$1
##meshfile=$2
##Nprocs=$3

cd /lfs/h2/emc/couple/noscrub/keston.smith/TestRWPS/RWPS/dev/PreProcess

filein="/lfs/h2/emc/couple/noscrub/keston.smith/SampleInput/stofs.20260730.00/stofs_2d_glo.t00z.fields.cwl.nc"
#meshfile="/lfs/h2/emc/couple/noscrub/keston.smith/RWPS/fix/oc_1500m_30km/20260722/rwps.oc_1500m_30km.msh"
meshfile="/lfs/h2/emc/couple/noscrub/keston.smith/RWPS/fix/oc_5km_100km/20260722/rwps.oc_5km_100km.msh"
Nprocs=32

meshname="${meshfile##*/}"
meshname="${meshname: 0: -4}"



## First construct parallel jobscript to compute weights using Nprocs division of destination domain(meshfile)
python compute_unstr_to_rwps_interp_weights.py $filein $meshfile $Nprocs

## Now run parallel job script
## sbatch jobcardcompute_unstr_to_rwps_interp_weightsSLURM

qsub -W block=true jobcardcompute_unstr_to_rwps_interp_weightsPBS


wait

##cat STOFSInterpWeights.$meshname/Part.IntrpWghts.*.txt > STOFS.wght.$meshname.txt 
cat STOFSInterpWeights.$meshname/Part.IntrpWghts.*.txt > InterpWeights.$meshname.stofs.txt

# convert output weights to netcdf file 


##python convert_weights_to_netcdf.py /lfs/h2/emc/couple/noscrub/keston.smith/SampleInput/stofs.20260730.00/stofs_2d_glo.t00z.fields.cwl.nc /lfs/h2/emc/couple/noscrub/keston.smith/RWPS/fix/oc_1500m_30km/20260722/rwps.oc_1500m_30km.msh 

## Now knit output from parallel job together and write to netcdf format
## The third argument "1" indicates to write (x,y) for destination and source nodes
## to support extrapolation

python convert_weights_to_netcdf.py $filein $meshfile 1

