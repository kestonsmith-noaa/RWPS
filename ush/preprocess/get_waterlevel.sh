#!/bin/bash

## This script retrieves global STOFS water level as netcdf file

cd $RWPSroot/ush/preprocess
stofs/get_stofs.sh $PDY $cyc waterlevel 
