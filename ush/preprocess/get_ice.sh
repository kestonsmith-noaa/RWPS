#!/bin/bash

# This script retrieves ice forecasts for global RTOFS and Alaska NBM as netcdf files

source ./rwpsenv
sh rtofs/get_rtofs_ice.sh $PDY $cyc &
sh nbm/get_nbm_ice.sh $PDY $cyc &
wait;
