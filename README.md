GEOS-Chem-Infra
===============

This repository contains software infrastructure to run the [GEOS-Chem](https://geoschem.github.io/index.html) global atmospheric chemistry model at the [IGE lab](https://www.ige-grenoble.fr/?lang=en).


Contents
--------

* [doc](doc/): documentation and tutorials for installation and running GEOS-Chem on [Dahu (GRICAD)](https://github.com/GEOS-Chem-IGE/GEOS-Chem-infra/blob/issue14/update-readme/doc/dahu-ciment.md) and [IGE-Calcul (internal IGE server)] servers. 

* [data](data/): The input data required for GEOS-Chem simulations are loaded on the ```summer```volume. The contents of ```data``` directory allows users to update or supplement the list of currently available inputs. If necessary, additional data can be downloaded by following the instructions provided at [GEOS-Chem documentation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/download-data.html).

* [run](run/): all required scripts to run a GEOS-Chem simulation on [Dahu (GRICAD)](https://github.com/GEOS-Chem-IGE/GEOS-Chem-infra/tree/issue14/update-readme/run/dahu-ciment) and [IGE-Calcul](https://github.com/GEOS-Chem-IGE/GEOS-Chem-infra/tree/issue14/update-readme/run/ige-calcul) .


Contact
-------

* [Hélène Angot](mailto:helene.angot@univ-grenoble-alpes.fr)
* [Jennie Thomas](mailto:jennie.thomas@univ-grenoble-alpes.fr)
