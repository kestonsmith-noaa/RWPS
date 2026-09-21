#!/bin/bash

#script for retrieving stofs current and/or water level
#Comand line arguments are :
# arg 1 = YYYYMMDD
# arg 2 = cc, 2 digit cyle
# arg 3 = variable to retrieve, (current or waterlevel)
#
# Requires environmental variables:
# COMINlocal = work directory to write output files to
# COMINstofs = directory path to stofs forecasts
#
# call as:
# $ sh get_rtofs_ice.sh



if [ "$#" -lt 3 ]; then
    echo "No arguments field argument."
    echo "Retrieving both stofs currents and stofs water level."
    fields="current, waterlevel"
else
    fields=${3}
fi

outdir=${COMINlocal}/stofs.${1}.${2}

mkdir -p ${outdir}

if [[ "${fields}" == *"current"* ]]; then
    echo retrieving stofs current for ${1} {cyc}le ${2}
    cp ${COMINstofs}/stofs_2d_glo.t"${2}"z.fields.cwl.vel.nc  ${outdir}/
fi

if [[ "${fields}" == *"level"* ]]; then
    echo retrieving stofs water level for ${1} {cyc}le ${2}
    cp ${COMINstofs}/stofs_2d_glo.t"${2}"z.fields.cwl.nc  ${outdir}/
fi

