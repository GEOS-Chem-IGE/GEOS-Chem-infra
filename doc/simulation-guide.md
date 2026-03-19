GEOS-Chem simulation guide
==========================

This guide explains how to configure and run a [GEOS-Chem Classic (GCClassic)](https://geos-chem.readthedocs.io/en/latest/index.html) simulation on the [GRICAD/CIMENT](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/) and [ige-calcul](https://ige-calcul.github.io/public-docs/docs/clusters/Ige/ige-calcul1.html) computing clusters.


Prerequisites
-------------

<details>
     <summary>For GRICAD/CIMENT</summary>

1. You must have a PERSEUS account to access the GRICAD/CIMENT computing cluster. You can request an account at [perseus.univ-grenoble-alpes.fr](https://perseus.univ-grenoble-alpes.fr/).
2. You must be a member of the `pr-geoschem` project. Request to join the project [in PERSEUS](https://perseus.univ-grenoble-alpes.fr/my-projects/join-project).

</details>

<details>
     <summary>For ige-calcul</summary>

1. You must have a Agalan account (Univ. Grenoble Alpes computing account)
2. You must have a SLURM (job scheduler) account on `ige-calcul`. Ask the admins to create your account as explained [here](https://ige-calcul.github.io/public-docs/docs/clusters/Ige/ige-calcul1.html#connection-to-the-server).

</details>

You should also have a basic familiarity with the Unix command line and git. Many guides available online; here are two from [The Carpentries](https://carpentries.org/):

- [Introduction to Unix](https://swcarpentry.github.io/shell-novice/)
- [Introduction to Git](https://swcarpentry.github.io/git-novice/)


Common settings for both platforms
----------------------------------

* Model and simulation code should be placed in `WORKDIR`.
* The input data are located in `INPUTDIR`.
* The `job-submission-command` adds a task to the system's queue.

The values of these variables for each platform are listed below:

<details>
     <summary>For GRICAD/CIMENT</summary>

- `WORKDIR` = `/home/PROJECTS/pr-geoschem/<username>`
- `INPUTDIR` = `/summer/geoschem/COMMON/ExtData`
- `job-submission-command` = `oarsub -S`

</details>

<details>
     <summary>For ige-calcul</summary>

- `WORKDIR` = `/workdir/<teamname>/<username>` where `<teamname>` is the name of your IGE research team
- `INPUTDIR` = `/mnt/summer/geoschem/COMMON/ExtData`
- `job-submission-command` = `sbatch`

</details>


Quickstart
----------

Once you are familiar with running simulations on a cluster you can follow these steps to prepare and execute a new simulation. For your first simulation, follow the [detailed guide](#detailed-guide) below.

1. Clone the GEOS-Chem model code in `WORKDIR` and check out the desired version.

```bash
cd "$WORKDIR"
git clone --recurse-submodules https://github.com/geoschem/GCClassic.git
cd GCClassic
git switch --create=v14.4.3 tags/14.4.3
git submodule update --init --recursive
```

2. Use GEOS-Chem's `createRunDir.sh` script to create a run dir for your simulation.

```bash
# You must execute createRunDir.sh from its parent directory
cd "$WORKDIR/GCClassic/run"
./createRunDir.sh
```

3. In the new run directory, replace `OutputDir` and `Restarts` with symlinks to new dirs on `/bettik`:

```bash
cd "$WORKDIR/<run-dir>"
rmdir OutputDir Restarts
mkdir -p /bettik/PROJECTS/pr-geoschem/<your-username>/<run-dir>/OutputDir
mkdir -p /bettik/PROJECTS/pr-geoschem/<your-username>/<run-dir>/Restarts
ln -sv /bettik/PROJECTS/pr-geoschem/<your-username>/<run-dir>/* .
```

5. Copy job script templates for your computing platform into the run dir.

```bash
cd "$WORKDIR/<run-dir>"

# Template job scripts
cp -iv "$WORKDIR/GEOS-Chem-infra/run/<platform>/*.sh ."
```

On GRICAD/CIMENT, you also need to copy the environment activation script:

```bash
cp -iv "$WORKDIR/GEOS-Chem-infra/run/ciment/gcclassic-gnu14.env ."
```

5. Build the model.

Edit the `1_build.sh` script if you want to set special [build options](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/config-overview.html).

> [!TIP]
> The link above points to the documentation for the latest stable version of GCClassic. If you are using an older version, click on the black box in the bottom right corner of the page to select the documentation for the GCClassic version that you are using.

```bash
<job-submission-command> ./1_build.sh
```

6. Configure your simulation.

Edit `geoschem_config.yml`, `HEMCO_Config.rc`, `HISTORY.rc`, etc. as needed. See the documentation on [configuring a simulation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/config-overview.html), and [configuring HEMCO](https://hemco.readthedocs.io/en/stable/hco-ref-guide/hemco-config.html) for details.

7. Execute a dry run.

```bash
<job-submission-command> ./2_dryrun.sh
```

8. Download any missing input data.

If you need to download a large volume of data, edit `download-data.sh` to increase the walltime.

```bash
<job-submission-command> ./download-data.sh
```

9. Run your simulation

> [!IMPORTANT]
> First edit `3_run.sh` to configure an appropriate job walltime (the default is 8 hours). Note that 48 hours is the maximum allowed walltime on both GRICAD/CIMENT and ige-calcul.

```bash
<job-submission-command> ./3_run.sh
```


Detailed guide
--------------

### 1. Connect to the computing cluster

<details>
     <summary>For GRICAD/CIMENT</summary>

On *GRICAD/CIMENT* you should to connect the `dahu` head node.

Follow [the GRICAD/CIMENT documentation](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/connexion/) to configure ssh access to the cluster. Then, in a terminal on your local machine, execute:

```bash
ssh dahu.ciment
```

</details>

<details>
     <summary>For ige-calcul</summary>

On *ige-calcul* you should connect to the `ige-calcul1` head node:

```bash
ssh <username>@ige-calcul1.u-ga.fr
```

Replace `<username>` with your Agalan username. For more detail check [here](https://ige-calcul.github.io/public-docs/docs/clusters/Ige/ige-calcul1.html#connection-to-the-server).

> [!TIP]
> Once you have configured ssh as explained [here](https://ige-calcul.github.io/public-docs/docs/clusters/Ige/ige-calcul1.html#connection-to-the-server), you may use `ssh calcul1` to connect to the `ige-calcul1` head node.

</details>

### 2. Create `WORKDIR`

You should place all model code and simulation runs in your personal `WORKDIR` which is named with your username.

<details>
     <summary>For GRICAD/CIMENT</summary>

On GRICAD/CIMENT, your `WORKDIR` is on the `/home/PROJECTS/pr-geoschem` volume:

```bash
cd /home/PROJECTS/pr-geoschem
mkdir -p <username>
```

</details>

<details>
     <summary>For ige-calcul</summary>

On ige-calcul, your `WORKDIR` is on your research team's volume:

```bash
cd /workdir/<teamname>
mkdir -p <username>
```

</details>

### 3. Clone this repository (GEOS-Chem-infra)

This will give you access to helper scripts to facilitate building the model and running simulations.

```bash
# Go to your WORKDIR
cd "$WORKDIR"

# Clone the GEOS-Chem-infra repository
git clone https://github.com/GEOS-Chem-IGE/GEOS-Chem-infra
```

### 4. Clone the GEOS-Chem model code and check out your desired version

> [!TIP]
> You may find it helpful to add a suffix to the model code directory identifying a specific version.

```bash
# Go to your WORKDIR
cd "$WORKDIR"

# Clone the GCClassic source code into a directory named with the version you
# plan to use (here 14.4.3)
git clone --recurse-submodules https://github.com/geoschem/GCClassic.git GCClassic-14.4.3
cd GCClassic-v14.4.3

# Checkout the desired version
git checkout --detach tags/14.4.3

# Update all submodules (HEMCO, GEOS-Chem "science codebase")
git submodule update --recursive
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

```bash
# You must execute createRunDir.sh from its parent directory
cd $WORKDIR/GCClassic-14.4.3/run
./createRunDir.sh
```

You will be prompted with a series of questions to configure the run directory:

> [!NOTE]
> If you are using a different version of GEOS-Chem, the questions and available options may differ from those shown here.

The following steps are based on the GEOS-Chem Classic [guide to creating a full-chemistry simulation run directory](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/rundir-fullchem.html).

#### Configure input data and register as a GEOS-Chem user

If this is the first time you have created a run directory, you will be prompted to enter the path to the `ExtData` directory that contains input data for GEOS-Chem (meteorology, emissions, etc.). Enter the `INPUTDATA` path corresponding to your computing platform (see [here](#common-settings-for-both-platforms)). For example, this is the kind of question you will be asked:

```
-----------------------------------------------------------
Define path to ExtData.
This will be stored in /home/<your-username>/.geoschem/config for future automatic use.
-----------------------------------------------------------
Enter path for ExtData:
-----------------------------------------------------------
>>> $INPUTDIR
```

Then follow the prompts to register as a new GEOS-Chem user.

#### Choose simulation settings

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
>>> $WORKDIR/<your-run-dir>
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

### 7. Configure the run environment

> [!NOTE]
> `ige-calcul` users can skip this step.

The `/home/PROJECTS/pr-geoschem` project contains an environment constructed with [micromamba](https://mamba.readthedocs.io/en/latest/user_guide/micromamba.html) that includes all the external compilers and libraries needed to build and run GEOS-Chem Classic (see the [GCClassic documentation](https://geos-chem.readthedocs.io/en/stable/getting-started/system-req-soft.html) for details). You will need to activate this environment and set some environment variables whenever you build GEOS-Chem or run a simulation. This repository contains [a script](/run/ciment/gcclassic-gnu14.env) that you can source to activate the environment. You should copy this script into your run directory:

```bash
cd <run-dir>
cp -iv "$WORKDIR/GEOS-Chem-infra/run/ciment/gcclassic-gnu14.env ."
```

You should copy the script rather than using a symbolic link because the script might be modified in the future.

### 8. Configure job scripts

The GRICAD/CIMENT and ige-calcul clusters have two types of nodes: head nodes and computation nodes. Head nodes are reserved for light file management and submitting jobs. For other tasks such as compiling GCClassic or running a simulation you must submit a job that will be executed on a computation node.

The `run` directory of this repository includes templates for job scripts to execute common tasks:

1. Build GCClassic (`1_build.sh`)
2. Execute a dryrun to check the configuration and identify any missing input data (`2_dryrun.sh`)
3. Download any missing input data identified by the dryrun (`download-data.sh`)
4. Run a simulation (`3_run.sh`)

You should copy these example job scripts from `$WORKDIR/GEOS-Chem-infra/run/<platform>` into your run directory. It's important to copy the scripts rather than linking them because you will need to modify the settings (e.g. job resources and walltime).

```bash
cd <run-dir>
cp -iv "$WORKDIR/GEOS-Chem-infra/run/<platform-name>/*.sh ."
```

> [!IMPORTANT]
> Before using the run script (`3_run.sh`) you should edit it to configure resources and walltime appropriate for your simulation.

You can find more details on job submission and management in the [GRICAD/CIMENT documentation](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/joblaunch/) and the [ige-calcul](https://ige-calcul.github.io/public-docs/docs/clusters/Ige/ige-calcul1.html#slurm-submit-a-job-on-the-cluster) documentation.

### 9. Configure the simulation

You can now follow the GCClassic user guide steps to:

1. [Compile the code](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/compile.html)
2. [Configure your simulation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/config-overview.html)
3. [Test your configuration with a dry-run simulation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/dry-run-run.html)
4. [Download any missing input data identified by the dry-run simulation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/dry-run-download.html) (for this test simulation, the required data should already be in `INPUTDIR`).
5. [Run the simulation](https://geos-chem.readthedocs.io/en/stable/gcclassic-user-guide/run.html)

> [!IMPORTANT]
> Do not run the commands in these guides on the head node. Whenever the setup guide tells you to execute a command, use one of the job scripts to execute it on a computation node. For example, the `1_build.sh` script will configure the compilation with `cmake` and build the code with `make`.

### 10. Examine the simulation output

If your run completed successfully, you should see the output files in `<run-dir>/OutputDir`.


Further resources
-----------------

- [GEOS-Chem documentation](https://geos-chem.readthedocs.io/en/stable/)
- [GEOS-Chem simulation types](https://wiki.seas.harvard.edu/geos-chem/index.php?title=Guide_to_GEOS-Chem_simulations)
- [GRICAD/CIMENT documentation](https://gricad-doc.univ-grenoble-alpes.fr/en/hpc/)
- [Ige-calcul documentation](https://ige-calcul.github.io/public-docs/docs/index.html)


About
-----

Authors: Ian Hough, Erfan Jahangir

Date: 2026-03-17
