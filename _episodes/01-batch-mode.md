---
title: "Running Stata in Batch Mode"
teaching: 0
exercises: 0
questions:
- "How can .do files make my work more reproducible?"
- "How do I run my or someone else's .do file?"
objectives:
- "Run commands and .do files from the Stata command line."
- "Run .do files from Unix shell or the Windows terminal."
- "Pass parameters from the command line."
- "Determine and change your working directory in Stata."
- "Log your results window."
- "Use interactive dialogs to find the exact syntax of a command."
keypoints:
- "Only use interactive dialogs to find the command you need."
- "Add commands to a .do file."
- "Check what directory you are running .do files from."
- "Run .do files _en bloc_, not by parts." 
- "Always use forward slash `/` in path names."
- "Never abbreviate. Always write out the file extensions."
---

FIXME: overview of interface, like https://datacarpentry.org/genomics-r-intro/fig/rstudio_session_4pane_layout.png 

FIXME: introduce standard stata syntax: `command expression, options`

FIXME: reorder episodes: shell comes later. "save as a script"

How do you find your current working directory? Check the bottom line of the Stata application window, or enter the command `pwd`.

![Two ways of checking your working directory]({{ "/img/pwd.png" | relative_url }})

> ## Backward or forward?
> On a Windows machine, Stata will display your working directory with a backslash (`\`) separating its components, like
> `C:\Users\koren\Dropbox\teaching\courses\2019\carpentries\stata-economics`.
> You should still refer to directories using a forward slash (`/`) to stay compatible with other platforms. The forward slash is understood by all three major platforms, whereas the backslash has a special meaning on Unix and Mac.
{: .callout}

```
cd data
```
{: .source}
```
/Users/koren/Dropbox/teaching/courses/2019/carpentries/stata-economics/data
```
{: .output}

```
ls
```
{: .source}
```
total 537336
-rwxr-xr-x@ 1 koren  staff     785984 Jul 10 15:20 WDICountry-Series.csv*
-rwxr-xr-x@ 1 koren  staff     169534 Jul 10 15:20 WDICountry.csv*
-rwxr-xr-x@ 1 koren  staff  213164145 Jul 10 15:21 WDIData.csv*
-rwxr-xr-x@ 1 koren  staff   49492815 Jul 10 15:21 WDIFootNote.csv*
-rwxr-xr-x@ 1 koren  staff      43570 Jul 10 15:21 WDISeries-Time.csv*
-rwxr-xr-x@ 1 koren  staff    3898578 Jul 10 15:21 WDISeries.csv*
-rw-r--r--@ 1 koren  staff       5673 Jul  2 11:41 average_distance.dta
-rw-r--r--@ 1 koren  staff    1909446 Mar 18  2014 dist_cepii.dta
-rw-r--r--@ 1 koren  staff       4844 Jun 20 19:33 head.csv
-rw-r--r--@ 1 koren  staff      44554 Jul  2 11:46 wdi_decades.dta
```
{: .output}

FIXME: this will look different on a Windows machine

```
cd ..
```
{: .source}
```
/Users/koren/Dropbox/teaching/courses/2019/carpentries/stata-economics
```
{: .output}

> ## Challenge
>
> If your current working directory is `/home/user/dc-economics/data`, which of the following Stata commands can you use to run the .do file at `/home/user/dc-economics/code/read_data.do`?
> 1. `do read_data.do`
> 2. `do ../read_data.do`
> 3. `do ../code/read_data.do`
> 4. `do /home/user/dc-economics/code/read_data.do`
> 5. `cd ../code`
>    `do read_data.do`
>
> > ## Solution
> > 1. No. This looks for `read_data.do` in the current directory, `/home/user/dc-economics/data`.
> > 2. No. This looks for `read_data.do` one level up from the current directory, `/home/user/dc-economics/`.
> > 3. Yes. This looks for `read_data.do` in the `code` folder one level up from the current folder. This is where your .do file is.
> > 4. Yes. You can always use the fully qualified, absolute path to run a .do file. It is, however, not good practice to do so, as the absolute path may be different on a different computer.
> > 5. Yes. This first changes the working directory to `/home/user/dc-economics/code`, the runs `read_data.do` from there.
> {: .solution}
{: .challenge}

```
stata
```
{: .language-bash}
```
  ___  ____  ____  ____  ____ (R)
 /__    /   ____/   /   ____/
___/   /   /___/   /   /___/   15.1   Copyright 1985-2017 StataCorp LLC
  Statistics/Data Analysis            StataCorp
                                      4905 Lakeway Drive
     MP - Parallel Edition            College Station, Texas 77845 USA
                                      800-STATA-PC        http://www.stata.com
                                      979-696-4600        stata@stata.com
                                      979-696-4601 (fax)

Single-user 2-core Stata perpetual license:
       Serial number:  XXXXXXXXXXXX
         Licensed to:  XXXXXXXXXXXX
                       XXXXXXXXXXXX


Notes:
      1.  Unicode is supported; see help unicode_advice.
      2.  More than 2 billion observations are allowed; see help obs_advice.
      3.  Maximum number of variables is set to 5000; see help set_maxvar.

. 
```
{: .output}

```
stata -b display 1234
```
{: .language-bash}
```
```
{: .output}
Nothing happens. Output is stored in `stata.log`.
```
cat stata.log
```
{: .language-bash}
```
  ___  ____  ____  ____  ____ (R)
 /__    /   ____/   /   ____/
___/   /   /___/   /   /___/   15.1   Copyright 1985-2017 StataCorp LLC
  Statistics/Data Analysis            StataCorp
                                      4905 Lakeway Drive
     MP - Parallel Edition            College Station, Texas 77845 USA
                                      800-STATA-PC        http://www.stata.com
                                      979-696-4600        stata@stata.com
                                      979-696-4601 (fax)

Single-user 2-core Stata perpetual license:
       Serial number:  XXXXXXXXXXXX
         Licensed to:  XXXXXXXXXXXX
                       XXXXXXXXXXXX


Notes:
      1.  Stata is running in batch mode.
      2.  Unicode is supported; see help unicode_advice.
      3.  More than 2 billion observations are allowed; see help obs_advice.
      4.  Maximum number of variables is set to 5000; see help set_maxvar.

. display 1234 
1234```
{: .output}

FIXME: this may only work on unix-type machines

> ## Challenge
>
> List three ways of running `read_data.do`.
>
> > ## Solution
> > 1. From Stata: `do /home/user/dc-economics/code/read_data.do`
> > 2. From Stata: `do read_data.do` (if current working directory is `/home/user/dc-economics/code`)
> > 3. From the shell: `stata -b do read_data.do` (if current working directory is `/home/user/dc-economics/code`)
> {: .solution}
{: .challenge}

FIXME: this episode is about HOW to do things, but we do not yet have things to do.

```
* to make sure there are no log files open
capture log close
log using read_data.log, text replace
...
log close
```
{: .source}

> ## Never abbreviate
> A quirky feature of Stata is that it lets you abbreviate everything: commands, variable names, even file names. Abbreviation might save you some typing, but destroys legibility of your code, so please think of your coauthors and your future self and never do it. 
> ```
> u data
> g gdp_per_capita = 1
> ren gdp gdp
> ```
> {: .source}
> means the same as
> ```
> use "data.dta"
> generate gdp_per_capita = 1
> rename gdp_per_capita gdp
> ```
> {: .source}
> but the latter is much more explicit. The built-in editor of Stata 16 offers [tab completion](https://www.stata.com/new-in-stata/do-file-editor-autocompletion/) so you don't even have to type to write out the full command and variable names.
{: .callout}

{% include links.md %}

