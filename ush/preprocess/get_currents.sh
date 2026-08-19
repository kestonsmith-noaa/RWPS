#!/bin/bash

# This script retrieves global RTOFS and STOFS as netcdf files

#source ./rwpsenv
rtofs/GetRTOFS.sh $PDY &
stofs/get_stofs.sh $PDY $cyc current&
wait;
