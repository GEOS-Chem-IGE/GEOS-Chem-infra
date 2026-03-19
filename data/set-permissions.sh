#!/usr/bin/env bash

#===============================================================================
# Set permissions on files and directories in summer/geoschem/COMMON/ExtData/
#===============================================================================

# Defaults
GROUP="pr-geoschem"
DIR_PERM="u=rwx,g=rwxs,o="
FILE_PERM="u=rw,g=r,o="

# Get current user
USER=$(whoami)

# Help message
read -r -d '' HELP_MESSAGE << EOM
Set permissions on all files and directories in summer/geoschem/COMMON/ExtData

Usage:
  set-permissions.sh [OPTION]

Options:
  -h, --help     Print this help message
  -n, --dry-run  Only display what would have been done
  -v, --verbose  Report all changes made

Example:
  ./set-permissions.sh
EOM

function fail() {
  echo 'Run with --help for more information'
  exit 1
}

# Default options
DRYRUN=""
VERBOSE=""

# Read options
OPTIONS=$(getopt -o hnv -l help,dry-run,verbose -- "$@")
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
    -n|--dry-run)
      DRYRUN="true"
      ;;
    -v|--verbose)
      VERBOSE="-c"
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

echo "Setting group and permissions in $ExtDataPath ..."

# Set group
mapfile -t FILES < <(find "$ExtDataPath" -user "$USER" ! -group "$GROUP")
COUNT=${#FILES[@]}
if [ "$COUNT" -gt 0 ]; then
  if [ -n "$DRYRUN" ]; then
    echo "dry-run: skipping chgrp $GROUP for $COUNT files"
    if [ -n "$VERBOSE" ]; then
      list_files
      echo
    fi
  else
    for FILE in "${FILES[@]}"; do
      chgrp "$VERBOSE" "$GROUP" "$FILE"
    done
  fi
fi

# Set directory permissions
mapfile -t FILES < <(\
  find "$ExtDataPath" -user "$USER" -type d ! -perm "$DIR_PERM")
COUNT=${#FILES[@]}
if [ "$COUNT" -gt 0 ]; then
  if [ -n "$DRYRUN" ]; then
    echo "dry-run: skipping chmod $DIR_PERM for $COUNT directories"
    if [ -n "$VERBOSE" ]; then
      list_files
      echo
    fi
  else
    for FILE in "${FILES[@]}"; do
      chmod "$VERBOSE" "$DIR_PERM" "$FILE"
    done
  fi
fi

# Set file permissions
mapfile -t FILES < <(\
  find "$ExtDataPath" -user "$USER" ! -path "$ExtDataPath"/README.md\
    -type f ! -perm "$FILE_PERM")
COUNT=${#FILES[@]}
if [ "$COUNT" -gt 0 ]; then
  if [ -n "$DRYRUN" ]; then
    echo "dry-run: skipping chmod $FILE_PERM for $COUNT files"
    if [ -n "$VERBOSE" ]; then
      list_files
      echo
    fi
  else
    for FILE in "${FILES[@]}"; do
      chmod "$VERBOSE" "$FILE_PERM" "$FILE"
    done
  fi
fi
