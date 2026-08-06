#!/bin/bash

# This script retrieves rrfs and nbm winbds and exports as 
# netcdf files
#date=$1
#cycl=$2

source ./rwpsenv

echo "retrieving winds from rrfs and nbm for rwps wind"
(
    echo "sh nbm/MakeNBMWind.sh $date $cycl oc > nbm.oc.out"
    nbm/MakeNBMWind.sh $date $cycl oc > nbm.oc.out
    echo "retrieved winds from nbm oc domain"
    echo "Not retrieving other nbm domain winds"
)&

(
    echo "sh rrfs/MakeRRFSWind.sh $date $cycl na > rrfs.na.out"
    rrfs/MakeRRFSWind.sh $date $cycl na > rrfs.na.out
    echo "retrieved winds from rrfs na domain"
)&

(
    echo "sh rrfs/MakeRRFSWind.sh $date $cycl ak > rrfs.ak.out"
    rrfs/MakeRRFSWind.sh $date $cycl ak > rrfs.ak.out
    echo "retrieved winds from rrfs ak domain"
)&

(
    echo "sh rrfs/MakeRRFSWind.sh $date $cycl pr > rrfs.pr.out"
    rrfs/MakeRRFSWind.sh $date $cycl pr > rrfs.pr.out
    echo "retrieved winds from rrfs pr domain"
)&

(
    echo "sh rrfs/MakeRRFSWind.sh $date $cycl hi > rrfs.hi.out"
    rrfs/MakeRRFSWind.sh $date $cycl hi > rrfs.hi.out
    echo "retrieved winds from rrfs hi domain"
)&

(
    echo "sh rrfs/MakeRRFSWind.sh $date $cycl conus > rrfs.conus.out"
    rrfs/MakeRRFSWind.sh $date $cycl conus > rrfs.conus.out
    echo "retrieved winds from rrfs conus domain"
)&
wait

echo "finished retrieving winds from rrfs and nbm for rwps wind"

