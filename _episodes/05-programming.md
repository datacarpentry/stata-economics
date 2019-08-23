---
title: "Save and Reuse your Work in .do Files"
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
- "Log your results window."
- "Use temporary variables, scalars, and files."
- "Understand and use local and global macros."
keypoints:
- "Add commands to a .do file."
- "Run .do files _en bloc_, not by parts." 
- "Check what directory you are running .do files from."
---

## Running .do files

Save the .do file in the editor as `read_wdi_variables.do`. 

Create a `code` folder inside your project folder `dc-economics` and put it there. 

You can use basic shell commands such as `cd`, `pwd`, `ls` and `mkdir` in Stata. 
```
pwd
mkdir code
```
{: .source}

```
do code/read_wdi_variables.do
```
{: .source}

```
. do code/read_wdi_variables.do

. import delimited "data/WDIData.csv", varnames(1) bindquotes(strict) encoding("ut
> f-8") clear
(64 vars, 422,136 obs)

. keep if inlist(indicatorcode, "TG.VAL.TOTL.GD.ZS", "NY.GDP.PCAP.PP.KD", "SP.POP.
> TOTL")
(421,344 observations deleted)

. reshape long v, i(countrycode indicatorcode) j(year)
(note: j = 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 3
> 0 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 
> 57 58 59 60 61 62 63 64)

Data                               wide   ->   long
-----------------------------------------------------------------------------
Number of obs.                      792   ->   47520
Number of variables                  64   ->       6
j variable (60 values)                    ->   year
xij variables:
                          v5 v6 ... v64   ->   v
-----------------------------------------------------------------------------

. replace year = year - 5 + 1960
variable year was byte now int
(47,520 real changes made)

. generate str variable_name = ""
(47,520 missing values generated)

. replace variable_name = "merchandise_trade" if indicatorcode == "TG.VAL.TOTL.GD.
> ZS"
variable variable_name was str1 now str17
(15,840 real changes made)

. replace variable_name = "gdp_per_capita" if indicatorcode == "NY.GDP.PCAP.PP.KD"
(15,840 real changes made)

. replace variable_name = "population" if indicatorcode == "SP.POP.TOTL" 
(15,840 real changes made)

. drop indicatorcode indicatorname

. reshape wide v, i(countrycode year) j(variable_name) string
(note: j = gdp_per_capita merchandise_trade population)

Data                               long   ->   wide
-----------------------------------------------------------------------------
Number of obs.                    47520   ->   15840
Number of variables                   5   ->       6
j variable (3 values)     variable_name   ->   (dropped)
xij variables:
                                      v   ->   vgdp_per_capita vmerchandise_trade 
> vpopulation
-----------------------------------------------------------------------------

. rename v* *

. save "data/WDI-select-variables.dta"
file data/WDI-select-variables.dta saved

. 
end of do-file
```
{: .output}

The .do file is executed line by line and we see its output as Stata executes. Run it again.

```
...

. save "data/WDI-select-variables.dta"
file data/WDI-select-variables.dta already exists
r(602);

end of do-file

r(602);
```
{: .error}

As in [Episode 3]({{ "/03-transform-data/" | relative_url }}), Stata lets us know that the file already exists and is unwilling to replace it. As we are using a .do file to create this file, it is totally safe to overwrite. If we make an error, we can fix it and rerun `do code/read_wdi_variables.do`. That is the whole point of .do files; to make your work more reproducible.

> # Exercise
> Change the last line of the .do file to `save "data/WDI-select-variables.dta", replace` and rerun it.
{: .challenge}

> # Never execute just part of a .do file
> ![Never do this]({{ "/img/not-by-part.png" | relative_url }}) 
> The .do file editor lets you execute selected lines from your .do file. Never do this. You will not know what state your data is in before clicking that button and you may forget to execute the rest of your .do file. For example, you may omit a crucial `save` command and your data will be lost. Always execute your .do file in its entirety from the command line by running `do code/read_wdi_variables.do`.
> 
> If you are tempted to run your .do file by parts, it is a good indication that it is too long. Try breaking it up into multiple .do files.
{: .callout}

> ## Challenge
>
> If your current working directory is `/home/user/dc-economics/data`, which of the following Stata commands can you use to run the .do file at `/home/user/dc-economics/code/read_wdi_variables.do`?
> 1. `do read_wdi_variables.do`
> 2. `do ../read_wdi_variables.do`
> 3. `do ../code/read_wdi_variables.do`
> 4. `do /home/user/dc-economics/code/read_wdi_variables.do`
> 5. `cd ../code`
>    `do read_wdi_variables.do`
>
> > ## Solution
> > 1. No. This looks for `read_wdi_variables.do` in the current directory, `/home/user/dc-economics/data`.
> > 2. No. This looks for `read_wdi_variables.do` one level up from the current directory, `/home/user/dc-economics/`.
> > 3. Yes. This looks for `read_wdi_variables.do` in the `code` folder one level up from the current folder. This is where your .do file is.
> > 4. Yes. You can always use the fully qualified, absolute path to run a .do file. It is, however, not good practice to do so, as the absolute path may be different on a different computer.
> > 5. Yes. This first changes the working directory to `/home/user/dc-economics/code`, the runs `read_wdi_variables.do` from there.
> {: .solution}
{: .challenge}

There are relative paths in `read_wdi_variables.do`, so it matters which working directory it runs from.

Your .do file begins with loading a dataset and ends with saving one. It leaves no other trace.

> ## House rules for code and data to live happily together
> Always assume that mistakes will happen and you should be prepared to minimize them. 
> 1. Never modify the raw data files. Save the results of your data cleaning in a new file.
> 2. Every data file is created by a script. Convert your interactive data cleaning session to a .do file.
> 3. No data file is modified by multiple scripts.
> 4. Intermediate steps are saved in different files (or kept in temporary files) than the final dataset.
> 
> The goal of these rules is that you can unambiguously answer the question "how was this data file created?" You will pose this question countless times even if you work by yourself. 
>
> Under these rules, most of your .do files will begin with `use ..., clear` and end with `save ..., replace`. You have automated your work and should not be afraid to use the options `clear` and `replace`. You will also use "destructive" commands like `keep`, `drop`, `collapse` and `reshape` more freely.
{: .discussion}

> ## Challenge
> What is wrong with the following .do file?
> ```
> ...
> reshape wide v, i(countrycode year) j(variable_name) string
> save "data/WDI-select-variables.dta", replace
> rename v* *
> save "data/WDI-select-variables.dta", replace
> ```
> {: .error}
> > ## Solution
> > There is no error in the .do file but it save two different versions of `WDI-select-variables.dta` under the same name. You cannot be sure which version the data file has. For example, if the command `rename v* *` fails with an error, the .dta file will contain the variable names `vgdp_per_capita` etc, and you will be surprised.
> {: .solution}
{: .challenge}

Running .do files from the command line.

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

```
$ stata -e do code/read_wdi_variables.do
$ cat read_wdi_variables.log

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
       Serial number:  501506203290
         Licensed to:  Miklos Koren
                       CEU MicroData

Notes:
      1.  Stata is running in batch mode.
      2.  Unicode is supported; see help unicode_advice.
      3.  More than 2 billion observations are allowed; see help obs_advice.
      4.  Maximum number of variables is set to 5000; see help set_maxvar.

. do code/read_wdi_variables.do 

. import delimited "data/WDIData.csv", varnames(1) bindquotes(strict) encoding(
> "utf-8") clear
(64 vars, 422,136 obs)

. keep if inlist(indicatorcode, "TG.VAL.TOTL.GD.ZS", "NY.GDP.PCAP.PP.KD", "SP.P
> OP.TOTL")
(421,344 observations deleted)

. reshape long v, i(countrycode indicatorcode) j(year)
(note: j = 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 2
> 9 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 
> 55 56 57 58 59 60 61 62 63 64)

Data                               wide   ->   long
-----------------------------------------------------------------------------
Number of obs.                      792   ->   47520
Number of variables                  64   ->       6
j variable (60 values)                    ->   year
xij variables:
                          v5 v6 ... v64   ->   v
-----------------------------------------------------------------------------

. replace year = year - 5 + 1960
variable year was byte now int
(47,520 real changes made)

. generate str variable_name = ""
(47,520 missing values generated)

. replace variable_name = "merchandise_trade" if indicatorcode == "TG.VAL.TOTL.
> GD.ZS"
variable variable_name was str1 now str17
(15,840 real changes made)

. replace variable_name = "gdp_per_capita" if indicatorcode == "NY.GDP.PCAP.PP.
> KD"
(15,840 real changes made)

. replace variable_name = "population" if indicatorcode == "SP.POP.TOTL" 
(15,840 real changes made)

. drop indicatorcode indicatorname

. reshape wide v, i(countrycode year) j(variable_name) string
(note: j = gdp_per_capita merchandise_trade population)

Data                               long   ->   wide
-----------------------------------------------------------------------------
Number of obs.                    47520   ->   15840
Number of variables                   5   ->       6
j variable (3 values)     variable_name   ->   (dropped)
xij variables:
                                      v   ->   vgdp_per_capita vmerchandise_tra
> de vpopulation
-----------------------------------------------------------------------------

. rename v* *

. save "data/WDI-select-variables.dta", replace
file data/WDI-select-variables.dta saved

. 
end of do-file
```
{: language-bash}

The option -b will produce a ASCII log file saved in your current working directory. If you prefer a SMCL log you should use the -s option instead.
If you want Stata to automatically exit after running the batch do-file, use -e. This last option becomes handy in case of an executable.
If you don't declare any options, Stata will run in your terminal.

The name of the .log file is always the same as your .do file; you cannot change it. Hence `stata -e do code/read_wdi_variables.do` will create `read_wdi_variables.log` in the folder from which it is run.

You can log in your own preferred file usig the `log` command from whithin your .do file.
```
log using read_data.log, text replace
* do stuff that will be logged
log close
```
{: .source}

> ## Challenge
>
> List three ways of running `read_wdi_variables.do`.
>
> > ## Solution
> > 1. From Stata: `do /home/user/dc-economics/code/read_wdi_variables.do`
> > 2. From Stata: `do read_wdi_variables.do` (if current working directory is `/home/user/dc-economics/code`)
> > 3. From the shell: `stata -e do read_wdi_variables.do` (if current working directory is `/home/user/dc-economics/code`)
> {: .solution}
{: .challenge}

## Scalars and macros

Macros are useful for storing values and reusing them later. They are the most powerful feature of Stata programming.

There are two types of macros, local and global.  Local macros are valid only in a single
execution of commands in do-files.  Global macros will persist until you delete them or the session is ended.
We recommend the use of local macros and this is what we cover first.

```
. use "data/WDI-select-variables.dta", clear
. local begin_year 1991
. local name value
. display `begin_year'
1991
. display "`name'"
value
```
{: .output}

Use backticks and single quote to evaluate a macro "name" to its "value."

```
. display `begin_year`
`begin_year` invalid name
r(198);

. display 'begin_year'
'begin_year' invalid name
r(198);

```
{: .error}

Macros are evaluated as part of the command. They are not a variable.

```
. local name value
. display `name'
value not found
r(111);
```
{: .error}

The second line evaluates to `display value` and Stata does not have any object called "value."

Because macros are evaluated before a command is run, they can part of the command.
```
. local begin_year 1991
. local outcome gdp_per_capita 
. summarize `outcome' if year >= `begin_year'

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |      6,251    15331.78    17967.28   354.2845   135318.8

. summarize gdp_per_capita if year >= 1991

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |      6,251    15331.78    17967.28   354.2845   135318.8

```
{: .output}

The last two lines do exactly the same.

The macro can be any part of the command, you can attach it to variable names, for example.

```
. local entity country

. describe `entity'code

              storage   display    value
variable name   type    format     label      variable label
----------------------------------------------------------------------------------
countrycode     str3    %9s                   Country Code

. describe `entity'name

              storage   display    value
variable name   type    format     label      variable label
----------------------------------------------------------------------------------
countryname     str52   %52s                  Country Name

```
{: .output}

> ## Gotcha
> Stata does not stop if you use an undefined macro name. It simply uses an empty string for its value. Watch out for typos in macro names!
> ```
> . describe `enty'name
> variable name not found
> r(111);
> ```
> {: .error}
{: .callout}

> ## Challenge
> What does the following code do?
> ```
> local A a
> local B 4
> generate `A' = `B'
> ```
> {: .source}
> 1. Creates a variable called `A` with the value 4.
> 2. Creates a variable called `a` with the value 4.
> 3. Creates a variables called `A` with the value "B".
> 4. Creates a variables called `a` with the value "B".
>
> > ## Solution
> > The correct is 2.
> {: .solution}
{: .challenge}

> ## Challenge
> After running the previous code, what does the following code do?
> ```
> local C c
> generate `C' = `A' + `B'
> ```
> {: .source}
> 1. Creates a variable called `c` with the value 4.
> 2. Creates a variable called `c` with the value "AB".
> 3. Creates a variables called `C` with the value 8.
> 4. Creates a variables called `c` with the value 8.
>
> > ## Solution
> > The correct is 4. XXXXX ``A'`` evaluates to `a`, which is a variable with the value 4. ```B'`` evaluates to 4, so the variable `c` becomes 8.
> {: .solution}
{: .challenge}


```
use "data/WDI-select-variables.dta", clear
local begin_year 1991
local end_year 2010
keep if (year >= `begin_year') & (year <= `end_year') 
```
{: .source}

> ## Challenge
>
> Create an index of GDP per capita for each country in each year, relative to a base year set in the local macro `base_year`. This index should take the value 100 in the base year.
>
> > ## Solution
> > ```
> > egen gdp_per_capita_`base_year' = mean(cond(year == `base_year', gdp_per_capita, .)), by(countrycode)
> > generate gdp_per_capita_index = gdp_per_capita / gdp_per_capita_`base_year' * 100
> > ```
> > {: .source}
> {: .solution}
{: .challenge}



## Temporary variables and files

FIXME: move to advance

```
. local base_year 1991
. tempvar base_value
. egen `base_value' = mean(cond(year == `base_year', gdp_per_capita, .)), by(countrycode)
(1100 missing values generated)

. summarize `base_value'

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    __000000 |      4,180    11528.92    14240.77   387.0233   105171.4

. generate gdp_per_capita_index = gdp_per_capita / `base_value' * 100
(1,100 missing values generated)

```
{: .output}

`base_value` is a macro containing a uniquely generate variable name that can be used as a name for a temporary variable. The variable is not created, you have to do it yourself with `generate` or `egen`. Once your .do file concludes, the temporary variable is dropped.

FIXME: add tempvar to a do file to get the most value


Because Stata keeps only one dataset at a time in memory, you may need to save and load datasets frequently. Not all of these datasets will be needed later and you should not clutter your project folder.

Merge names of countries and the income group classification from `WDICountry.csv`.

```
import delimited "data/WDICountry.csv", varnames(1) bindquotes(strict) clear
keep countrycode shortname incomegroup
tempfile wdi
save `wdi', replace

use "data/WDI-select-variables.dta", clear
merge m:1 countrycode using `wdi', keep(master match) nogen
```
{: .source}

```
...
reshape wide v, i(countrycode year) j(variable_name) string
tempfile wide_wdi
save `wide_wdi', replace
rename v* *
save "data/WDI-select-variables.dta", replace
use `wide_wdi', clear
* do something else with the wide data
```
{: .source}

There are two dedicated Stata commands to put aside a dataset in memory and reuse it later: `preserve` and `restore`.

```
...
reshape wide v, i(countrycode year) j(variable_name) string
preserve
rename v* *
save "data/WDI-select-variables.dta", replace
restore
* do something else with the wide data
```
{: .source}

```
import delimited "data/WDIData.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
local gdp_per_capita "NY.GDP.PCAP.PP.KD"
keep if inlist(indicatorcode, "TG.VAL.TOTL.GD.ZS", "SP.DYN.LE00.IN", "`gdp_per_capita'", "SP.POP.TOTL", "EN.POP.DNST")
reshape long v, i(countrycode indicatorcode) j(year)
replace year = year - 5 + 1960
generate str variable_name = ""
replace variable_name = "merchandise_trade" if indicatorcode == "TG.VAL.TOTL.GD.ZS"
replace variable_name = "life_expectancy" if indicatorcode == "SP.DYN.LE00.IN"
replace variable_name = "gdp_per_capita" if indicatorcode == "`gdp_per_capita'"
replace variable_name = "population" if indicatorcode == "SP.POP.TOTL" 
replace variable_name = "population_density" if indicatorcode == "EN.POP.DNST"
drop indicatorcode indicatorname
reshape wide v, i(countrycode year) j(variable_name) string
rename v* *
save "data/WDI-select-variables.dta", replace
```
{: .source}

{% include links.md %}
