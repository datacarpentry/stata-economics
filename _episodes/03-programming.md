---
title: "Effective Programming"
teaching: 0
exercises: 0
questions:
- "How can .do files make my work more reproducible?"
- "How do I run my or someone else's .do file?"
- "Why should I care about code quality?"
- "How do I make my code more legible?"
objectives:
- "Run commands and .do files from the Stata command line."
- "Run .do files from Unix shell or the Windows terminal."
- "Pass parameters from the command line."
- "Log your results window."
- "Create expressive variable names."
- "Write effective code comments."
- "Write code that is easy to read."
- "Use temporary variables, scalars, and files."
- "Understand and use local and global macros."
- "Reuse the results of other commands."
- "Automate repetitive tasks using `foreach` and `forvalues`."
- Use return values of Stata commands.
keypoints:
- "Add commands to a .do file."
- "Run .do files _en bloc_, not by parts." 
- "Check what directory you are running .do files from."
- "Write expressive variable names."
- "Comment the why, not the what."
- "Use for loops to automate anything that happens more than twice."
- "Use `return list` after a command to see what you can reuse."
---
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
1234
```
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

```
* to make sure there are no log files open
capture log close
log using read_data.log, text replace
...
log close
```
{: .source}


> ## Challenge
> Using the `wdi_decades.dta` dataset, calculate the ratio of GDP per capita to the average GDP per capita of that decade.
> > ## Solution
> > ```
> > use "data/wdi_decades.dta", clear
> > tempvar decade_gdp_average
> > egen `decade_gdp_average' = mean(gdp_per_capita), by(decade)
> > generate relative_gdp_per_capita = gdp_per_capita / `decade_gdp_average'
> > ```
> > {: .source}
> > Note the verbose variable names, the use of `egen` and `tempvar`.
> {: .solution}
{: .challenge}


> ## Challenge
> What is the difference between `collapse (mean) average_distance = distw, by(iso_o)` and `egen average_distance = mean(distw), by(iso_o)`?
> > ## Solution
> > Both calculate the average `distw` by origin country code. `collapse` creates a new dataset with one row for each group (origin country code). `egen` keeps the original dataset, its rows and variables, and adds a new variable with the group average.
> {: .solution}
{: .challenge}


{% include links.md %}
