#!/usr/bin/env bash

#====================================================
# Check permissions in summer/geoschem/COMMON/ExtData
#====================================================

# Defaults
GROUP="pr-geoschem"
DIR_PERM="u=rwx,g=rwxs,o="
FILE_PERM="u=rw,g=r,o="

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

echo "Checking group and permissions in $ExtDataPath ..."

mapfile -t FILES < <(find "$ExtDataPath" ! -group "$GROUP")
COUNT=${#FILES[@]}
if [ "$COUNT" -gt 0 ]; then
  echo "Found $COUNT files whose group is not $GROUP:"
  list_files
  echo
fi

mapfile -t FILES < <(find "$ExtDataPath" -type d ! -perm "$DIR_PERM")
COUNT=${#FILES[@]}
if [ "$COUNT" -gt 0 ]; then
  echo "Found $COUNT directories whose permissions are not $DIR_PERM:"
  list_files
  echo
fi

EXCLUDE="$ExtDataPath"/README.md
mapfile -t FILES < <(\
  find "$ExtDataPath" -type f ! -perm "$FILE_PERM" ! -path "$EXCLUDE")
COUNT=${#FILES[@]}
if [ "$COUNT" -gt 0 ]; then
  echo "Found $COUNT files whose permissions are not $FILE_PERM:"
  list_files
  echo
fi
