#!/bin/bash

# This script retrieves rtofs and stofs as netcdf files


date=$1
cycl=$2
source ./rwpsenv
rtofs/GetRTOFS.sh $date &
stofs/GetSTOFS.sh $date $cycl current&
wait;
