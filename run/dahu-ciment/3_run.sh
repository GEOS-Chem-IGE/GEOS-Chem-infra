#!/usr/bin/env bash

#===============================================================================
# Submit this script to run the simulation:
#   oarsub -S ./3_run.sh
#
# Author: Ian Hough
# Date: 2025-01-09
#===============================================================================

#OAR -n 3_run
#OAR --project pr-geoschem
#OAR -l /nodes=1,walltime=08:00:00
#OAR -t heterogeneous

# Activate the GCClassic environment
source gcclassic-gnu14.env

time -p ./gcclassic
