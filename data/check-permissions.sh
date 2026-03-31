#!/usr/bin/env bash

#==============================================================
# Check permissions and group in summer/geoschem/COMMON/ExtData
#==============================================================

# Desired permissions
GROUP="pr-geoschem"
DIR_PERM="u=rwx,g=rwxs,o=rx"
FILE_PERM="u=rw,g=r,o=r"

# Help message
read -r -d '' HELP_MESSAGE << EOM
Check permissions and group of all files in summer/geoschem/COMMON/ExtData

Usage:
  check-permissions.sh [OPTION]

Options:
  -h, --help     Print this help message
  -v, --verbose  Print the matching files and directories

Example:
  ./check-permissions.sh
EOM

function fail() {
  echo 'Run with --help for more information'
  exit 1
}

# Default options
VERBOSE=""

# Read options
OPTIONS=$(getopt -o hv -l help,verbose -- "$@")
if [ $? -ne 0 ]; then
  fail
fi
eval set -- "$OPTIONS"
while true; do
  case "$1" in
    -h|--help)
      echo "$HELP_MESSAGE"
      exit 0
      ;;
    -v|--verbose)
      VERBOSE="TRUE"
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
if [ ! -d "$ExtDataPath" ]; then
  ExtDataPath="/mnt/$ExtDataBase"
fi
if [ ! -d "$ExtDataPath" ]; then
  echo "Could not find /$ExtDataBase or $ExtDataPath"
  exit 1
fi

function list_files() {
  for FILE in "${FILES[@]}"; do
    stat -c "  %A %U %G %n" "$FILE"
  done
}

echo "Checking permissions and group in $ExtDataPath ..."

mapfile -t FILES < <(find "$ExtDataPath" ! -group "$GROUP")
COUNT=${#FILES[@]}
if [ "$COUNT" -gt 0 ]; then
  echo "Found $COUNT files whose group is not $GROUP:"
  if [ -n "$VERBOSE" ]; then
    list_files
  fi
  echo
fi

mapfile -t FILES < <(find "$ExtDataPath" -type d ! -perm "$DIR_PERM")
COUNT=${#FILES[@]}
if [ "$COUNT" -gt 0 ]; then
  echo "Found $COUNT directories whose permissions are not $DIR_PERM:"
  if [ -n "$VERBOSE" ]; then
    list_files
  fi
  echo
fi

mapfile -t FILES < <(find "$ExtDataPath" -type f ! -perm "$FILE_PERM")
COUNT=${#FILES[@]}
if [ "$COUNT" -gt 0 ]; then
  echo "Found $COUNT files whose permissions are not $FILE_PERM:"
  if [ -n "$VERBOSE" ]; then
    list_files
  fi
  echo
fi
