#!/bin/bash
#PBS -N ESMPy
#PBS -j oe
#PBS -S /bin/bash
#PBS -q dev
#PBS -A NWPS-DEV
#PBS -l walltime=00:05:00
#PBS -l select=1:ncpus=1:mem=8G
#PBS -l place=excl
#PBS -l debug=true

filein=$1
meshfile=$2
Nprocs=$3

## First construct parallel jobscript to compute weights using Nprocs division of destination domain(meshfile)
python compute_unstr_to_rwps_interp_weights.py $filein $meshfile $Nprocs

## Now run parallel job script
## sbatch jobcardcompute_unstr_to_rwps_interp_weightsSLURM
qsub jobcardcompute_unstr_to_rwps_interp_weightsPBS
wait;

## Now knit output from parallel job together and write to netcdf format
## The third argument "1" indicates to write (x,y) for destination and source nodes
## to support extrapolation

python convert_weights_to_netcdf.py $filein $meshfile 1

