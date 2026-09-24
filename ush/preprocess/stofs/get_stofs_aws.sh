#!/bin/bash

#script for retrieving stofs current and/or water level from AWS

PDY=${1}
cyc=${2}

if [ "$#" -lt 3 ]; then
    echo "No arguments field argument."
    echo "Retrieving both stofs currents and stofs water level."
    fields="currents,waterlevel"
else
    fields=${3}
fi

if [[ ! -v tmp ]]; then
    tmp="./"
    echo "tmp set to current directory. Should have been set elsewhere"
else
    echo "tmp set to $tmp"
fi

outdir=${tmp}/stofs.${PDY}.${cyc}

mkdir -p ${outdir}

if [[ "$fields" == *"current"* ]]; then
    echo retrieving stofs current for ${PDY} cycle ${cyc}
    aws s3 cp --no-sign-request s3://noaa-gestofs-pds/stofs_2d_glo.${PDY}/stofs_2d_glo.t${cyc}z.fields.cwl.vel.nc ${outdir}/
fi

if [[ "$fields" == *"level"* ]]; then
    echo retrieving stofs water level for ${PDY} cycle ${cyc}
    aws s3 cp --no-sign-request s3://noaa-gestofs-pds/stofs_2d_glo.${PDY}/stofs_2d_glo.t${cyc}z.fields.cwl.nc ${outdir}/
fi

