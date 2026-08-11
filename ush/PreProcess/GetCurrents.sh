#!/bin/bash

# This script retrieves global RTOFS and STOFS as netcdf files

source ./rwpsenv
rtofs/GetRTOFS.sh $PDY &
stofs/GetSTOFS.sh $PDY $cyc current&
wait;
