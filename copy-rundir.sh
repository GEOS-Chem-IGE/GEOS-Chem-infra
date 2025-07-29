#!/usr/bin/env bash

#===============================================================================
# Create a new run dir using an existing run dir as a template
#
# This script copies configuration files (e.g. geoschem_config.yml, HISTORY.rc),
# symlinks (e.g. gcclassic -> ../../build-gcclassic/gcclassic), and run scripts
# (e.g. run.sh) from an existing run dir to a new dir. It also creates required
# output subdirs (OutputDir/, Restarts/), possibly as symlinks.
#===============================================================================

# Help message
read -r -d '' help_message << EOM
Create a new simulation run dir using an existing run dir as a template.

Usage:
  copy-rundir.sh [OPTION] [--] OLD_DIR NEW_DIR

Options:
  -h, --help        Print this help message
  -o, --outdir DIR  Create OutputDir/ and Restarts/ in DIR and symlink from
                    NEW_DIR. Useful for saving simulation output files on a
                    different volume from NEW_DIR.

Notes:
  * If OLD_DIR contains symlinks to gcclassic or an environment activation
    script, the targets will be linked from NEW_DIR using *relative* symlinks.
  * Any symlinks to OutputDir/ and Restarts/ will be *absolute*.

Example:
  ./copy-rundir.sh 1-ocen/spinup 1-ocen/run-2018
EOM

# Read options
options=$(getopt -o ho: -l help,outdir: -- "$@")
eval set -- "$options"
while true; do
  case "$1" in
    -h | --help)
      echo "$help_message"
      exit 0
      ;;
    -o | --outdir)
      outdir="$2"
      shift
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

# Create NEW_DIR
if [ ! -d "$OLD_DIR" ]; then
  echo "No such dir: $OLD_DIR"
  exit 1
fi
if [ -e "$NEW_DIR" ]; then
  echo "Already exists: $NEW_DIR"
  exit 1
fi
echo "Creating $NEW_DIR"
mkdir -p "$NEW_DIR"

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
echo
echo "Copying config files"
for FILE in "${TO_COPY[@]}"
do
  if [ -f "$OLD_DIR/$FILE" ]; then
    cp -nv "$OLD_DIR/$FILE" "$NEW_DIR"
  fi
done

# Copy run scripts
echo
echo "Copying run scripts"
for FILE in "${OLD_DIR}"/*run.sh
do
  cp -nv "$FILE" "$NEW_DIR"
done

# Link compiled gcclassic and environment script (using *relative* symlink)
echo
echo "Linking gcclassic and environment activation script"
for FILE in "$OLD_DIR"/gcclassic*
do
  ln -sv $(readlink "$FILE") "$NEW_DIR"
done

# Create OutputDir/ and Restarts/ as subdirs or symlinks
echo
echo "Creating OutputDir/ and Restarts/"
function make_outdir {
  local dirname="$1"
  if [ -z "$outdir" ]; then
    local target="$NEW_DIR/$dirname"
    mkdir -p "$target"
    echo "'$target'"
  else
    local target="$outdir/$dirname"
    if [ -e "$target" ]; then
      echo "Target $target already exists"
      exit 1
    fi
    mkdir -p "$target"
    ln -sv "$target" "$NEW_DIR/$dirname"
  fi
}
make_outdir OutputDir
make_outdir Restarts
