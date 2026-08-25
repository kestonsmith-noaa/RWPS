Scripts to create interpolation weights and distance to boundary files for interpolating forcing to RWPS mesh.
To run:

cd RWPS/dev/compute_interpolation_weights/sorc

dev/compute_interpolation_weights/sorc/compute_interpolation_weights.sh
compute_interpolation_weights.sh oc_1500m_30km

to generate interpolation files for mesh rwps.oc_1500m_30km.msh.  Files will be writen to directory:
RWPS/fix/

Interpolation weights are created for:

nbm oc domain
rrfs hi domain (used for wins)
rrfs pr domain (used for wins)
rrfs ak domain (used for wins)
rrfs na domain (used for wins)
rrfs conus domain (used for wind)
nbm ak domain (used for ice concentration)
rtofs glo domain (used for currents without extrapolation)
rtofs glo domain (used for ice with extrapolation)
stofs domain (used for waterlevel and currents)

Currently only setup to work on wcoss2.
