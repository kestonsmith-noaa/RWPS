#!/bin/bash

# This script retrieves ice forecasts for global RTOFS and Alaska NBM as netcdf files

source ./rwpsenv
rtofs/GetRTOFSIce.sh $PDY $cyc &
nbm/GetNBMIce.sh $PDY $cyc &
wait;
