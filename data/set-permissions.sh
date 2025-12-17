#!/usr/bin/env bash

#===============================================================================
# Set permissions on files and directories in summer/geoschem/COMMON/ExtData/
#===============================================================================

# Help message
read -r -d '' help_message << EOM
Set permissions on all files and directories in summer/geoschem/COMMON/ExtData

Usage:
  set-permissions.sh [OPTION]

Options:
  -h, --help     Print this help message
  -v, --verbose  Report all changes made

Example:
  ./set-permissions.sh
EOM

function fail() {
  echo 'Run with --help for more information'
  exit 1
}

# Default options
verbose=""

# Read options
options=$(getopt -o hv -l help,verbose -- "$@")
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
    -v|--verbose)
      verbose="-c"
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

echo "Setting directory permissions to 2770 in $ExtDataPath"
find "$ExtDataPath" -type d -exec chmod $verbose 2770 {} +
echo

echo "Setting file permissions to 0640 in $ExtDataPath"
find "$ExtDataPath" -type f ! -path "$ExtDataPath/README.md" \
  -exec chmod $verbose 0640 {} +
