#!/usr/bin/env bash

#===============================================================================
# Submit this script to execute a dryrun:
#   oarsub -S ./2_dryrun.sh
#===============================================================================

#OAR -n 2_dryrun
#OAR --project pr-geoschem
#OAR -l /nodes=1/core=1,walltime=00:15:00
#OAR -t heterogeneous

# Activate the GCClassic environment
source gcclassic-gnu14.env

time -p ./gcclassic --dryrun
