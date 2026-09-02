!/bin/bash
# --------------------------------------------------------------------------- #
#                                                                             #
# Copy external fix files that are too large to store in repository           #
#                                                                             #
# Last Changed : 08-15-2025                                        Aug 2025   #
# --------------------------------------------------------------------------- #

echo 'setting paths...'

##export RWPSroot="$(pwd)/../../../"
export RWPSroot=$(cd "$(dirname "$(readlink -f -n "${BASH_SOURCE[0]}")")" && git rev-parse --show-toplevel)


export fix="$RWPSroot/fix"
export prep="$RWPSroot/PrepInputs"
export tmp="$prep/tmpfiles"
export frc="$prep/forcing"
export outdir=$prep

echo $RWPSroot
echo $fix $prep $tmp $outdir
mkdir -p $prep
mkdir -p $tmp
mkdir -p $frc


echo $RWPSroot
echo $fix $prep $tmp $outdir


#machine dependend path to rtofs, nbm, rrfs, and stofs forecast files
export COMINrtofs="/lfs/h1/ops/prod/com/rtofs/v2.5/rtofs.$PDY/"
export COMINnbm="/lfs/h3/mdl/ptmp/mdl.nbm/blend/v5.2/blend.$PDY/$cyc/grib2"
export COMINrrfs="/lfs/h1/ops/prod/com/rrfs/v1.0/rrfs.$PDY/$cyc"
export COMINstofs="/lfs/h1/ops/prod/com/stofs/v3.1/stofs_2d_glo.$PDY"

export COMINlocal=$tmp

#machine dependend path to RWPS fix files
export RWPSfix=/lfs/h2/emc/couple/noscrub/keston.smith/RWPS

meshID_list=(
    "oc_20km_300km"
    "oc_10km_200km"
    "oc_5km_100km"
    "oc_1500m_30km"
    "oc_500m_10km"
)

# Loop through the array (quotes around "${strings_list[@]}" are mandatory)
for meshIDloop in "${meshID_list[@]}"; do
    export meshID=$meshIDloop
    echo "Computing interpoation weights for: $meshID"
    cp -p $RWPSfix/fix/$meshID/20260722/rwps.$meshID.msh $RWPSroot/fix/
    export mesh="$RWPSroot/fix/rwps.$meshID.msh"
    meshname="${mesh##*/}"
    export meshname="${meshname: 0: -4}"
    qsub -V -W block=true $RWPSroot/dev/compute_interpolation_weights/ecf/compute_interpolation_weights.ecf
done
