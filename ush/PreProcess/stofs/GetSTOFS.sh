#!/bin/bash

#script for retrieving stofs current and/or water level

if [ "$#" -lt 3 ]; then
    echo "No arguments field argument."
    echo "Retrieving both stofs currents and stofs water level."
    fields="currents,waterlevel"
else
    fields=$3
fi

mkdir stofs.$PDY.$cyc

if [[ "$fields" == *"current"* ]]; then
    echo retrieving stofs current for $PDY cycle $cyc
    cp /lfs/h1/ops/prod/com/stofs/v2.1/stofs_2d_glo.$PDY/stofs_2d_glo.t"$cyc"z.fields.cwl.vel.nc  stofs.$PDY.$cyc/
fi

if [[ "$fields" == *"level"* ]]; then
    echo retrieving stofs water level for $PDY cycle $cyc
    cp /lfs/h1/ops/prod/com/stofs/v2.1/stofs_2d_glo.$PDY/stofs_2d_glo.t"$cyc"z.fields.cwl.nc  stofs.$PDY.$cyc/
fi

