---
title: "Effective Programming"
teaching: 0
exercises: 0
questions:
objectives:
- Define and reuse global macros.
- Use nested macros.
- Use nested loops.
- Reuse the results of other commands.
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
