---
title: "Transforming Data"
teaching: 0
exercises: 0
questions:
- "What is tidy data?"
- "How do I transfrom the data to the shape I need?"
objectives:
- "Filter the rows and columns of your data using `drop` and `keep`."
- "Change the way your data is organized using reshaping."
- "Aggregate your data using `collapse`."
- "Calculate group statistics using `egen`."
- "Merge two different datasets using unique keys."
keypoints:
- "Drop unnessecary variables freely."
- "Create tidy data before merging."
---

The WDI dataset you loaded in the previous episode has a strange shape. Variables are in separate rows, whereas years are in separate columns. This is the opposite of "[tidy data](http://dx.doi.org/10.18637/jss.v059.i10)," where each variable has its own column, and different observations such as different years are in separate rows. We will reshape the data in the tidy format.

We first read metadata from `data/WDISeries.csv`. This file contains the indicator codes and long descriptions. 

We will need the variables "Merchandise trade (% of GDP)", "Life expectancy at birth, total (years)", "GDP per capita, PPP (constant 2011 international $)", "Population, total", "Population density (people per sq. km of land area)".

Look for the indicator code of these variables and copy them into a text editor (like Stata's Do-file Editor).

```
import delimited "data/WDISeries.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear 
sort indicatorname
browse indicatorname seriescode 
```
{: .source}

![Names and codes of indicators]({{ "/img/browse-indicators.png" | relative_url }})

![Do file editor]({{ "/img/do-file-editor.png" | relative_url }})

![Wrap lines]({{ "/img/wrap-lines.png" | relative_url }})

> ## Challenge
> Load the WDI dataset from `WDIData.csv`. 
> Keep the variables "Merchandise trade (% of GDP)", "Life expectancy at birth, total (years)", "GDP per capita, PPP (constant 2011 international $)", "Population, total", "Population density (people per sq. km of land area)".
>
> > ## Solution
> > ```
> > import delimited "data/WDIData.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
> > keep if indicatorcode == "TG.VAL.TOTL.GD.ZS" | indicatorcode == "SP.DYN.LE00.IN" | indicatorcode == "NY.GDP.PCAP.PP.KD" | indicatorcode == "SP.POP.TOTL" | indicatorcode == "EN.POP.DNST"
> > ```
> > {: .source}
> > Whenever you are checking a variable against a list of admissible values, you can use the `inlist` function. The number of 
> > arguments is between 2 and 250 for reals and between 2 and 10 for strings.
> > ```
> > keep if inlist(indicatorcode, "TG.VAL.TOTL.GD.ZS", "SP.DYN.LE00.IN", "NY.GDP.PCAP.PP.KD", "SP.POP.TOTL", "EN.POP.DNST")
> > ```
> > {: .source}
> {: .solution}
{: .challenge}

Note that variable `v5` corresponds to year 1960, `v63` corresponds to year 2018. Reshape the data so that each year is in a separate row.

```
reshape long v, i(countrycode indicatorcode) j(year)
replace year = year - 5 + 1960
```
{: .source}

```
. reshape long v, i(countrycode indicatorcode) j(year)
(note: j = 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 3
 > 0 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 
 > 57 58 59 60 61 62 63 64)

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
```
{: .output}

Create a new string variable `variable_name`. Fill it with more legible variable names based on the WDI `indicatorcode`. It should take the values "merchandise_trade", "life_expectancy", "gdp_per_capita", "population", "population_density". 
```
generate str variable_name = ""
replace variable_name = "merchandise_trade" if indicatorcode == "TG.VAL.TOTL.GD.ZS"
replace variable_name = "life_expectancy" if indicatorcode == "SP.DYN.LE00.IN"
replace variable_name = "gdp_per_capita" if indicatorcode == "NY.GDP.PCAP.PP.KD"
replace variable_name = "population" if indicatorcode == "SP.POP.TOTL" 
replace variable_name = "population_density" if indicatorcode == "EN.POP.DNST"
```
{: .source}

Reshape the data so that each variable is in a separate column. 
You will use the `reshape wide` command. The column names are in `variable_name`, which is a string variable.
```
reshape wide v, i(countrycode year) j(variable_name) string
```
{: .source}
This gives an error "variable indicatorcode not constant within countrycode year. variable indicatorname not constant within countrycode year". Variables that you are not reshaping should be constant within `i()`. Since `indicatorcode` and `indicatorname` are just alternative names for `variable_name`, we can safely drop the.
```
drop indicatorcode indicatorname
reshape wide v, i(countrycode year) j(variable_name) string
```
{: .source}
```
(note: j = gdp_per_capita life_expectancy merchandise_trade population population_
 > density)

Data                               long   ->   wide
-----------------------------------------------------------------------------
Number of obs.                    79200   ->   15840
Number of variables                   5   ->       8
j variable (5 values)     variable_name   ->   (dropped)
xij variables:
                                      v   ->   vgdp_per_capita vlife_expectancy ..
 > . vpopulation_density
-----------------------------------------------------------------------------
```
{: .output}
We now have five new variables, `vgdp_per_capita`, etc, but the variables `v` and `variable_name` have been dropped. Our new variable names look a bit clunky, we can remove the `v` from the beginning,
```
rename v* *
```
{: .source}
A quick `browse` confirms that the data is in the tidy format.
![WDI data in tidy format]({{ "/img/wdi-reshaped.png" | relative_url }})

Time to save our data
```
save "data/WDI-select-variables.dta", replace
```
{: .source}

![Select commands to save as a .do file]({{ "/img/send-to-editor.png" | relative_url }})

```
import delimited "data/WDIData.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
keep if inlist(indicatorcode, "TG.VAL.TOTL.GD.ZS", "SP.DYN.LE00.IN", "NY.GDP.PCAP.PP.KD", "SP.POP.TOTL", "EN.POP.DNST")
reshape long v, i(countrycode indicatorcode) j(year)
replace year = year - 5 + 1960
generate str variable_name = ""
replace variable_name = "merchandise_trade" if indicatorcode == "TG.VAL.TOTL.GD.ZS"
replace variable_name = "life_expectancy" if indicatorcode == "SP.DYN.LE00.IN"
replace variable_name = "gdp_per_capita" if indicatorcode == "NY.GDP.PCAP.PP.KD"
replace variable_name = "population" if indicatorcode == "SP.POP.TOTL" 
replace variable_name = "population_density" if indicatorcode == "EN.POP.DNST"
drop indicatorcode indicatorname
reshape wide v, i(countrycode year) j(variable_name) string
rename v* *
save "data/WDI-select-variables.dta", replace
```
{: .source}

In the next episode, we will learn how to better format and document this code and how to run it.

> ## Challenge
> Drop data outside the 1990-2017 range. 
> > ## Solution
> > ```
> > drop if year < 1990 | (year > 2017 & !missing(year)) 
> > ```
> > {: .source}
> > Note how we control for potential missing values in year to avoid the "missing greater than" gotcha.
> {: .solution}
{: .challenge}

Create a decade variable with values 1960, 1970, etc. Calculate the mean of GDP per capita for each country by decade. 
```
generate decade = int(year/10)*10
egen gdp_decade_mean = mean(gdp_per_capita), by(countrycode decade)
```
{: .source}

> ## Challenge
> Create a variable for the percentage deviation of GDP per capita from the decadal average. Show that its mean is zero. Why?
> > ## Solution
> > ```
> > . gen relative_gdp = gdp_per_capita / gdp_decade_mean * 100 - 100
> > (9,381 missing values generated)
> >
> > . summarize relative_gdp 
> > 
> >     Variable |        Obs        Mean    Std. Dev.       Min        Max
> > -------------+---------------------------------------------------------
> > relative_gdp |      6,459   -7.32e-08    11.30361  -72.25054   175.2852
> > ```
> > {: .output}
> {: .solution}
{: .challenge}

> ## Challenge
> Aggregate the dataset by country and decade, keeping only the mean of each variable. Save this as `data/wdi_decades.dta`.
> > ## Solution
> > ```
> > collapse (mean) gdp_per_capita life_expectancy merchandise_trade population population_density, by(countrycode decade)
> > ```
> > {: .source}
> {: .solution}
{: .challenge}

> ## Gotcha
> The command `collapse` creates a new, aggregated dataset in memory, and your old dataset will be gone without any warning. Use `collapse` with caution.
{: .callout}

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


> ## Challenge
> Using the CEPII distance dataset, calculate for each country the average distance to other countries, naming this variable `average_distance`. Save the dataset as `data/average_distance.dta`.
> > ## Solution
> > ```
> > use "data/dist_cepii.dta", clear
> > collapse (mean) average_distance = distw, by(iso_o)
> > save "data/average_distance.dta", replace
> > ```
> > {: .source}
> > Because the dataset is symmetric, it does not matter whether you use origin (`iso_o`) or destination (`iso_d`) country.
> {: .solution}
{: .challenge}

The command `merge` merges a dataset in memory (the "master" data) to another one on disk (the "using" data) by matching keys between the two datasets.

> ## Data in memory, data on disk
> Stata is different from other popular statistical and data manipulation languages like R and python/pandas in that it can only hold one dataset in memory at a time. In most applications, you will work with multiple datasets, so you will need to `merge` them quite often.
{: .callout}

> ## Challenge
> Load the decadal WDI data. Merge the average distance measure for each country. 
> > ## Solution
> > ```
> > use "data/wdi_decades.dta"
> > merge m:1 countrycode using "data/average_distance.dta"
> > ```
> > {: .source}
> > ```
> > variable countrycode not found
> > r(111);
> > ```
> > {: .error}
> > The problem is that in the "using" dataset (`data/average_distance.dta`), country codes are called `iso_o`, not `countrycode`. Merge requires that the keys on which you are merging are called the same in both datasets.
> > ```
> > use "data/wdi_decades.dta"
> > rename countrycode iso_o
> > merge m:1 iso_o using "data/average_distance.dta"
> > ```
> > {: .source}
> > ```
> >     Result                           # of obs.
> >     -----------------------------------------
> >     not matched                           220
> >         from master                       195  (_merge==1)
> >         from using                         25  (_merge==2)
> >     matched                               597  (_merge==3)
> >     -----------------------------------------
> > ```
> > {: .output}
> {: .solution}
{: .challenge}

```
. tabulate _merge

                 _merge |      Freq.     Percent        Cum.
------------------------+-----------------------------------
        master only (1) |        195       23.87       23.87
         using only (2) |         25        3.06       26.93
            matched (3) |        597       73.07      100.00
------------------------+-----------------------------------
                  Total |        817      100.00
```
{: .output}

By default, each row gets a merge code, saved in a new variable called `_merge`. Merge codes are useful to check the results of our merge. "Master" is the dataset in memory, "using" is the dataset on disk. 

```
. use "data/wdi_decades.dta", clear
. rename countrycode iso_o
. merge m:1 iso_o using "data/average_distance.dta", keep(master match)

    Result                           # of obs.
    -----------------------------------------
    not matched                           195
        from master                       195  (_merge==1)
        from using                          0  (_merge==2)

    matched                               597  (_merge==3)
    -----------------------------------------

. tabulate _merge
                 _merge |      Freq.     Percent        Cum.
------------------------+-----------------------------------
        master only (1) |        195       24.62       24.62
            matched (3) |        597       75.38      100.00
------------------------+-----------------------------------
                  Total |        792      100.00

```
{: .output}

Since `merge` displays the distribution of merge codes, we often do not need to save it directly. `merge m:1 iso_o using "data/average_distance.dta", keep(master match) nogenerate`

FIXME: find a good use case for `update` option 

> ## On to many, many to one
> We have seen a many-to-one `m:1` merge, where the "master" data has many rows with the same key, the "using" data has only one row for each key value. One-to-many `1:m` are exactly the flipside of this, with the role of "master" and "using" data reversed. 
{: .callout}


> ## Gotcha
> Never do a many-to-many, `m:m` merge. It does not do what you expect. You probably want to do a `joinby` instead.
{: .callout}

FIXME: add `egen` examples

> ## Challenge
> What is the difference between `collapse (mean) average_distance = distw, by(iso_o)` and `egen average_distance = mean(distw), by(iso_o)`?
> > ## Solution
> > Both calculate the average `distw` by origin country code. `collapse` creates a new dataset with one row for each group (origin country code). `egen` keeps the original dataset, its rows and variables, and adds a new variable with the group average.
> {: .solution}
{: .challenge}


{% include links.md %}
