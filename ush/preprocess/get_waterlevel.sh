#!/bin/bash

## This script retrieves global STOFS water level as netcdf file

curdir=$(pwd)
echo $curdir
source ./rwpsenv

stofs/get_stofs.sh $PDY $cyc waterlevel 
