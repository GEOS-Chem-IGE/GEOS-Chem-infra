# Running Geos-chem on the IGE Calcul server

## Connecting through SSH key 
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
## Geos-chem settup 
This will contain the same explanations used for Dahu, with some modifications, especially for the input and output data in the scratch part of the summer shared storage.
