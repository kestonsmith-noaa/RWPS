#!/bin/bash

# This script retrieves ice forecasts for global RTOFS and Alaska NBM as netcdf files

source ./rwpsenv
sh rtofs/GetRTOFSIce.sh $PDY $cyc &
sh nbm/GetNBMIce.sh $PDY $cyc &
wait;
