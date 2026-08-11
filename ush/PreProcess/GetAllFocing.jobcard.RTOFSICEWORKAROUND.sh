#!/bin/sh

#date=$1
#cycl=$2
#mesh=$3

meshname="${mesh##*/}"
meshname="${meshname: 0: -4}"

jobcard="PreProcess.RWPS.$1.$2.jobcard"
outputfile="PreProcess.RWPS.$1.$2.out"

rm $jobcard

echo "#!/bin/sh" > $jobcard
echo "#PBS -q dev" >> $jobcard
echo "#PBS -l walltime=00:59:00" >> $jobcard
echo "#PBS -A GLWU-DEV" >> $jobcard
echo "#PBS -N RWPS.PreProc" >> $jobcard
echo "#PBS -j oe" >> $jobcard
echo "#PBS -l select=1:ncpus=4:mem=64GB" >> $jobcard
echo "#PBS -o RWPS.PreProc.out" >> $jobcard
echo " " >> $jobcard

curdir=$(pwd)
echo "cd $curdir" >> $jobcard


echo " " >> $jobcard

# Setup and load modules 
echo "module load PrgEnv-intel/8.1.0" >> $jobcard
echo "module load craype/2.7.8" >> $jobcard
echo "module load intel/19.1.3.304" >> $jobcard
echo "module load cfp/2.0.4" >> $jobcard
echo "module load prod_util/2.0.8" >> $jobcard
echo "module load prod_envir/2.0.5" >> $jobcard
echo " " >> $jobcard

echo "#date=$1" >> $jobcard
echo "#cycl=$2" >> $jobcard
echo "#mesh=$3" >> $jobcard
echo " " >> $jobcard

echo "meshname=$meshname"  >> $jobcard
echo " " >> $jobcard

echo "rm FetchWinds.out ProcWinds.out FetchCurrents.out ProcCurrents.out FetchWaterLevel.out ProcWaterLevel.out" >> $jobcard
echo " " >> $jobcard


# At present RTOFS ice files are missing time information (MT==0) so ProcessIce.sh will fail at the time interpolation step
#echo "(" >> $jobcard
#echo "    sh GetIce.sh $PDY $cyc > FetchIce.out" >> $jobcard
#echo "    sh ProcessIce.sh $PDY $cyc $mesh  > ProcIce.out" >> $jobcard
#echo ")&" >> $jobcard
#echo " " >> $jobcard




echo "(" >> $jobcard
echo "    sh GetWaterLevel.sh $PDY $cyc > FetchWaterLevel.out" >> $jobcard
echo "    sh ProcessWaterLevel.sh $PDY $cyc $mesh  > ProcWaterLevel.out" >> $jobcard
echo ")&" >> $jobcard
echo " " >> $jobcard

echo "(" >> $jobcard
echo "    sh GetWinds.sh $PDY $cyc  > FetchWinds.out" >> $jobcard
echo "    sh ProcessWinds.sh $PDY $cyc $mesh > ProcWinds.out" >> $jobcard
echo ")&" >> $jobcard
echo " " >> $jobcard

echo "(" >> $jobcard
echo "    sh GetCurrents.sh $PDY $cyc > FetchCurrents.out" >> $jobcard
echo "    sh ProcessCurrents.sh $PDY $cyc $mesh  > ProcCurrents.out" >> $jobcard

#ProcessIce Needs Time Variables from rtofs currents files
echo "    sh GetIce.sh $PDY $cyc > FetchIce.out" >> $jobcard
echo "    sh ProcessIce.sh $PDY $cyc $mesh  > ProcIce.out" >> $jobcard
echo ")&" >> $jobcard
echo " " >> $jobcard
echo " " >> $jobcard

echo "wait" >> $jobcard
echo " " >> $jobcard
echo "cp $meshname.$PDY.$cyc.cwl.stofs.nc $meshname.$PDY.$cyc.waterlevel.nc" >> $jobcard
echo "cp $meshname.$PDY.$cyc.vel.stofsxrtofs.nc $meshname.$PDY.$cyc.current.nc" >> $jobcard
echo "cp rwps_winds.$meshname.$PDY.$cyc/rwps.est.$meshname.$PDY.$cyc.wind10m.nc $meshname.$PDY.$cyc.wind.nc" >> $jobcard
echo "cp $meshname.$PDY.$cyc.ice.rtofsxnbm.nc $meshname.$PDY.$cyc.ice.nc" >> $jobcard
echo " " >> $jobcard

##Below is only needed because of missing rtofs ice time
## remove and move this to GetRTOFS.sh and GetRTOFSIce.sh
## echo "rm -rf tmp.rtofs*.$PDY" >> $jobcard

qsub $jobcard > $outputfile
