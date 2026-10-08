#! /usr/bin/env bash

###############################################################
# Consolidated module loading script for global-workflow
# Usage: source load_modules.sh [module_type]
# where module_type can be: run, gsi, verif, ufsda, ufswm, setup
# Default module_type is 'run'
###############################################################

# Find module command and purge:

source "${HOMErwps}/ush/detect_machine.sh"
source "${HOMErwps}/ush/module-setup.sh"

if [[ "${MACHINE_ID}" == "wcoss2" ]]; then
    module load PrgEnv-intel/${PrgEnv_intel_ver}
    module load craype/${craype_ver}
    module load intel/${intel_ver}
    module load cray-mpich/${cray_mpich_ver}
    module load hdf5-C/${hdf5_C_ver}
    module load netcdf-C/${netcdf_C_ver}
    module load esmf-C/${esmf_C_ver}
    module load ve/hafs/${ve_hafs_ver}

    #modules for wgrib2
    module load intel-oneapi/${intel_oneapi_ver}
    module load wgrib2/${wgrib2_ver}

    module load awscli/2.7.35

    export AWS=aws

    module list


fi

if [[ "${MACHINE_ID}" == "orion" ]]; then
    echo "loading modules for ORION "

    module purge 


    module load contrib/0.1
    module load noaa-gcc/12.2.0
    module load intel-oneapi-mpi/2021.7.1


    module load rdhpcs-python/3.13
    module load rdhpcs-conda/25.3.1

    module load esmf/8.4.2
    module load netcdf-c/4.9.2

    module load hdf5/1.14.3

    module load intel-oneapi-compilers/2022.2.1
    module load wgrib2/3.1.1

    module list
    conda activate xhycomenv
    export AWS=/home/kestons/.local/share/aws-cli/v2/current/bin/aws
fi

if [[ "${MACHINE_ID}" == "ursa" ]]; then
    module load aws

    module load rdhpcs-python/3.12
    module load rdhpcs-conda
    conda activate hycom-env

#    source /scratch3/NCEPDEV/climate/Keston.Smith/esmpyenv2/esmpyenv/bin/activate
    pip install netCDF4
    pip install tarfile
    pip install numpy

    module load intel-oneapi/2022.2.0.262
    module load wgrib2/2.0.8
#    module load wgrib2/3.1.3_wmo
    export AWS=aws

    module list
fi

