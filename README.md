geos-chem-setup
===============

Configuration scripts and environment specs for running [GEOS-Chem Classic](https://geos-chem.readthedocs.io/en/latest/index.html) on [CIMENT](https://gricad-doc.univ-grenoble-alpes.fr/hpc/).

Usage
-----

### 1. Clone this repository

Connect to `dahu` (see [GRICAD documentation](https://gricad-doc.univ-grenoble-alpes.fr/hpc/connexion/) for details) and clone this repository in your project's shared folder (`/home/PROJECTS/<your-project>`).

Example:

```bash
# On dahu
cd /home/PROJECTS/pr-geoschem
git clone https://github.com/IGE-Microplastics/geos-chem-setup.git
```

### 2. Configure the setup script

Open `setup.sh` and edit the configuration variables as needed. The default configuration is:

```bash
PROJECT='pr-geoschem'                                   # Project name
CODE_DIR="/home/PROJECTS/pr-geoschem"                   # Shared code dir
DATA_DIR="/bettik/PROJECTS/pr-geoschem/COMMON"          # Shared data dir
SETUP_DIR="/home/PROJECTS/pr-geoschem/geos-chem-setup"  # Path to this repository
GC_VERSION='14.4.3'                                     # GEOS-Chem Classic version
```

### 3. Run the setup script

Example:

```bash
cd /home/PROJECTS/pr-geoschem/geos-chem-setup
./setup.sh
```

The setup script:

* Creates a micromamba environment (`gcclassic-gnu14`)
* Clones the GEOS-Chem model code [GCClassic](https://github.com/geoschem/GCClassic) in the shared code dir
* Clones the data tracking repository [geos-chem-data](https://github.com/IGE-Microplastics/geos-chem-data) in the shared data dir
* Clones the data managment tool [bashdatacatalog](https://github.com/LiamBindle/bashdatacatalog) in the shared code dir

### 4. Configure bashdatacatalog

Add the `bashdatacatalog` scripts to your path (see installation message). Otherwise you will need to specify the full path to any bashdatacatalog commands e.g. `/home/PROJECTS/pr-geoschem/bashdatacatalog/bin/bashdatacatalog-list`.

### 5. Next steps

You should now be set up to build and run GCClassic. After [creating a run dir](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/create-rundir.html), you should symlink the `gcclassic-gnu14` environment activation script into your run dir to facilitate activating the environment:

```bash
# In a run dir
link -s /home/PROJECTS/pr-geoschem/geos-chem-setup/gcclassic-gnu14.env .

# You can now activate the environment with:
source gcclasic-gnu14.env
```

You should also **copy** the example job scripts from `jobscripts/` to your run dir:

```bash
# In a run dir
cp /home/PROJECTS/pr-geoschem/geos-chem-setup/jobscripts/*.sh .
```

These scripts facilitate submitting jobs to the [OAR job manager](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/joblaunch/job_management/) to:

1. Compile the code (`1_build.sh`)
2. Execute a dryrun to check the configuration and identify any missing input data (`2_dryrun.sh`)
3. Run the simulation (`3_run.sh`)

Be sure to edit the run script (`3_run.sh`) to configure resources and walltime appropriate for your simulation.

Refer to the [GCClassic documentation](https://geos-chem.readthedocs.io/en/stable/) for further deatils on [compiling the code](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/compile.html) and [configuring a simulation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/config-overview.html). See [geos-chem-data](https://github.com/IGE-Microplastics/geos-chem-data) for instructions on downloading any input data needed for your simulation.

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

Repository contents
-------------------

```
├── .git/
├── jobscripts/
│   ├── 1_build.sh*       # Example build script
│   ├── 2_dryrun.sh*      # Example dryrun script
│   └── 3_run.sh*         # Example simulation script
├── README.md
├── gcclassic-gnu14.env   # Activation script for gcclassic-gnu14 environment
├── gcclassic-gnu14.lock  # Explicit spec for gcclassic-gnu14 environment
├── gcclassic-gnu14.yml   # Loose spec for gcclassic-gnu14 environment
├── init-mamba.sh         # Source this script to initialize micromamba
└── setup.sh*             # Setup script
```
