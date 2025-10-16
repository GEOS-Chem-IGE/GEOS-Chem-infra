#!/usr/bin/env bash

#===============================================================================
# Compare run configuration files in two run dirs
#
# Author: Ian Hough
# Date: 2025-07-29
#===============================================================================

# Help message
read -r -d '' help_message << EOM

Usage:
  compare-rundirs.sh DIR1 DIR2

Options:
  -h, --help     Print this help message

Example:
  ./compare-rundirs.sh 2018-01-01_2019-01-01 2019-01-01_2020-01-01
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

# Remove trailing slash from dirs
DIR1="${1%/}"
DIR2="${2%/}"

if [ ! -d "$DIR1" ]; then
  echo "No such dir: $DIR1"
  exit 1
fi

if [ ! -d "$DIR2" ]; then
  echo "No such dir: $DIR2"
  exit 1
fi

TO_COMPARE=(
  "geoschem_config.yml"
  "HEMCO_Config.rc"
  "HEMCO_Diagn.rc"
  "HISTORY.rc"
  "input.geos"  # for GEOS-Chem v13; equivalent of geoschem_config.yml
  "species_database.yml"
  "dryrun.sh"
  "run.sh"
)
for FILE in "${TO_COMPARE[@]}"
do
  if [ -f "$DIR1/$FILE" ] && [ -f "$DIR2/$FILE" ]; then
    # Use pager for all files; otherwise files with short diff may be hidden
    echo "=============="
    echo "Diff of $FILE:"
    echo "=============="
    git -c core.pager='less -+F' diff --color --color-moved --no-ext-diff --no-index\
      "$DIR1/$FILE" "$DIR2/$FILE"
  elif [ -f "$DIR1/$FILE" ] || [ -f "$DIR2/$FILE" ]; then
    if [ ! -f "$DIR1/$FILE" ]; then
      echo "No such file: $DIR1/$FILE"
    fi
    if [ -f "$DIR2/$FILE" ]; then
      echo "No such file: $DIR2/$FILE"
    fi
  fi
done
