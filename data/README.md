data
====

This directory contains a list of all input data files that are on the GEOS-Chem-IGE "summer" volume (`summer/geoschem/COMMON/ExtData`) and helper scripts for maintenance tasks.

Use `update-file-list.sh` to update the list of data files.

Use `set-permissions.sh` to set consistent permissions on all data files:

* `drwxrws---` for directories
* `-rw-r-----` for files

See the [GEOS-Chem documentation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/download-data.html) for instructions on downloading additional input data as needed.
