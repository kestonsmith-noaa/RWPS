#!/bin/bash

cd $HOMErwps/ush/preprocess

winddir="$tmp/wind.$PDY.$cyc"
windvars="UGRD_10maboveground:VGRD_10maboveground"

# extract mesh name from file path
meshname="${mesh##*/}"
# remove .msh suffix from mesh name
meshname="${meshname: 0: -4}"

# incorporate meshname date and cycle into output directory name to avoid
# applying winds to wrong mesh

outdir="$tmp/rwps_wind.$meshname.$PDY.$cyc"

rwps_wind="$frc/$meshname.$PDY.$cyc.wind.nc"

echo "outputing files to: $outdir"

nbm_oc="$winddir/nbm.$PDY.$cyc.wind10m.oc.nc"
nbm_oc_uv="$winddir/nbm.$PDY.$cyc.wind10m.oc.uv.nc"

rrfs_pr="$winddir/rrfs.$PDY.$cyc.wind10m.pr.nc"
rrfs_hi="$winddir/rrfs.$PDY.$cyc.wind10m.hi.nc"
rrfs_na="$winddir/rrfs.$PDY.$cyc.wind10m.na.nc"
rrfs_ak="$winddir/rrfs.$PDY.$cyc.wind10m.ak.nc"
rrfs_conus="$winddir/rrfs.$PDY.$cyc.wind10m.conus.nc"

rwps_oc="$outdir/$meshname.$PDY.$cyc.wind10m.nbm.oc.nc"
rwps_oc_ti="$outdir/$meshname.$PDY.$cyc.wind10m.nbm.oc.ti.nc"
rwps_pr="$outdir/$meshname.$PDY.$cyc.wind10m.rrfs.pr.nc"
rwps_hi="$outdir/$meshname.$PDY.$cyc.wind10m.rrfs.hi.nc"
rwps_na="$outdir/$meshname.$PDY.$cyc.wind10m.rrfs.na.nc"
rwps_ak="$outdir/$meshname.$PDY.$cyc.wind10m.rrfs.ak.nc"
rwps_conus="$outdir/$meshname.$PDY.$cyc.wind10m.rrfs.conus.nc"

mkdir $outdir

##LocalFS  = [ rwps_pr, rwps_hi, rwps_ak, rwps_conus, rwps_na] # file names
##VarFS    = [ 4.     , 4.    , 9.      , 16.       , 25.    ] # (m m /s /s)
##LambdaFS = [ 150.   , 200.  , 500.    , 1000.     , 1500.  ] # (km)
nbm_oc_wghts="$fix/InterpolationWeights.$meshname.nbm.oc.nc"
rrfs_hi_wghts="$fix/InterpolationWeights.$meshname.rrfs.hi.nc"
rrfs_pr_wghts="$fix/InterpolationWeights.$meshname.rrfs.pr.nc"
rrfs_ak_wghts="$fix/InterpolationWeights.$meshname.rrfs.ak.nc"
rrfs_na_wghts="$fix/InterpolationWeights.$meshname.rrfs.na.nc"
rrfs_conus_wghts="$fix/InterpolationWeights.$meshname.rrfs.conus.nc"

nbm_oc_dist="$fix/DistToBndy.$meshname.nbm.oc.nc"
rrfs_hi_dist="$fix/DistToBndy.$meshname.rrfs.hi.nc"
rrfs_pr_dist="$fix/DistToBndy.$meshname.rrfs.pr.nc"
rrfs_ak_dist="$fix/DistToBndy.$meshname.rrfs.ak.nc"
rrfs_na_dist="$fix/DistToBndy.$meshname.rrfs.na.nc"
rrfs_conus_dist="$fix/DistToBndy.$meshname.rrfs.conus.nc"

(
    #Convert NBM speed and direction to u,v
    python spd_dir_to_uv_nbm.py $nbm_oc $nbm_oc_uv
    # If the interpolation weights do not already exist for the domains create them
    # also creates distance to boundary used in prescribed error covariance specification
    [ ! -f "$nbm_oc_wghts" ] && python compute_gridded_to_rwps_interp_weights.py $nbm_oc_uv $mesh 1
    python interpolate_with_weights.py $nbm_oc_uv $nbm_oc_wghts $rwps_oc $windvars 3 > $tmp/intrp.rrfs.oc.out
    python add_mesh_geom_to_file.py $rwps_oc $mesh
) &

if [[ $mixed_wind_forcing -eq 1 ]]; then
    (
        python interpolate_with_weights.py $rrfs_hi $rrfs_hi_wghts $rwps_hi $windvars -1 > $tmp/intrp.rrfs.hi.out
# add mesh geometry into interpolated file
        python add_mesh_geom_to_file.py $rwps_hi $mesh
# Add error covariance field to files with interpolated fields for bayesian update
# Based on distance to boundary of input field and commant line parameters InternalVariance:BoundaryVariance:LengthScale(km) 
        python add_err_var_to_file.py $rwps_hi $rrfs_hi_dist 4.:40.:200.
    ) &

    (
        python interpolate_with_weights.py $rrfs_pr $rrfs_pr_wghts $rwps_pr $windvars -1 > $tmp/intrp.rrfs.pr.out
        python add_mesh_geom_to_file.py $rwps_pr $mesh
        python add_err_var_to_file.py $rwps_pr $rrfs_pr_dist 4.:40.:150.
    ) &

    (
       python interpolate_with_weights.py $rrfs_ak $rrfs_ak_wghts $rwps_ak $windvars -1 > $tmp/intrp.rrfs.ak.out
       python add_mesh_geom_to_file.py $rwps_ak $mesh
       python add_err_var_to_file.py $rwps_ak $rrfs_ak_dist 9.:90.:500.
    ) &

   (
        python interpolate_with_weights.py $rrfs_conus $rrfs_conus_wghts $rwps_conus $windvars -1  > $tmp/intrp.rrfs.conus.out
        python add_mesh_geom_to_file.py $rwps_conus $mesh
        python add_err_var_to_file.py $rwps_conus $rrfs_conus_dist 16.:160.:1000.
    ) &

    (
        python interpolate_with_weights.py $rrfs_na $rrfs_na_wghts $rwps_na $windvars -1  > $tmp/intrp.rrfs.na.out
        python add_mesh_geom_to_file.py $rwps_na $mesh
        python add_err_var_to_file.py $rwps_na $rrfs_na_dist 50.:500.:1500.
    ) &
fi
wait;

if [[ $mixed_wind_forcing -eq 1 ]]; then
# interpolate NBM in time to times within the NBM forecast covered by the RRFS forecast
    python interp_time.py $rwps_oc $rwps_pr $rwps_oc_ti $windvars
# add mesh geometry into file
    python add_mesh_geom_to_file.py $rwps_oc_ti $mesh
# add prescribed error covariance for nbm oc domain (assumed constant 100. (m/s)^2 )
    python add_err_var_to_file.py $rwps_oc_ti $nbm_oc_dist 100.

    echo "updating wind background forecast with rrfs winds"

    python bayes_forecast_update.py $rwps_oc_ti $rwps_hi $tmp/windtmp1.nc $windvars
    python bayes_forecast_update.py $tmp/windtmp1.nc $rwps_pr $tmp/windtmp2.nc $windvars
    python bayes_forecast_update.py $tmp/windtmp2.nc $rwps_ak $tmp/windtmp3.nc $windvars
    python bayes_forecast_update.py $tmp/windtmp3.nc $rwps_conus $tmp/windtmp4.nc $windvars
    python bayes_forecast_update.py $tmp/windtmp4.nc $rwps_na $rwps_wind $windvars
else
    echo "just using nbm oc wind. mixed wind forcing = $mixed_wind_forcing"
    python add_err_var_to_file.py $rwps_oc $nbm_oc_dist 1.
    cp $rwps_oc $rwps_wind
fi
