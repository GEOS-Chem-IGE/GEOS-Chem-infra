GEOS-Chem-Infra
===============

This repository contains software infrastructure to run the [GEOS-Chem](https://geoschem.github.io/index.html) global atmospheric chemistry model at the [IGE lab](https://www.ige-grenoble.fr/?lang=en).


Contents
--------

* [data](data/): Scripts to manage the GEOS-Chem input data on the `summer/geoschem` volume. Additional input data can be downloaded by following the instructions provided at [GEOS-Chem documentation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/download-data.html).

* [doc](doc/): Documentation and tutorials for running GEOS-Chem on the [GRICAD/CIMENT](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/) and [ige-calcul](https://ige-calcul.github.io/public-docs/docs/clusters/Ige/ige-calcul1.html) computing clusters.

* [run](run/): Template job scripts for building the GEOS-Chem model code and running simulations on the computing clusters. See the [simulation guide](doc/simulation-guide.md) for details.

* [tools](tools/): Miscellaneous helper scripts


Style Guide
-----------

### Markdown files

* Filenames are lowercase with dashes between words e.g. `setup-guide.md`

### Code

* Code must be linted with [ruff](https://docs.astral.sh/ruff/)
* File and directory names are lowercase with underscores. e.g. `run_module.py`


Contact
-------

* [Hélène Angot](mailto:helene.angot@univ-grenoble-alpes.fr)
* [Jennie Thomas](mailto:jennie.thomas@univ-grenoble-alpes.fr)
