---
title: "Advanced Programming Topics"
teaching: 0
exercises: 0
questions:
objectives:
- Define and reuse global macros.
- Understand the scope of local and global macros.
- Divide your work into multiple .do files.
- Use nested macros.
- Use nested loops.
- Reuse the results of other commands.
- Merge update.
- tempfile with append
- "Use temporary variables, scalars, and files."
keypoints:
- Use `return list` after a command to see what you can reuse.
---


## Advanced example of macro evaluation and for loops
```
clear all
import delimited "data/raw/worldbank/WDIData.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear

local merchandise_trade "TG.VAL.TOTL.GD.ZS"
local life_expectancy "SP.DYN.LE00.IN"
local gdp_per_capita "NY.GDP.PCAP.PP.KD"
local population "SP.POP.TOTL" 
local population_density "EN.POP.DNST"

local variables merchandise_trade life_expectancy gdp_per_capita population population_density


tempvar sample_to_keep
gen `sample_to_keep' = 0
foreach var in `variables' {
    replace `sample_to_keep' = 1 if indicatorcode == "``var''"
    * note the double quote. `var' evaluates to merchandise_trade, ``var'' evaluates to `merchandise_trade' = TG.VAL.TOTL.GD.ZS 
}

keep if `sample_to_keep' == 1
// this temporary variable will be deleted once the .do file stops

reshape long v, i(countrycode indicatorcode) j(year)
replace year = year - 5 + 1960
generate str variable_name = ""
foreach var in `variables' {
    replace variable_name = "`var'" if indicatorcode == "``var''"
    * note that the LHS is in single quotes, the RHS in double quotes
}


drop indicatorcode indicatorname
reshape wide v, i(countrycode year) j(variable_name) string
rename v* *
save "data/derived/WDI-select-variables.dta", replace
```
{: .source}


> ## Commenting your code
>  Comments are text included in a do file. The code in this file is commented using `*` or `\\`. Stata will ignore everything that comes after.
> Multiline comments can be made with `/*` which tell Stata to ignore everything until it sees `*/`. Three forward slashes `(///)`
> means that the current command is continued on the next line.
{: .callout}


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
import delimited "data/raw/worldbank/WDICountry.csv", varnames(1) bindquotes(strict) clear
keep countrycode shortname incomegroup
tempfile wdi
save `wdi', replace

use "data/derived/WDI-select-variables.dta", clear
merge m:1 countrycode using `wdi', keep(master match) nogen
```
{: .source}

```
...
reshape wide v, i(countrycode year) j(variable_name) string
tempfile wide_wdi
save `wide_wdi', replace
rename v* *
save "data/derived/WDI-select-variables.dta", replace
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
save "data/derived/WDI-select-variables.dta", replace
restore
* do something else with the wide data
```
{: .source}

```
import delimited "data/raw/worldbank/WDIData.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
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
save "data/derived/WDI-select-variables.dta", replace

```
{: .source}

Many times you may need to type the same commands when and do repetitive tasks in the process of data manipulation. For example, you need to use lines 5-8 in `read_wdi_variables.do` also in another .do. Rather than copy-pasting these lines of code, you can create a new .do named `generate_variable_name.do` which is called from `read_wdi_variables.do` as well as the other .do.

`generate_variable_name.do` will contain the following lines of code

```
generate str variable_name = ""
replace variable_name = "merchandise_trade" if indicatorcode == "TG.VAL.TOTL.GD.ZS"
replace variable_name = "life_expectancy" if indicatorcode == "SP.DYN.LE00.IN"
replace variable_name = "gdp_per_capita" if indicatorcode == "`gdp_per_capita'"
replace variable_name = "population" if indicatorcode == "SP.POP.TOTL" 
replace variable_name = "population_density" if indicatorcode == "EN.POP.DNST"
```

Whereas `read_wdi_variables.do` will look like


```
import delimited "data/raw/worldbank/WDIData.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
keep if inlist(indicatorcode, "TG.VAL.TOTL.GD.ZS", "NY.GDP.PCAP.PP.KD", "SP.POP.TOTL")
reshape long v, i(countrycode indicatorcode) j(year)
replace year = year - 5 + 1960

do code/generate_variable_name.do

drop indicatorcode indicatorname
reshape wide v, i(countrycode year) j(variable_name) string
rename v* *
save "data/derived/WDI-select-variables.dta", replace
```

## Custom programs

It is possible to define custom functions (programs) within `.do` files. This can be used to simplify complex calculations or improve code readability. For example, suppose that we want to create a custom mapping from one variable, then instead of creating multiple lines with `if` conditions, we can create a program that will simplify entry of the mapping.
```
clear all
sysuse auto

program define country_of_origin
	foreach c in `2'{
		display "Country of origin for car make `c' is set to `1'"
		replace dummy_country_of_origin = "`1'" if make=="`c'"
	}
end

* note that since strings contain spaces, they have to be quoted
gen dummy_country_of_origin = ""
country_of_origin "USA" `" "AMC Pacer" "AMC Spirit" "'
country_of_origin "JP" `" "Mazda GLC" "Subaru" "Honda Accord" "Honda Civic" "'
```
{: .source}


{% include links.md %}
