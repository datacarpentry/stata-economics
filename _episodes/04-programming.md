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
. do code/read_wdi_variables.do

. import delimited "data/WDIData.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
(64 vars, 422,136 obs)

. keep if inlist(indicatorcode, "TG.VAL.TOTL.GD.ZS", "SP.DYN.LE00.IN", "NY.GDP.PCAP.PP.KD", "
> SP.POP.TOTL", "EN.POP.DNST")
(420,816 observations deleted)

. reshape long v, i(countrycode indicatorcode) j(year)
(note: j = 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 
> 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 6
> 4)

Data                               wide   ->   long
-----------------------------------------------------------------------------
Number of obs.                     1320   ->   79200
Number of variables                  64   ->       6
j variable (60 values)                    ->   year
xij variables:
                          v5 v6 ... v64   ->   v
-----------------------------------------------------------------------------

. replace year = year - 5 + 1960
variable year was byte now int
(79,200 real changes made)

. generate str variable_name = ""
(79,200 missing values generated)

. replace variable_name = "merchandise_trade" if indicatorcode == "TG.VAL.TOTL.GD.ZS"
variable variable_name was str1 now str17
(15,840 real changes made)

. replace variable_name = "life_expectancy" if indicatorcode == "SP.DYN.LE00.IN"
(15,840 real changes made)

. replace variable_name = "gdp_per_capita" if indicatorcode == "NY.GDP.PCAP.PP.KD"
(15,840 real changes made)

. replace variable_name = "population" if indicatorcode == "SP.POP.TOTL" 
(15,840 real changes made)

. replace variable_name = "population_density" if indicatorcode == "EN.POP.DNST"
variable variable_name was str17 now str18
(15,840 real changes made)

. drop indicatorcode indicatorname

. reshape wide v, i(countrycode year) j(variable_name) string
(note: j = gdp_per_capita life_expectancy merchandise_trade population population_density)

Data                               long   ->   wide
-----------------------------------------------------------------------------
Number of obs.                    79200   ->   15840
Number of variables                   5   ->       8
j variable (5 values)     variable_name   ->   (dropped)
xij variables:
                                      v   ->   vgdp_per_capita vlife_expectancy ... vpopulati
> on_density
-----------------------------------------------------------------------------

. rename v* *

. save "data/WDI-select-variables.dta", replace
file data/WDI-select-variables.dta saved

. 
end of do-file
```
{: .output}


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
{: .callout}

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

FIXME: this may only work on unix-type machines. check with git-bash

```
stata -b do code/read_wdi_variables.do
```
{: language-bash}

> ## Challenge
>
> List three ways of running `read_data.do`.
>
> > ## Solution
> > 1. From Stata: `do /home/user/dc-economics/code/read_wdi_variables.do`
> > 2. From Stata: `do read_wdi_variables.do` (if current working directory is `/home/user/dc-economics/code`)
> > 3. From the shell: `stata -b do read_wdi_variables.do` (if current working directory is `/home/user/dc-economics/code`)
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

## Scalars and macros

```
use "data/WDI-select-variables.dta", clear
scalar begin_year = 1991
scalar end_year = 2010
keep if (year >= begin_year) & (year <= end_year) 
```
{: .source}

```
use "data/WDI-select-variables.dta", clear
local begin_year 1991
local end_year 2010
keep if (year >= `begin_year') & (year <= `end_year') 
```
{: .source}


```
generate gdp_per_capita_1991 = cond(year == 1991, gdp_per_capita, .)
egen mean_gdp_per_capita_1991 = mean(gdp_per_capita_1991), by(countrycode)
browse countrycode year gdp_per_capita gdp_per_capita_1991 mean_gdp_per_capita_1991 
```
{: .source}

![The egen-mean-cond pattern]({{ "/img/egen-mean-cond.png" | relative_url }})

```
egen gdp_per_capita_1991 = mean(cond(year == 1991, gdp_per_capita, .)), by(countrycode)  
```
{: .source}


```
local begin_year 1991
egen gdp_per_capita_`begin_year' = mean(cond(year == `begin_year', gdp_per_capita, .)), by(countrycode)  
```
{: .source}

You can only use a macro in this situation, not a scalar.

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

GOTCHA: undefined macros evaluate as empty strings


## Temporary variables and files

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
keep if inlist(indicatorcode, "TG.VAL.TOTL.GD.ZS", "SP.DYN.LE00.IN", `gdp_per_capita', "SP.POP.TOTL", "EN.POP.DNST")
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

## For loops

Repeat the creation of index variable for population.

```
local base_year 1991
egen gdp_per_capita_`base_year' = mean(cond(year == `base_year', gdp_per_capita, .)), by(countrycode)
generate gdp_per_capita_index = gdp_per_capita / gdp_per_capita_`base_year' * 100
egen population_`base_year' = mean(cond(year == `base_year', population, .)), by(countrycode)
generate population_index = population / gdp_per_capita_`base_year' * 100
```
{: .error}

Copying and pasting are prone to errors. Not all will be easy to spot and fix.

```
foreach X of varlist gdp_per_capita population {
    egen `X'_`base_year' = mean(cond(year == `base_year', `X', .)), by(countrycode)
    generate `X'_index = `X' / `X'_`base_year' * 100
}
```
{: .source}

Use for loops to ensure consistency and to minimize the risk the erros, not to save typing. Note that X appears on both sides. It is a macro that is evaluated before the command is run, so it can become part of the variable name.

```
foreach X of varlist *_index {
    generate log_`X' = log(`X' / 100)
}
```
{: .source}

You can reuse the loop variable later in different loops. Note the use of variable name wildcards.

## Advanced example of macro evaluation and for loops
```
clear all
import delimited "data/WDIData.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear

local merchandise_trade "TG.VAL.TOTL.GD.ZS"
local life_expectancy "SP.DYN.LE00.IN"
local gdp_per_capita "NY.GDP.PCAP.PP.KD"
local population "SP.POP.TOTL" 
local population_density "EN.POP.DNST"

local variables merchandise_trade life_expectancy gdp_per_capita population population_density


tempvar sample_to_keep
gen `sample_to_keep' = 0
foreach X in `variables' {
    replace `sample_to_keep' = 1 if indicatorcode == "``X''"
    * note the double quote. `X' evaluates to merchandise_trade, ``X'' evaluates to `merchandise_trade' = TG.VAL.TOTL.GD.ZS 
}
keep if `sample_to_keep' == 1
* this temporary variable will be deleted once the .do file stops

reshape long v, i(countrycode indicatorcode) j(year)
replace year = year - 5 + 1960
generate str variable_name = ""
foreach X in `variables' {
    replace variable_name = "`X'" if indicatorcode == "``X''"
    * note that the LHS is in single quotes, the RHS in double quotes
}

drop indicatorcode indicatorname
reshape wide v, i(countrycode year) j(variable_name) string
rename v* *
save "data/WDI-select-variables.dta", replace
```
{: .source}


{% include links.md %}
