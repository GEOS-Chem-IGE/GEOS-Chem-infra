geos-chem-setup
===============

Configuration scripts, environment specs, job script templates, and helper utilities for running [GEOS-Chem Classic](https://geos-chem.readthedocs.io/en/latest/index.html) (GCClassic) on [GRICAD/CIMENT](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/).


To run a simulation
-------------------

Follow the [simulation guide](Simulation-guide) to run a GEOS-Chem simulation.


Project setup
-------------

These are the steps used to setup the `pr-geoschem` project on GRICAD/CIMENT. You should not need to repeat them.

### 1. Clone this repository

Connect to `dahu` (see [the GRICAD documentation](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/connexion/) for details) and clone this repository in the shared `/home/PROJECTS/pr-geoschem` folder:

```bash
# On dahu
cd /home/PROJECTS/pr-geoschem
git clone git@github.com:IGE-Microplastics/geos-chem-setup.git
```

### 2. Configure the setup script

Open `setup.sh` and edit the configuration variables as needed. The default configuration is:

```bash
PROJECT='pr-geoschem'                                   # Project name
CODE_DIR="/home/PROJECTS/pr-geoschem"                   # Shared code dir
DATA_DIR="/bettik/PROJECTS/pr-geoschem/COMMON"          # Shared data dir
MAMBA_DIR="/home/PROJECTS/pr-geoschem/micromamba"       # Micromamba envs dir
SETUP_DIR="/home/PROJECTS/pr-geoschem/geos-chem-setup"  # Path to this repository
GC_VERSION='14.5.0'                                     # GEOS-Chem Classic version
```

### 3. Run the setup script

```bash
cd /home/PROJECTS/pr-geoschem/geos-chem-setup
./setup.sh
```

The setup script:

* Installs [micromamba](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html)
* Creates a micromamba environment `gcclassic-gnu14` containing the compilers and libraries needed to build and run GCClassic
* Clones the GEOS-Chem model code [GCClassic](https://github.com/geoschem/GCClassic) in the shared code dir and checks out the specified version
* Clones the input data repository [geos-chem-data](https://github.com/IGE-Microplastics/geos-chem-data) in the shared data dir
* Clones the data managment tool [bashdatacatalog](https://github.com/LiamBindle/bashdatacatalog) in the shared code dir

### 4. Configure bashdatacatalog

Add the `bashdatacatalog` scripts to your path (see installation message). Otherwise you will need to specify the full path to any bashdatacatalog scripts e.g. `/home/PROJECTS/pr-geoschem/bashdatacatalog/bin/bashdatacatalog-list`.

### 5. Next steps

You can now follow the [new user guide](new-user-guide.md) to launch a GEOS-Chem simulation.


Other tasks
-----------

To modify a micromamba environment, edit the corresponding `.yml` file, recreate the environment, and update the corresponding `.lock` file.

Example:

```bash
# After editing gcclassic-gnu14.yml
source ./init-mamba.sh
micromamba create --file gcclassic-gnu14.yml
micromamba env export --explicit --name gcclassic-gnu14 > gcclassic-gnu14.lock
```

To update list the contents of this repository, use:

```bash
tree -aF --dirsfirst -I .git/
```


Repository contents
-------------------

```
├── jobscripts/
│   ├── 1_build.sh*       # Template build script
│   ├── 2_dryrun.sh*      # Template dryrun script
│   ├── 3_run.sh*         # Template simulation script
│   └── download-data.sh* # Template input data download script
├── compare-rundirs.sh*   # Helper to compare (diff) configuration files between two rundirs
├── copy-rundir.sh        # Helper to create a new run dir based on an existing one
├── gcclassic-gnu14.env   # Activation script for gcclassic-gnu14 environment
├── gcclassic-gnu14.lock  # Explicit spec for gcclassic-gnu14 environment
├── gcclassic-gnu14.yml   # Loose spec for gcclassic-gnu14 environment
├── init-mamba.sh         # Source this script to initialize micromamba
├── README.md             # Documentation
├── setup.sh*             # Setup script
└── simulation-guide.md   # Guide to setting up a new simulation
```
