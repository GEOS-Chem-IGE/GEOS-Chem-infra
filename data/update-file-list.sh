#!/usr/bin/env bash

#===============================================================================
# Save the file tree of summer/geoschem/COMMON/ExtData/ to file-list.txt
#===============================================================================

# Help message
read -r -d '' help_message << EOM
Save the file tree of summer/geoschem/COMMON/ExtData/ to file-list.txt

Usage:
  update-file-list.sh [OPTION]

Options:
  -h, --help     Print this help message

Example:
  ./list-files.sh
EOM

function fail() {
  echo 'Run with --help for more information'
  exit 1
}

# Read options
options=$(getopt -o h -l help -- "$@")
if [ $? -ne 0 ]; then
  fail
fi
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

# Detect location of ExtData
ExtDataBase='summer/geoschem/COMMON/ExtData'
ExtDataPath="/$ExtDataBase"
if [[ ! -d "$ExtDataPath" ]]; then
  ExtDataPath="/mnt/$ExtDataBase"
fi
if [[ ! -d "$ExtDataPath" ]]; then
  echo "Could not find $ExtDataBase"
  exit 1
fi

LC_ALL=C.UTF-8 tree -aF --dirsfirst "$ExtDataPath" | \
  sed -E "1s/^\/(mnt\/)?//" > file-list.txt
