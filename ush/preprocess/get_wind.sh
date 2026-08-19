#!/bin/bash

# This script retrieves rrfs and nbm winbds and exports as 
# netcdf files

source ./rwpsenv

echo "retrieving winds from rrfs and nbm for rwps wind"
(
    echo "sh nbm/make_nbm_wind.sh $PDY $cyc oc > nbm.oc.out"
    nbm/make_nbm_wind.sh $PDY $cyc oc > nbm.oc.out
    echo "retrieved winds from nbm oc domain"
    echo "Not retrieving other nbm domain winds"
)&

(
    echo "sh rrfs/MakeRRFSWind.sh $PDY $cyc na > rrfs.na.out"
    rrfs/MakeRRFSWind.sh $PDY $cyc na > rrfs.na.out
    echo "retrieved winds from rrfs na domain"
)&

(
    echo "sh rrfs/MakeRRFSWind.sh $PDY $cyc ak > rrfs.ak.out"
    rrfs/MakeRRFSWind.sh $PDY $cyc ak > rrfs.ak.out
    echo "retrieved winds from rrfs ak domain"
)&

(
    echo "sh rrfs/MakeRRFSWind.sh $PDY $cyc pr > rrfs.pr.out"
    rrfs/MakeRRFSWind.sh $PDY $cyc pr > rrfs.pr.out
    echo "retrieved winds from rrfs pr domain"
)&

(
    echo "sh rrfs/MakeRRFSWind.sh $PDY $cyc hi > rrfs.hi.out"
    rrfs/MakeRRFSWind.sh $PDY $cyc hi > rrfs.hi.out
    echo "retrieved winds from rrfs hi domain"
)&

(
    echo "sh rrfs/MakeRRFSWind.sh $PDY $cyc conus > rrfs.conus.out"
    rrfs/MakeRRFSWind.sh $PDY $cyc conus > rrfs.conus.out
    echo "retrieved winds from rrfs conus domain"
)&
wait

echo "finished retrieving winds from rrfs and nbm for rwps wind"

