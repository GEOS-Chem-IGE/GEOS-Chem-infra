data
====

This directory contains a list of all input data files that are on the GEOS-Chem-IGE "summer" volume (`summer/geoschem/COMMON/ExtData`) and helper scripts for maintenance tasks.


Instructions for maintainers
----------------------------

Use `update-file-list.sh` to update the list of data files.

Use `set-permissions.sh` to set consistent permissions on all data files:

* `drwxrwsr-x` for directories
* `-rw-r--r--` for files

Use `check-permissions`.sh` to identify files with wrong permissions


Bashdatacatalog 
-----------------
Bashdatacatalog is a tool used to verify file integrity of GEOS-Chem input files. By following the instructions [here](https://github.com/GEOS-Chem-IGE/bashdatacatalog), user can check for any corrupted input files that may have occurred if the download process was interrupted or stopped.

For example, to check for corrupted meteorological files you may run : 

`bashdatacatalog-list -a -w -r "2016-01-01,2017-01-01" InputDataCatalogs/MeteorologicalInputs.csv `


> [!NOTE]
> Bashdatacatalog should always be run from the top-level GEOS-Chem data directory. In our case, this is:
`/smmer/geoschem/COMMON/ExtData`
