#!/bin/bash

#script for retrieving stofs current and/or water level from AWS

if [ "$#" -lt 3 ]; then
    echo "No arguments field argument."
    echo "Retrieving both stofs currents and stofs water level."
    fields="currents,waterlevel"
else
    fields=$3
fi

#source rwpsenv
#mkdir stofs.$PDY.$cyc

outdir=$tmp/stofs.$PDY.$cyc

mkdir -p $outdir

if [[ "$fields" == *"current"* ]]; then
    echo retrieving stofs current for $PDY cycle $cyc
    #cp $COMINstofs/stofs_2d_glo.t"$cyc"z.fields.cwl.vel.nc  $outdir/
    #aws s3 ls --no-sign-request s3://noaa-gestofs-pds/stofs_2d_glo.20260127/ | g nc | g 00z
    aws s3 cp --no-sign-request s3://noaa-gestofs-pds/stofs_2d_glo.$PDY/stofs_2d_glo.t${cyc}z.fields.cwl.vel.nc $outdir/

#    cp /lfs/h1/ops/prod/com/stofs/v2.1/stofs_2d_glo.$PDY/stofs_2d_glo.t"$cyc"z.fields.cwl.vel.nc  stofs.$PDY.$cyc/
fi

if [[ "$fields" == *"level"* ]]; then
    echo retrieving stofs water level for $PDY cycle $cyc
    #cp $COMINstofs/stofs_2d_glo.t"$cyc"z.fields.cwl.nc  $outdir/
    aws s3 cp --no-sign-request s3://noaa-gestofs-pds/stofs_2d_glo.$PDY/stofs_2d_glo.t${cyc}z.fields.cwl.nc $outdir/
#    cp /lfs/h1/ops/prod/com/stofs/v2.1/stofs_2d_glo.$PDY/stofs_2d_glo.t"$cyc"z.fields.cwl.nc  stofs.$PDY.$cyc/
fi

