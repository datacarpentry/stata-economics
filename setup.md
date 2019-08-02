---
title: Setup
---
This lesson uses the statistical package [Stata](https://www.stata.com/products/)[™](license.html). It has been tested on Stata 14.2 MultiProcessor, but it should work on most recent versions. If you do not have a Stata license, please let your instructor know so that they can request a [short-term training license](https://www.stata.com/customer-service/course-short-term-license/) for free.

Download the [data repository](https://github.com/korenmiklos/dc-economics-data). (FIXME: create a figshare repository)

FIXME: create a data folder with the data repository.

### Add Stata to the path so that `stata` can be called from the command line (Mac)

If Stata is installed in /Applications/Stata/ the path to the Stata executable is 

/Applications/Stata/StataSE.app/Contents/MacOS/ for StataSE 

and
 /Applications/Stata/StataMP.app/Contents/MacOS/ for StataMP. 

 
To add StataMP to the path you should open the terminal and type
 
$ sudo vi /etc/paths 

and add /Applications/Stata/StataSE.app/Contents/MacOS/ to it. 

Finally, close the terminal and reopen it. Once everything is set up, type Stata in your terminal to launch Stata.


FIXME: Add Stata to the path so that `stata` can be called from the command line (For Windows)


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
