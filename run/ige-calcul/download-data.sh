#!/bin/bash

#SBATCH -c 1
#SBATCH -N 1
#SBATCH --time 02:00:00
#SBATCH --mem=15000
#SBATCH --account=chianti
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END

###############################################################################
### Sample GEOS-Chem run script for SLURM
### You can increase the number of cores with -c and memory with --mem,
### particularly if you are running at very fine resolution (e.g. nested-grid)
###############################################################################

# Set the proper # of threads for OpenMP
# SLURM_CPUS_PER_TASK ensures this matches the number you set with -c above
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

# Set the stacksize memory to the highest possible limit
ulimit -s unlimited
export OMP_STACKSIZE=500m

# Run GEOS-Chem.  The "time" command will return CPU and wall times.
# Stdout and stderr will be directed to the "GC.log" log file
# (you can change the log file name below if you wish)
#srun -c $OMP_NUM_THREADS time -p ./gcclassic > GC.log 2>&1
./download_data.py log.dryrun geoschem+http
# Exit normally
exit 0
