data
====

This directory contains a list of all input data files that are on the GEOS-Chem-IGE "summer" volume (`summer/geoschem/COMMON/ExtData`) and helper scripts for maintenance tasks.


Instructions for maintainers
----------------------------

Use `update-file-list.sh` to update the list of data files.

Use `set-permissions.sh` to set consistent permissions on all data files:

* `drwxrws---` for directories
* `-rw-r-----` for files
