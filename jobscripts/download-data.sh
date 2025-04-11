#!/usr/bin/env bash

#===============================================================================
# Submit this script to execute a dryrun:
#   oarsub -S ./download-data.sh DRY_RUN_LOG [aws|http]
#===============================================================================

#OAR -n download-data
#OAR --project pr-geoschem
#OAR -l /nodes=1/core=1,walltime=00:30:00
#OAR -t heterogeneous

# Help message
read -r -d '' help_message << EOM

Usage:
  download-data.sh [OPTION]... [--] DRY_RUN_LOG

Options:
  --aws          Download data using AWS CLI (rather than wget)
  -h, --help     Print this help message

Example:
  ./download-data.sh OAR.dryrun.12345.stdout
EOM

function fail() {
  echo 'Run with --help for more information'
  exit 1
}

# Default options
method='http'

# Read options
options=$(getopt -o h -l aws,help -- "$@")
if [ $? -ne 0 ]; then
  fail
fi
eval set -- "$options"
while true; do
  case "$1" in
    --aws)
      method="aws"
      ;;
    -h|--help)
      echo "$help_message"
      exit 0
      ;;
    --)
      shift
      break
      ;;
    esac
    shift
done

# Check path to dryrun log
if [ -z "$1" ]; then
  echo "No dryrun log specified"
  fail
fi

DRY_RUN_LOG="$1"
if [ ! -f "$DRY_RUN_LOG" ]; then
  echo "Dryrun log not found: $DRY_RUN_LOG"
  fail
fi

# Load the GCClassic micromamba environment
source /home/PROJECTS/pr-geoschem/geos-chem-setup/init-mamba.sh
micromamba activate gcclassic-gnu14

# Download missing input data
python download_data.py "$DRY_RUN_LOG" geoschem+"$method"
