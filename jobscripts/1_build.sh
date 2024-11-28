#!/usr/bin/env bash

#===============================================================================
# Submit this script to build GEOS-Chem:
#   oarsub -S ./1_build.sh
#===============================================================================

#OAR -n 1_build
#OAR --project pr-geoschem
#OAR -l /nodes=1/core=1,walltime=00:10:00
#OAR -t heterogeneous

# Exit on any error
set -e

# Go to the run dir and activate the environment
cd "$(realpath "$(dirname -- "${BASH_SOURCE[0]}")")"
source ./gcclassic-gnu14.env

set -x
cd build
time -p cmake ../CodeDir -DRUNDIR=..
time -p make -j
time -p make install
set +x
