#!/bin/bash

cd $HOMErwps/ush/preprocess

meshname="${mesh##*/}"
meshname="${meshname: 0: -4}"

stofslev="$tmp/stofs.$PDY.$cyc/stofs_2d_glo.t${cyc}z.fields.cwl.nc"
stofs_wghts="$fix/InterpolationWeights.$meshname.stofs.nc"
stofs_dists="$fix/DistToBndy.$meshname.stofs.nc"
stofs_rwps="$frc/$meshname.$PDY.$cyc.cwl.waterlevel.nc"

rwps_waterlevel="$frc/$meshname.$PDY.$cyc.waterlevel.nc"

varnames="zeta"

## STOFS interpolation

if [ ! -f "$stofs_wghts" ]; then
    echo "missing stofs interpolation weights file: $stofs_wghts"
    echo "compute with script compute_unstr_to_rwps_interp_weights.sh"
    exit 1
fi
if [ ! -f "$stofs_dists" ]; then
    echo "missing stofs distance to boundary file: $stofs_dists"
    echo "compute with script compute_unstr_to_rwps_interp_weights.sh"
    exit 1
fi

python interpolate_with_weights.py $stofslev $stofs_wghts $rwps_waterlevel $varnames 0
python add_mesh_geom_to_file.py $rwps_waterlevel $mesh
python add_err_var_to_file.py $rwps_waterlevel $stofs_dists 1.

#psurgelev=psurge.t${PDY}${cyc}z.al142024_e${prcntl}_inc_dat.h102.conus_625m.nc

if [[$mixed_waterlevel_forcing -eq 1 ]]; then
    psurgelev=psurge.t${PDY}${cyc}z.*_e${prcntl}_inc_dat.h102.conus_625m.nc
    psurge_wghts="$fix/InterpolationWeights.$meshname.psurge.nc"
    psurge_dists="$fix/DistToBndy.$meshname.psurge.nc"
    psurge_rwps="$tmp/$meshname.$PDY.$cyc.psurge.waterlevel.nc"
    
    varname_psurge="SURGE_surface"
    varname_psurge="TCSRG50_surface"
    if [[$prcntl -eq 10]];then
        varname_psurge="SURGE_surface"
    else
        varname_psurge="TCSRG${prcntl}_surface"
    fi
    
    
    if [ -f "$psurgelev" ]; then
        echo "psurge file exists."
        UsePsurge=1
    else
        echo "Psurge file does not exist."
        
    fi
    


    rwps_waterlevel="$frc/$meshname.$PDY.$cyc.waterlevel.nc"

varnames="zeta"

python interpolate_with_weights.py $stofslev $stofs_wghts $stofs_rwps $varnames 0

#change psurge waterlevel name to "zeta"
python interpolate_with_weights.py $psurgelev $psurge_wghts $psurge_rwps $varname_psurge 4 $varnames

python add_mesh_geom_to_file.py $stofs_rwps $mesh
python add_mesh_geom_to_file.py $psurge_rwps $mesh

python interp_time.py $stofs_rwps $psurge_rwps $stofs_rwps_ti $varnames

python add_err_var_to_file.py $stofs_rwps_ti $stofs_dists 1.

python add_err_var_to_file.py $psurge_rwps $psurge_dists .05

python bayes_forecast_update.py $stofs_rwps_ti $psurge_rwps $rwps_waterlevel $varnames

