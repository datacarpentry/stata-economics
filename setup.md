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

After you did these steps Windows will search for executable(exe) files in this folder.
From the Command Prompt(cmd) you could run the StataMP-64.exe if you type: StataMP-64.  

Your path could be different if you installed Stata to an other folder.
Your Stata version could be different if you have an other edition of Stata. 
For example you might have a single edition Stata which exe file's name is: StataSE-64.exe

Temporary DOSKEY in Windows OS:

What is an "alias" in Linux OS is "doskey" in Windows OS.
You can temporary replace a name of an exe inside cmd:

```
DOSKEY stata=StataMP-64.exe $*
```
: .source}

This step already requires that you saved your Stata exe path in the system environment variables.

Permanent DOSKEY in Windows 10 OS:

If you don't want to type in DOSKEY every time you run CMD you can make a permanent version of your aliases.

1. Create an empty .cmd file for your DOSKEY commands. FE: "C:\Programs\aliases.cmd"
HINT: You can make a txt file and replace the file extraction to .cmd
2. Open the Start Search, type in "reg", and choose Registy Editor.
3. Run regedit and go to HKEY_CURRENT_USER\Software\Microsoft\Command Processor
4. Add String Value entry with the name AutoRun and the full path of your .cmd file. 
FE: C:\Program Files (x86)\Stata15\
5. From now on you can add paths, doskeys to your aliases.cmd file. 
This AutoRun file will always execute when you start cmd. 

```
@echo off

:: Temporary system path at cmd startup

SET PATH=%PATH%;"C:\Program Files (x86)\Stata15\"

:: Add to path by command

DOSKEY stata=StataMP-64.exe $*
```
{: .source}

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
