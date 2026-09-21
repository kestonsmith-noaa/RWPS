#!/bin/bash

# This script retrieves rrfs and nbm winbds and exports as 
# netcdf files
# PDY=YYYYMMDD, 
# cyc=00,06... two digit cycle number

cd ${HOMErwps}/ush/preprocess

if [ -v InputSource ]; then
    echo "InputSource = ${InputSource}"
else
    InputSource = "lfs"
fi


echo "retrieving winds from rrfs and nbm for rwps wind"
if [[ "${InputSource}" == *"AWS"* ]]; then
    (
        nbm/make_nbm_wind.sh ${PDY} ${cyc} oc
        echo "retrieved winds from nbm oc domain"
    )&
    (
        rrfs/make_rrfs_wind.sh ${PDY} ${cyc} na
        echo "retrieved winds from rrfs na domain"
    )&
    (
        rrfs/make_rrfs_wind.sh ${PDY} ${cyc} ak
        echo "retrieved winds from rrfs ak domain"
    )&
    (
        rrfs/make_rrfs_wind.sh ${PDY} ${cyc} pr
        echo "retrieved winds from rrfs pr domain"
    )&
    (
         rrfs/make_rrfs_wind.sh ${PDY} ${cyc} hi
        echo "retrieved winds from rrfs hi domain"
    )&
    (
        rrfs/make_rrfs_wind.sh ${PDY} ${cyc} conus
        echo "retrieved winds from rrfs conus domain"
   )&
else
    (
        nbm/make_nbm_wind_aws.sh ${PDY} ${cyc} oc
        echo "retrieved winds from nbm oc domain"
    )&
    (
        rrfs/make_rrfs_wind_aws.sh ${PDY} ${cyc} na
        echo "retrieved winds from rrfs na domain"
    )&
    (
        rrfs/make_rrfs_wind_aws.sh ${PDY} ${cyc} ak
        echo "retrieved winds from rrfs ak domain"
    )&
    (
        rrfs/make_rrfs_wind_aws.sh ${PDY} ${cyc} pr
        echo "retrieved winds from rrfs pr domain"
    )&
    (
         rrfs/make_rrfs_wind_aws.sh ${PDY} ${cyc} hi
        echo "retrieved winds from rrfs hi domain"
    )&
    (
        rrfs/make_rrfs_wind_aws.sh ${PDY} ${cyc} conus
        echo "retrieved winds from rrfs conus domain"
   )&
fi
wait

echo "finished retrieving winds from rrfs and nbm for rwps wind"

