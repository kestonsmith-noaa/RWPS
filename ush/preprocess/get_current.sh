#!/bin/bash

# This script retrieves global RTOFS and STOFS as netcdf files
cd $HOMErwps/ush/preprocess

if [$mixed_current_forcing]; then rtofs/get_rtofs.sh $PDY &; fi

stofs/get_stofs.sh $PDY $cyc current&

wait;
