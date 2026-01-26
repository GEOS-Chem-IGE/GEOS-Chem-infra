# Running Geos-chem on the IGE Calcul server

To run GEOS-Chem on ige-calcul, you must first have an agalan account. Once you have registered, a directory will be created for you at ```
/workdir/chianti/``` using your surname and the first letter of your first name. This is the location where you should clone the actuel Git reposetory."

### Git clone into you repertory
### Create rundir 
You must execute createRunDir.sh redirecting into its parent directory
```bash
cd /workdir/chianti/<your-username>/<gcclassic-dir>/run
./createRunDir.sh
```
#### Only for the first time run
By running this command, If this is the first time you have created a run directory, you will be prompted to enter the path to the `ExtData` directory that contains input data for GEOS-Chem (meteorology, emissions, etc.). Enter 
```bash
/mnt/summer/geoschem/COMMON/ExtData
```

You will then be asked to provide an email, your name and research affiliation, and a brief description of what you plan to do with Geos-Chem.

#### Normal run

You will be then inquired about the simulation type, grid resolution, meteorology source, and number of vertical levels. For each question you can write the number of option you desire to choose. e.g.
for meteorolgy source:
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
when you write 1 it will choose the firest option--> MERRA-2.

Finally you will be asked about where you want to store your run directory which sould be :
```bash
/workdir2/chianti/<your-username>/<rundir name>
```
For the rundir name if you put nothing the default name will be ```<resolution><meteorological data><simulation type>``` for example "gc_4x5_merra2_fullchem".
>[!Note]  
>If you enter a wrong directory you will be asked the following question: 
```bash
Warning: <your wrong directory> does not exist,
but the parent directory does.
Would you like to make this directory? (y/n/q) 
```
Do not answer yes, because this may disrupt the file orginsation on ige-calcuel. 


### Build and run
Copy the job script templates from GEOS-Chem-infra/run/ige-calcul/build.run




### The output Data
The outputs will be saved on your workdir space. It is recommamnded that you add a readme of your project in this directory. 
### Requesting a Slurm account
You must require the ige-caclul admins to create you a slurm account to be able to run the jobscripts via the slurm on ige-calcul servers. 
### Build the executables 
Copy the job script templates:

```bash
cp -iv /home/PROJECTS/pr-geoschem/geos-chem-setup/jobscripts/*.sh .
```
Head trough your build directory in : 
```bash
/workdir2/chianti/<your-username>/
```

# Connecting through SSH key 
An SSH key is a kind of a login system used to securely authenticate you when connecting to remote system. In order to access this repository, you need to set up an SSH key in your _ige-calcul1_ account and put it on GitHub. To do so, open your terminal and run the following command:
```
ssh your_agalan_login@ige-calcul1.u-ga.fr
```
 Replace _your_agalan_login_ with your Agalan username .

With the `ssh-keygen` command, you can create a public and a private SSH key.  

To verify that they have been created, check your `~/.ssh` directory by running:  

```
ls ~/.ssh
```
You should see two files: _id_rsa_ and _id_rsa.pub_.

The private key is stored in `id_rsa` (keep this secret, never share it).

The public key is stored in `id_rsa.pub`. This is the key you will add to GitHub.

To display the contents of your public key, run:
```
cat ~/.ssh/id_rsa.pub
```
Copy the entire text shown (it usually begins with `ssh-rsa` and ends with `your username@ige-calcul1`).

Then, add this public key to GitHub by following the steps described below.

1- Go to your profile (top right) and select Settings.

2- In the left sidebar, click SSH and GPG keys.

3- In the top-right corner, click the green button New SSH key.

4- Paste your public SSH key into the field provided.

5- Click Add SSH key to save.
