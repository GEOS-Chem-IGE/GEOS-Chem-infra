#!/usr/bin/env bash

#===============================================================================
# Submit this script to run the simulation:
#   oarsub -S ./3_run.sh
#===============================================================================

#OAR -n 3_run
#OAR --project pr-geoschem
#OAR -l /nodes=1,walltime=08:00:00
#OAR -t heterogeneous

# Go to the run dir and activate the environment
cd "$(realpath "$(dirname -- "${BASH_SOURCE[0]}")")"
source ./gcclassic-gnu14.env

time -p ./gcclassic
