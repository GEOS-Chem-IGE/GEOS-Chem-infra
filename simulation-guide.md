Simulation guide
================

This guide explains how to configure and run a [GEOS-Chem Classic](https://geos-chem.readthedocs.io/en/latest/index.html) (GCClassic) simulation on the [GRICAD/CIMENT](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/) computing cluster.


Prerequisites
-------------

1. You must have a PERSEUS account to access the GRICAD/CIMENT computing cluster. You can request an account at [perseus.univ-grenoble-alpes.fr](https://perseus.univ-grenoble-alpes.fr/).
2. You must be a member of the `pr-geoschem` project. Request to join the project [in PERSEUS](https://perseus.univ-grenoble-alpes.fr/my-projects/join-project).

You should also have a basic familiarity with the unix command line and git. Many guides available online; here are two from [The Carpentries](https://carpentries.org/):

* [Introduction to Unix](https://swcarpentry.github.io/shell-novice/)
* [Introduction to Git](https://swcarpentry.github.io/git-novice/)


Quickstart
----------

Once you are familiar with running GCClassic on GRICAD/CIMENT you can follow these steps to prepare and execute a new simulation. For your first simulation, follow the detailed [setup guide](#setup) below.

1. Use the `createRunDir.sh` script of your desired GCClassic version to create a new run directory in `/home/PROJECTS/pr-geoschem/<your-research-dir>`:

```bash
# You must execute createRunDir.sh from its parent directory
cd /home/PROJECTS/pr-geoschem/GCClassic-14.5.0/run
./createRunDir.sh
```

2. In the new run directory, replace `OutputDir` with a symlink to a new dir on `/bettik`:

```bash
mkdir /bettik/PROJECTS/pr-geoschem/<your-username>/<new-run-dir>
cd /home/PROJECTS/pr-geoschem/<your-research-dir>/<new-run-dir>
rmdir OutputDir
ln -s /bettik/PROJECTS/pr-geoschem/<your-username>/<new-output-dir> .
```

3. Copy the environment activation script:

```bash
cp -iv /home/PROJECTS/pr-geoschem/geos-chem-setup/gcclassic-gnu14.env .
```

4. Copy the job script templates:

```bash
cp -iv /home/PROJECTS/pr-geoschem/geos-chem-setup/jobscripts/*.sh .
```

5. Build the code:

Edit the `1_build.sh` script if you want to set special [build options](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/config-overview.html).

> [!TIP]
> The link above points to the documentation for the latest stable version of GCClassic. If you are using an older version, click on the black box in the bottom right corner of the page to select the documentation for the GCClassic version that you are using.

```bash
oarsub -S ./1_build.sh
```

6. Configure your simulation

Edit `geoschem_config.yml`, `HEMCO_Config.rc`, `HISTORY.rc`, etc. as needed. See the documentation on [configuring a simulation](https://geos-chem.readthedocs.io/en/14.5.0/gcclassic-user-guide/config-overview.html), and [configuring HEMCO](https://hemco.readthedocs.io/en/stable/hco-ref-guide/hemco-config.html) for details.

7. Execute a dry run:

```bash
oarsub -S ./2_dryrun.sh
```

8. Download any missing input data:

If you need to download a large volume of data, edit `download-data.sh` to increase the walltime.

```
oarsub -S ./download-data.sh
```

9. Run your simulation

> [!IMPORTANT]
> First edit `3_run.sh` to configure an appropriate job walltime (the default is 8 hours). Note that 48 hours is the maximum allowed walltime. See the [GRICAD/CIMENT documentation](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/joblaunch/job_management/) for details.

```bash
oarsub -S ./3_run.sh
```


Setup
-----

### 1. Connect to the `dahu` head node

Follow [the GRICAD/CIMENT documentation](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/connexion/) to configure ssh access to the cluster. Then, in a terminal on your local machine, execute:

```bash
ssh dahu.ciment
```

> [!TIP]
> Depending on how you configured ssh, you may instead use `ssh dahu` to connect to dahu.

### 2. Go to the `pr-geoschem` project directory

```bash
cd /home/PROJECTS/pr-geoschem
```

This directory is shared by all members of the `pr-geoschem` project. It contains the GCClassic model code, a link to meteorological and emissions input data, and software environments for running GEOS-Chem Classic simulations. It also contains work directories for different research topics.

Here are some of the subdirectories:

```
├── GCClassic-14.5.0/  # GCClassic version 14.5.0 model code
├── geos-chem-data     # Symbolic link to GEOS-Chem input data on the /bettik volume
├── geos-chem-setup/   # Setup scripts
├── micromamba/        # Software environments
```

You should store your simulation configurations in a subdirectory of the `pr-geoschem` project folder.

### 3. Create a subdirectory for your simulations

Within the `pr-geoschem` directory, create a new subdirectory to store the configuration and output of your simulations. Name the subdirectory with your username or a brief description of your research topic (e.g. `plastics` contains simulations related to atmospheric microplastic cycling).

Example:

```bash
cd /home/PROJECTS/pr-geoschem
mkdir <your-research-dir>  # replace <your-research-dir> with your chosen name
cd <your-research-dir>
```

Please add a `README.md` file in this directory with a brief description of your research topic and a list of the people working on it.

### 4. Optional: clone a specific version of the GEOS-Chem Classic code

If you want to run a specific version of GEOS-Chem Classic that is not already in the `pr-geoschem` directory, you will need to clone the official [GCClassic repository](https://github.com/geoschem/GCClassic) and checkout the desired release.

For example, if you wanted to use version 14.4.3:

```bash
# Go to the shared project directory
cd /home/PROJECTS/pr-geoschem

# Clone the GCClassic source code into a directory named with the version
git clone https://github.com/geoschem/GCClassic.git GCClassic-14.4.3
cd GCClassic-v14.4.3

# Checkout the desired version and create a new branch named with the version
git checkout tags/14.4.3
git switch -c v14.4.3

# Checkout all submodules (HEMCO, GEOS-Chem "science codebase")
git submodule init
git submodule update
```

You can run `git log -n 1` to double-check you have checked out the desired tag. The first line of the output should include the text `tag: <version>`, for example:

```
commit 6d3e8604ab6f4556ce4027b6893b5bacb5d7b88d (HEAD, tag: 14.4.3, main)
Author: Bob Yantosca <yantosca@seas.harvard.edu>
Date:   Tue Aug 13 14:33:55 2024 -0400

    GCClassic 14.4.3 release

    Updated version numbers in:
    - CHANGELOG.md
    - CMakeLists.txt
    - docs/source/conf.py

    Also updated CHANGELOG.md with the latest information.

    Signed-off-by: Bob Yantosca <yantosca@seas.harvard.edu>
```

### 5. Create a run directory for a new simulation

You can now use GEOS-Chem's built-in setup script to create a "run directory" for a new simulation. Go to the `run` directory of the GCClassic version you want to use and execute the `createRunDir.sh` script.

Example using GCClassic 14.5.0:

```bash
cd /home/PROJECTS/pr-geoschem/GCClassic-14.5.0/run
./createRunDir.sh
```

You will be prompted with a series of questions to configure the run directory:

> [!NOTE]
> If you are using a different version of GEOS-Chem, the questions and available options may differ from those shown here.

#### Configure input data and register as a GEOS-Chem user

If this is the first time you have created a run directory, you will be prompted to enter the path to the `ExtData` directory that contains input data for GEOS-Chem (meteorology, emissions, etc.). Enter `/bettik/PROJECTS/pr-geoschem/COMMON/geos-chem-data/ExtData`:

```
-----------------------------------------------------------
Define path to ExtData.
This will be stored in /home/houghi/.geoschem/config for future automatic use.
-----------------------------------------------------------
Enter path for ExtData:
-----------------------------------------------------------
>>> /bettik/PROJECTS/pr-geoschem/COMMON/geos-chem-data/ExtData
```

Then follow the prompts to register as a new GEOS-Chem user.

#### Choose simulation settings

The following steps are based on the GEOS-Chem Classic [guide to creating a full-chemistry simulation run directory](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/rundir-fullchem.html).

Next, you will be prompted to select a simulation type. Enter `1` to create a full-chemistry simulation (see the [GEOS-Chem Wiki](https://wiki.seas.harvard.edu/geos-chem/index.php?title=Guide_to_GEOS-Chem_simulations) for information on the different simulation types):

```
-----------------------------------------------------------
Choose simulation type:
-----------------------------------------------------------
   1. Full chemistry
   2. Aerosols only
   3. Carbon
   4. Hg
   5. POPs
   6. Tagged O3
   7. Trace metals
   8. TransportTracers
   9. CH4
  10. CO2
  11. Tagged CO
>>> 1
```

Use standard simulation options:

```
-----------------------------------------------------------
Choose additional simulation option:
-----------------------------------------------------------
  1. Standard
  2. Benchmark
  3. Complex SOA
  4. Marine POA
  5. Acid uptake on dust
  6. TOMAS
  7. APM
  8. RRTMG
>>> 1
```

Use MERRA-2 meteorology:

```
-----------------------------------------------------------
Choose meteorology source:
-----------------------------------------------------------
  1. MERRA-2 (Recommended)
  2. GEOS-FP
  3. GEOS-IT (Beta release)
  4. GISS ModelE2.1 (GCAP 2.0)
>>> 1
```

Use 4.0 x 5.0 (degrees) horizontal resolution:

```
-----------------------------------------------------------
Choose horizontal resolution:
-----------------------------------------------------------
  1. 4.0 x 5.0
  2. 2.0 x 2.5
  3. 0.5 x 0.625
>>> 1
```

Use a global horizontal domain:

```
-----------------------------------------------------------
Choose horizontal grid domain:
-----------------------------------------------------------
  1. Global
  2. Asia
  3. Europe
  4. North America
  5. Custom
>>> 1
```

Use 72 vertical levels:

```
-----------------------------------------------------------
Choose number of levels:
-----------------------------------------------------------
  1. 72 (native)
  2. 47 (reduced)
>>> 1
```

Create the run directory in the subdirectory you created in step 3:

```
-----------------------------------------------------------
Enter path where the run directory will be created:
-----------------------------------------------------------
>>> /home/PROJECTS/pr-geoschem/<your-research-dir>
```

Use the default run directory name:

```
-----------------------------------------------------------
Enter run directory name, or press return to use default:

NOTE: This will be a subfolder of the path you entered above.
-----------------------------------------------------------
>>>
```

Finally, choose whether you want to track changes to the run dir with git:

```
-----------------------------------------------------------
Do you want to track run directory changes with git? (y/n)
-----------------------------------------------------------
```

You can answer `y` even if you do not intend to use git to track your simulation settings; this will simply create a git repository in your run directory. You may wish to answer `n` if you plan on using a single git repository to track the settings of multiple simulations (e.g. multiple run dirs within a parent dir that is a git repository).

### 6. Configure the output directory

Your new run directory contains a subdirectory `OutputDir` where all model output will be saved. Since the output may include many or large files, you should not keep it on the `/home` volume but rather on the `/bettik` volume that is dedicated to (temporary) data storage.

Navigate to your personal directory in the `pr-geoschem` project on the `/bettik` volume and create a new directory to hold your simulation output. You probably want to include the run directory name in this directory's name to facilitate identification.

```bash
cd /bettik/PROJECTS/pr-geoschem/<your-username>
mkdir <new-output-dir>
```

Now return to your run directory and replace the `OutputDir` directory with a symlink to the new output directory on `/bettik`:

```bash
cd /home/PROJECTS/pr-geoschem/<your-research-dir>/<new-run-dir>
rmdir OutputDir
ln -s /bettik/PROJECTS/pr-geoschem/<your-username>/<new-output-dir> OutputDir
```

### 7. Configure the run environment

The `pr-geoschem` project contains an environment constructed with [micromamba](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html) that includes all the external compilers and libraries needed to build and run GEOS-Chem Classic (see the [GCClassic documentation](https://geos-chem.readthedocs.io/en/stable/getting-started/system-req-soft.html) for details). You will need to activate this environment and set some environment variables whenever you build GEOS-Chem or run a simulation. The script `/home/PROJECTS/pr-geoschem/geos-chem-setup/gcclassic-gnu14.env` will do this automatically. To make it easy to run this script, you should copy it into your run directory:

```bash
cp -vi /home/PROJECTS/pr-geoschem/geos-chem-setup/gcclassic-gnu14.env .
```

We recommend copying the script rather than using a symbolic link because the script might be modified in the future.

### 8. Configure job scripts

The GRICAD/CIMENT cluster has two types of nodes: head nodes and computation nodes. Head nodes such as `dahu` are reserved for light file management and submitting jobs. To run intensive tasks such as compiling GCClassic or running a simulation you must submit a job that will be executed by the computation nodes.

The `pr-geoschem` project includes templates for job scripts that execute three tasks:

1. Build GCClassic (`1_build.sh`)
2. Execute a dryrun to check the configuration and identify any missing input data (`2_dryrun.sh`)
  * Download any missing input data identified by the dryrun (`download-data.sh`)
4. Run a simulation (`3_run.sh`)

You should copy these example job scripts from `/home/PROJECTS/pr-geoschem/geos-chem-setup/jobscripts` into your run dir. It's important to copy the scripts rather than linking them because you will need to modify the settings (e.g. job resources and walltime).

```bash
cp /home/PROJECTS/pr-geoschem/geos-chem-setup/jobscripts/*.sh .
```

> [!IMPORTANT]
> Before using the run script (`3_run.sh`) you should edit it to configure resources and walltime appropriate for your simulation.

The [GRICAD/CIMENT documentation](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/joblaunch/) details how to submit and view jobs and explains how they are scheduled by the OAR job manager.

### 9. Configure the simulation

You can now follow the GCClassic user guide steps to:

1. [Compile the code](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/compile.html)
2. [Configure your simulation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/config-overview.html)
3. [Test your configuration with a dry-run simulation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/dry-run-run.html)
4. [Download any missing input data identified by the dry-run simulation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/dry-run-download.html) (for this test simulation, the required data should already be in the input data directory `/bettik/PROJECTS/pr-geoschem/COMMON/geos-chem-data/ExtData`).
5. [Run a simulation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/run.html)

> [!IMPORTANT]
> Do not run the commands in these guides on the `dahu` head node. Whenever the setup guide tells you to execute a command, use one of the job scripts to execute it on a computation node. For example, the `1_build.sh` script will configure the compilation with `cmake` and build the code with `make`.

### 10. Examine the simulation output

If your run completed successfully, you should see the output files in `OutputDir`.

TODO document viewing + plotting output?


Further resources
-----------------

* [GEOS-Chem documentation](https://geos-chem.readthedocs.io/en/stable/)

* [GEOS-Chem simulation types](https://wiki.seas.harvard.edu/geos-chem/index.php?title=Guide_to_GEOS-Chem_simulations)

* [GRICAD/CIMENT documentation](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/)
