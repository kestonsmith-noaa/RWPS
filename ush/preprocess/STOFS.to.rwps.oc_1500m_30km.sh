#!/bin/bash 
#SBATCH --job-name=STOFS_interp_masterscript 
 
module purge 
module use /scratch4/NCEPDEV/marine/Ali.Salimi/Hera_Data/HR4-OPT/FromJessica/Keston/ICunstructuredRuns15km-implicit-450s/global-workflow/sorc/ufs_model.fd/modulefiles 
module load ufs_ursa.intel 
module load py-scipy/1.14.1 
module load py-netcdf4/1.7.1.post2 
pip list 
# calculate interpolation weights in parallel geographically 
python InterpolateSTOFS.py /lfs/h2/emc/couple/noscrub/keston.smith/SampleInput/stofs.v3/stofs.20260819.00/stofs_2d_glo.t00z.fields.cwl.nc /lfs/h2/emc/couple/noscrub/keston.smith/TestRWPS/RWPS/ush/preprocess/../../fix/rwps.oc_1500m_30km.msh /lfs/h2/emc/couple/noscrub/keston.smith/SampleInput/stofs.v3/stofs.20260819.00/stofs_2d_glo.t00z.fields.cwl.rwps.oc_1500m_30km.nc zeta 2
python InterpolateSTOFS.py /lfs/h2/emc/couple/noscrub/keston.smith/SampleInput/stofs.v3/stofs.20260819.00/stofs_2d_glo.t00z.fields.cwl.vel.nc /lfs/h2/emc/couple/noscrub/keston.smith/TestRWPS/RWPS/ush/preprocess/../../fix/rwps.oc_1500m_30km.msh /lfs/h2/emc/couple/noscrub/keston.smith/SampleInput/stofs.v3/stofs.20260819.00/stofs_2d_glo.t00z.fields.cwl.vel.rwps.oc_1500m_30km.nc u-vel:v-vel 2
