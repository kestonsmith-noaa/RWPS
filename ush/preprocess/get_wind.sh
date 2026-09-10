#!/bin/bash

# This script retrieves rrfs and nbm winbds and exports as 
# netcdf files

cd $HOMErwps/ush/preprocess

echo "retrieving winds from rrfs and nbm for rwps wind"
(
    nbm/make_nbm_wind.sh $PDY $cyc oc
    echo "retrieved winds from nbm oc domain"
    echo "Not retrieving other nbm domain winds"
)&

(
    rrfs/make_rrfs_wind.sh $PDY $cyc na
    echo "retrieved winds from rrfs na domain"
)&

(
    rrfs/make_rrfs_wind.sh $PDY $cyc ak
    echo "retrieved winds from rrfs ak domain"
)&

(
    rrfs/make_rrfs_wind.sh $PDY $cyc pr
    echo "retrieved winds from rrfs pr domain"
)&

(
    rrfs/make_rrfs_wind.sh $PDY $cyc hi
    echo "retrieved winds from rrfs hi domain"
)&

(
    rrfs/make_rrfs_wind.sh $PDY $cyc conus
    echo "retrieved winds from rrfs conus domain"
)&
wait

echo "finished retrieving winds from rrfs and nbm for rwps wind"

