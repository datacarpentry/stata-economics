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
keypoints:
- Use `return list` after a command to see what you can reuse.
---


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
save "data/WDI-select-variables.dta", replace
```
{: .source}


> ## Commenting your code
>  Comments are text included in a do file. The code in this file is commented using `*` or `\\`. Stata will ignore everything that comes after.
> Multiline comments can be made with `/*` which tell Stata to ignore everything until it sees `*/`. Three forward slashes `(///)`
> means that the current command is continued on the next line.
{: .callout}



{% include links.md %}
