#!/usr/bin/env bash

#===============================================================================
# Create a new run dir using an existing run dir as a template
#
# This script copies configuration files (e.g. geoschem_config.yml, HISTORY.rc),
# symlinks (e.g. gcclassic -> ../../build/gcclassic), and run scripts
# (e.g. run.sh) from an existing run dir to a new dir. It also creates required
# output subdirs (OutputDir/, Restarts/).
#===============================================================================

# Help message
read -r -d '' help_message << EOM

Usage:
  copy-rundir.sh OLD_DIR NEW_DIR

Options:
  -h, --help     Print this help message

Example:
  ./copy-rundir.sh 1-ocen/spinup 1-ocen/run-2018
EOM

# Read options
options=$(getopt -o h -l help -- "$@")
eval set -- "$options"
while true; do
  case "$1" in
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

if [ "$#" -lt 2 ]; then
  echo "$help_message"
  exit 1
fi

# Remove trailing slashes from dirs
OLD_DIR="${1%/}"
NEW_DIR="${2%/}"

if [ ! -d "$OLD_DIR" ]; then
  echo "No such dir: $OLD_DIR"
  exit 1
fi

if [ -e "$NEW_DIR" ]; then
  echo "Already exists: $NEW_DIR"
  exit 1
fi

mkdir "$NEW_DIR"

# Copy config files
TO_COPY=(
  "geoschem_config.yml"
  "HEMCO_Config.rc"
  "HEMCO_Config.rc.gmao_metfields"
  "HEMCO_Diagn.rc"
  "HISTORY.rc"
  "input.geos"  # for GEOS-Chem v13; equivalent of geoschem_config.yml
  "species_database.yml"
)
for FILE in "${TO_COPY[@]}"
do
  if [ -f "$OLD_DIR/$FILE" ]; then
    cp -nv "$OLD_DIR/$FILE" "$NEW_DIR"
  fi
done

# Copy run scripts
for FILE in "${OLD_DIR}"/*run.sh
do
  cp -nv "$FILE" "$NEW_DIR"
done

# Link compiled gcclassic and environment (using *relative* symlink)
for FILE in "$OLD_DIR"/gcclassic*
do
  ln -sv $(readlink "$FILE") "$NEW_DIR"
done

# Make Restarts dir
mkdir -pv "$NEW_DIR/Restarts"

# Make OutputDir
if [ -L "$OLD_DIR"/OutputDir ]; then
  # If OLD_DIR/OutputDir is a symlink, create a NEW_DIR/OutputDir as a symlink
  # to a dir named $NEW_DIR in the parent dir of OLD_DIR/OutputDir's target
  NEW_OUTDIR=$(readlink -f "$OLD_DIR"/OutputDir)
  NEW_OUTDIR=$(dirname "$NEW_OUTDIR")/$(basename "$NEW_DIR")
  mkdir -pv "$NEW_OUTDIR"
  ln -sv "$NEW_OUTDIR" "$NEW_DIR"/OutputDir
else
  # Otherwise, make OutputDir in NEW_DIR
  mkdir -pv "$NEW_DIR/OutputDir"
fi
