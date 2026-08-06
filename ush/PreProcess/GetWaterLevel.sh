#!/bin/bash

## This script retrieves stofs water level as netcdf file

#date=$1
#cycl=$2
curdir=$(pwd)
echo $curdir
source ./rwpsenv

stofs/GetSTOFS.sh $date $cycl waterlevel 
