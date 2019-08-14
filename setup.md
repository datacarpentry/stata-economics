---
title: Setup
---
This lesson uses the statistical package [Stata](https://www.stata.com/products/)[™](license.html). It has been tested on Stata 14.2 MultiProcessor, but it should work on most recent versions. If you do not have a Stata license, please let your instructor know so that they can request a [short-term training license](https://www.stata.com/customer-service/course-short-term-license/) for free.

Download the [data repository](https://github.com/korenmiklos/dc-economics-data). (FIXME: create a figshare repository)

FIXME: create a data folder with the data repository.

FIXME: add Stata to the path so that `stata` can be called from the command line

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

## Data resources
### Explicit open license
- https://datahub.io/core
- https://github.com/AidData-WM/public_datasets/
- https://data.worldbank.org/
- https://opentender.eu/de/download
- https://offeneregister.de/#download
- http://www.macrohistory.net/data/

### Needs work on licensing
- http://www.cepii.fr/CEPII/en/bdd_modele/presentation.asp?id=6
- https://www.nber.org/data/

- http://opendatahandbook.org/

{% include links.md %}
