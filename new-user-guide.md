New user guide
==============

This guide explains how to configure and run a [GEOS-Chem Classic]([GEOS-Chem Classic](https://geos-chem.readthedocs.io/en/latest/index.html) (GCClassic) simulation on the [CIMENT](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/) computing cluster.


Prerequisites
-------------

1. You must have a PERSEUS account to access CIMENT. You can request an account at [perseus.univ-grenoble-alpes.fr](https://perseus.univ-grenoble-alpes.fr/).
2. You must be a member of the `pr-geoschem` project. Request to join the project [here](https://perseus.univ-grenoble-alpes.fr/my-projects/join-project).

You should also have a basic familiarity with the unix command line and git. Many guides available online; here are two from [The Carpentries](https://carpentries.org/):

* [Introduction to Unix](https://swcarpentry.github.io/shell-novice/)
* [Introduction to Git](https://swcarpentry.github.io/git-novice/)


Setup
-----

### 1. Connect to the `dahu` head node

Follow [the GRICAD documentation](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/connexion/) to configure ssh access to the cluster. Then, in a terminal on your local machine, run:

```bash
ssh dahu.ciment
```

> [!NOTE]
> Depending on how you configured ssh, you may instead need to use `ssh dahu` to connect to dahu.

### 2. Go to the `pr-geoschem` project directory

```bash
cd /home/PROJECTS/pr-geoschem
```

The `pr-geoschem` project directory contains the GCClassic code, input data, and software environments for running GEOS-Chem simulations. The most important subdirectories are:

```
├── GCClassic-14.5.0/  # GCClassic version 14.5.0 model code
├── geos-chem-data     # Symbolic link to GEOS-Chem input data on the /bettik volume
├── geos-chem-setup/   # Setup scripts
├── micromamba/        # Software environments
```

### 3. Create a subdirectory for your research topic

Within the `pr-geoschem` directory, create a new subdirectory to store the configuration and output of your simulation runs. Name the subdirectory with your username or a brief description of your research topic (e.g. `plastics` contains simulations related to atmoshperic microplastic cycling).

Example:

```bash
cd /home/PROJECTS/pr-geoschem
mkdir `whoami`  # creates a directory named with your username
cd `whoami`
```
Please add a `README.md` file in the new directory with a brief description of your research topic and a list of the people working on it.

### 4. Create a run dir for a new simulation

You can now use GEOS-Chem's built-in setup script to create a run directory for a new simulation. Go to the `run` directory of the GEOS-Chem version you want to use and run the `createRunDir.sh` script.

Example using GCClassic v14.5.0:

```bash
cd /home/PROJECTS/pr-geoschem/GCClassic-14.5.0/run
./createRunDir.sh
```

#### Configure input data and register as a GEOS-Chem user

The first time you create a run directory, you will be prompted to enter the path to the `ExtData` directory that contains input data for GEOS-Chem. Enter `/bettik/PROJECTS/pr-geoschem/COMMON/geos-chem-data/ExtData`:

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

#### Choose a simulation type

Next, you will be prompted to select a simulation type. Enter `1` to create a full-chemistry simulation:

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

Use 4.0 x 5.0 (degrees) horizontal resolution

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

Create the run dir in the subdirectory you created in step 3:

```
-----------------------------------------------------------
Enter path where the run directory will be created:
-----------------------------------------------------------
>>> /home/PROJECTS/pr-geoschem/<your-research-dir>
```

Use the default run dir name:

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

We recommend tracking changes with git, but you may wish to answer `n` and instead create a git repository in the subdirectory you created in step 3. This allows you to track all simulations related to your research topic in a single repository.

### 5. Configure the run dir

Now, go to the run dir you just created and symlink the environment activation script `gcclassic-gnu14` from `geos-chem-setup` into the run dir. This will make it easy to activate the environment needed to run GCClassic:

```
cd <your-new-run-dir>
ln -s /home/PROJECTS/pr-geoschem/geos-chem-setup/gcclassic-gnu14.env .
```

Next, **copy** the example job scripts from `geos-chem-setup/jobscripts` into the run dir. It's important to copy the scripts not link them because you will likely want to modify some settings (e.g. resources and walltime).

```
cp /home/PROJECTS/pr-geoschem/geos-chem-setup/jobscripts/*.sh .
```

These job scripts facilitate submitting jobs to the [OAR job manager](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/joblaunch/job_management/) for the three main GEOS-Chem simulation steps:

1. Compile the model code (`1_build.sh`)
2. Execute a dryrun to check the configuration and identify any missing input data (`2_dryrun.sh`)
3. Run the simulation (`3_run.sh`)

> [!IMPORTANT]
> Before using the run script (`3_run.sh`) you should edit it to configure resources and walltime appropriate for your simulation.

### 6. Configure the simulation

You can now follow the GCClassic user guide steps to [compile the code](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/compile.html) and [configure the simulation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/config-overview.html).

> [!IMPORTANT]
> Do not build the model or run simulations on the `dahu` head node. Whenever the setup guide tells you to run code, use the job scripts (e.g. `1_build.sh`) to execute the command on a computation node. See the [GRICAD documentation](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/joblaunch/) for further details on job submission.


Further resources
-----------------

* [GEOS-Chem documentation](https://geos-chem.readthedocs.io/en/stable/)

* [GEOS-Chem simulation types](https://wiki.seas.harvard.edu/geos-chem/index.php?title=Guide_to_GEOS-Chem_simulations)

* [CIMENT documentation](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/)
