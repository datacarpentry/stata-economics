---
title: Setup
---

## Install Stata

This lesson uses the statistical package [Stata](https://www.stata.com/products/)[™](license.html). It has been tested on Stata 15.1 MultiProcessor, but it should work on most recent versions. If you do not have a Stata license, please let your instructor know so that they can request a [short-term training license](https://www.stata.com/customer-service/course-short-term-license/) for free.

### Windows
Step-by-step installation on Windows:
- Go to https://download.stata.com/download/
- Log in using your username and password
- Click on your OS (64-bit Windows)
- Download and launch the installer.
- Once the installation is done, start Stata from the Start Menu. The first time you do this, you will have to activate your licence.
- Enter the serial number provided and press enter
- Enter the code and press enter
- Enter the authorization and press enter
- It should return "Good.  The serial number, code, and authorization make sense. Shall we continue?" Type Y and press enter.
- When it asks for the first line, it should say "European Economic Association"
- When it asks for the second line, it should say "Manchester, UK"
- It will ask for confirmation. Type "Y" and press enter.

### Linux
Step-by-step installation on Linux:
- Go to https://download.stata.com/download/
- Log in using your username and password
- Click on your OS (64-bit Linux)
- Download `Stata15Linux64.tar.gz`.
- Open a terminal and navigate to the directory where your downloaded file is located (e.g. `cd ~/Downloads/`)
- Get superuser rights (`sudo su`)
- Create a new directory (e.g. `mkdir stata_install`)
- Move the downloaded file to this new directory (`mv Stata15Linux64.tar.gz. stata_install/`)
- Enter the directory (`cd stata_install`)
- Extract the installation files using `tar xzf Stata15Linux64.tar.gz`
- Create a directory for your stata installation (`mkdir /usr/local/stata15`)
- Navigate to the stata directory (`cd /usr/local/stata15`)
- Start the installation by executing the extracted install file (e.g. `/home/username/Downloads/stata_install/install`)
- Whenever the installer asks if you want to proceed type "y" and press enter
- Once the installation is done, type `./stinit` to activate your licence
- Whenever it asks you if you want to continue, type "Y" and press enter
- Enter the serial number provided and press enter
- Enter the code and press enter
- Enter the authorization and press enter
- It should return "Good.  The serial number, code, and authorization make sense. Shall we continue?" Type Y and press enter.
- When it asks for the first line, it should say "European Economic Association"
- When it asks for the second line, it should say "Manchester, UK"
- It will ask for confirmation. Type "Y" and press enter.
- Try to start stata by `./xstata`. If it gives you the following error message (`./stata: error while loading shared libraries: libpng12.so.0: cannot open shared object file: No such file or directory`), continue with the steps below:

- Issue the following commands one by one in your terminal window:
```
apt-get install zlib1g-dev
wget http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb
dpkg -i libpng12-0_1.2.54-1ubuntu1_amd64.deb
```

### Mac
Step-by-step installation on Mac:
- Go to https://download.stata.com/download/
- Log in using your username and password
- Click on your OS (Mac)
- Download and launch the installer.
- Once the installation is done, start Stata from the Start Menu. The first time you do this, you will have to activate your licence.
- Enter the serial number provided and press enter
- Enter the code and press enter
- Enter the authorization and press enter
- It should return "Good.  The serial number, code, and authorization make sense. Shall we continue?" Type Y and press enter.
- When it asks for the first line, it should say "European Economic Association"
- When it asks for the second line, it should say "Manchester, UK"
- It will ask for confirmation. Type "Y" and press enter.


## Add Stata to the path so that `stata` can be called from the command line

### Windows

Add executable folders to Windows 10 system environment variables path: 

1. Open the Start Search, type in "env", and choose "Edit the system environment variables".
2. On the Advanced tab click on the "Environment Variables..." button.
3. Under the "System Variables" section, find the row with "Path" in the first column, and click edit. 
The "Edit environment variable" UI will appear. 
4. Here, you can click "New" and type in the new path you want to add. 
C:\Program Files (x86)\Stata15\
5. Click OK till you exit from the system properties.

After you did these steps Windows will search for executable(.exe) files in this folder.

Your path could be different if you installed Stata to an other folder.
Your Stata version could be different if you have an other edition of Stata. 
For example you might have a single edition Stata which exe file's name is: StataSE-64.exe

Install and adjust Git Bash for Windows. 

1. Install Git for Windows (The Bash Shell) by the help of the Carpentries workshop template: 

http://carpentries.github.io/workshop-template/

You can also find a video tutorial on this page. 

2. Run the Git Bash program. 
3. Into Bash command line write `nano .bashrc`. 
4. Inside the empty file write `alias stata='StataMP-64.exe'`.
5. Press Ctrl+O then press enter to write out the file. Press Ctrl+X to exit from .bashrc. 
6. You can check with `pwd` where are you know and where is your .bashrc file located. 
7. When you rerun the Git Bash program and type `stata` the program will start automatically. 

With these steps we created a file where you can adjust your bash settings and also replaced the alias of Stata's executable. 

### Mac

If Stata is installed in /Applications/Stata/ the path to the Stata executable is `/Applications/Stata/StataSE.app/Contents/MacOS/` for Stata Special Edition and `/Applications/Stata/StataMP.app/Contents/MacOS/` for Stata MultiProcessing. 

 To add StataSE to the path you should open the terminal and type
 
`sudo vi /etc/paths`

and add `/Applications/Stata/StataSE.app/Contents/MacOS/` to it. 

Finally, close the terminal and reopen it. Once everything is set up, type `stata` in your terminal to launch Stata.

### Linux

## Download the workshop data
1. Download the [data package](https://zenodo.org/record/3375649/files/dc-economics-data.zip?download=1) from Zenodo.
2. Create a new directory you are going to use at the workshop.
3. Unzip the .zip file into this directory. You should see the files, `LICENSE.md` and `README.md`, as well as directories `data` and `doc`. 

{% include links.md %}
