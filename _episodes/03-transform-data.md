---
title: "Transform Data"
teaching: 0
exercises: 0
questions:
- "What is tidy data?"
- "How do I transfrom the data to the shape I need?"
objectives:
- "Filter the rows and columns of your data using `drop` and `keep`."
- "Calculate group statistics using `egen`."
- "Aggregate your data using `collapse`."
- "Change the way your data is organized using `reshape`."
keypoints:
- "Drop unnessecary variables freely."
- "Reshape your dataset to create tidy data."
- "Use `egen` to save statistics to new columns, `collapse` to aggregate the entire dataset."
---

## Filter data

There are many variables in our dataset loaded from `data/WDICountry.csv`.
```
. describe

Contains data
  obs:           263                          
 vars:            32                          
 size:       645,665                          
----------------------------------------------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
----------------------------------------------------------------------------------------------------------------------
countrycode     str3    %9s                   Country Code
shortname       str50   %50s                  Short Name
tablename       str50   %50s                  Table Name
longname        str73   %73s                  Long Name
alphacode       str2    %9s                   2-alpha code
currencyunit    str42   %42s                  Currency Unit
specialnotes    str1294 %1294s                Special Notes
region          str26   %26s                  Region
incomegroup     str19   %19s                  Income Group
wb2code         str2    %9s                   WB-2 code
national~seyear str50   %50s                  National accounts base year
national~ceyear str9    %9s                   National accounts reference year
snapricevalua~n str36   %36s                  SNA price valuation
lendingcategory str9    %9s                   Lending category
othergroups     str9    %9s                   Other groups
systemofnatio~s str61   %61s                  System of National Accounts
alternativeco~r str22   %22s                  Alternative conversion factor
pppsurveyyear   str34   %34s                  PPP survey year
balanceofpaym~e str33   %33s                  Balance of Payments Manual in use
externaldebtr~s str11   %11s                  External debt Reporting status
systemoftrade   str20   %20s                  System of trade
governmentacc~t str31   %31s                  Government Accounting concept
imfdatadissem~d str51   %51s                  IMF data dissemination standard
latestpopulat~s str166  %166s                 Latest population census
latesthouseho~y str77   %77s                  Latest household survey
sourceofmostr~n str88   %88s                  Source of most recent Income and expenditure data
vitalregistra~e str48   %48s                  Vital registration complete
latestagricul~s str130  %130s                 Latest agricultural census
latestindustr~a int     %8.0g                 Latest industrial data
latesttradedata int     %8.0g                 Latest trade data
v31             byte    %8.0g                 
censusyear      float   %9.0g                 
----------------------------------------------------------------------------------------------------------------------
Sorted by: 
     Note: Dataset has changed since last saved.
```
{: .output}

We will not use most of them, so let's `drop` them.

```
drop specialnotes
```
{: .source}

```
drop alphacode currencyunit
```
{: .source}

In fact, we will `keep` fewer than we `drop`. There is a separate command for this complementary operation.
```
. keep countrycode shortname region incomegroup censusyear 

. describe

Contains data
  obs:           263                          
 vars:             5                          
 size:        26,826                          
----------------------------------------------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
----------------------------------------------------------------------------------------------------------------------
countrycode     str3    %9s                   Country Code
shortname       str50   %50s                  Short Name
region          str26   %26s                  Region
incomegroup     str19   %19s                  Income Group
censusyear      float   %9.0g                 
----------------------------------------------------------------------------------------------------------------------
Sorted by: 
     Note: Dataset has changed since last saved.
```
{: .output}

> ## Gotcha
> The commands `keep` and `drop` irreversibly change the data in your memory. Only use them if your work is easy to reproduce if you make an error, such as right after loading a dataset.
{: .callout}

You can use variable name wildcards with both commands (`drop latest*`). Similarly, you can use the `-` character to keep or drop variables in the dataset. Stata will `keep`, or `drop`, all variables starting with the variable to the left of the `-` and ending with the variable to the right of the `-`.
 
To filter out observations, use `drop if` and `keep if`.

```
. count
  263

. drop if missing(incomegroup)
(46 observations deleted)

. count
  217
```
{: .output}
There are 46 fewer observations than before.

The command is the same as `keep if !missing(incomegroup)`. The operator `!` stands for negation, "not missing."

> ## Challenge
> Keep countries with a population census more recent than 1999. How many countries have you dropped from the dataset?
> > ## Solution
> > ```
> > . keep if censusyear > 1999 & !missing(censusyear)
> > (8 observations deleted)
> > ```
> > {: .output}
> > Note the missing values. There are eight countries dropped in total.
> {: .solution}
{: .challenge}

## Aggregate data

Calculate the number of countries in each income group and their average census year, using the `egen` command.
`egen` stands for "extended generate," and it allows for creating statistics and other functions by groups.

```
. egen n_country = count(countrycode), by(incomegroup)
. egen average_census_year = mean(censusyear), by(incomegroup)
. describe

Contains data
  obs:           209                          
 vars:             7                          
 size:        22,990                          
----------------------------------------------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
----------------------------------------------------------------------------------------------------------------------
countrycode     str3    %9s                   Country Code
shortname       str50   %50s                  Short Name
region          str26   %26s                  Region
incomegroup     str19   %19s                  Income Group
censusyear      float   %9.0g                 
n_country       float   %9.0g                 
average_censu~r float   %9.0g                 
----------------------------------------------------------------------------------------------------------------------
Sorted by: 
     Note: Dataset has changed since last saved.

```
{: .output}

The command `egen` creates a new variable with the aggregated statistics.

There are many functions to be used in `egen`; `count`, `min`, `max`, `sum` and `mean` are the most commonly used.

You can group by multiple variables.
```
drop n_country
egen n_country = count(countrycode), by(incomegroup region)
```
{: .source}

Create a variable capturing the decade of the most recent population census and take its average by region.
```
generate census_decade = int(censusyear/10)*10
egen average_census_decade = mean(census_decade), by(region)
```
{: .source}

You can do this in one step, by nesting the function.
```
drop *census_decade
egen average_census_decade = mean(int(censusyear/10)*10), by(region)
```
{: .source}

> ## Challenge
> What does the following code do?
> ```
> egen what_is_this_variable = sum(substr(incomegroup, 1, 4) == "High"), by(region)
> ```
> {: .source}
> > ## Solution
> > It counts the number of countries in the "high" income group by region. When reading nested functions, read from the inside out. `substr(incomegroup, 1, 4)` is the first four letters of the variable `incomegroup`. When this equals "High" the expression `substr(incomegroup, 1, 4) == "High"` will evaluate to 1. Otherwise it will be 0. `egen what_is_this_variable = sum(), by(region)` adds the number of ones across regions, that is the number of countries, for which the expression takes the value 1. These are the countries that fall into the high income group.
> {: .solution}
{: .challenge}


> ## Challenge
> Create a variable for the difference of `censusyear` from the average of the region. Show that its mean is zero. Why?
> > ## Solution
> > ```
> > . egen mean_censusyear = mean(censusyear), by(region)
> > (46 missing values generated)
> > 
> > . generate difference_censusyear = censusyear - mean_censusyear 
> > (47 missing values generated)
> > 
> > . summarize difference_censusyear 
> > 
> >     Variable |        Obs        Mean    Std. Dev.       Min        Max
> > -------------+---------------------------------------------------------
> > difference~r |        216   -6.22e-06    6.809937  -64.14282   9.857178
> > ```
> > {: .output}
> > If we subtract the mean of a variable, the difference will be mean zero.
> {: .solution}
{: .challenge}

## Reshape data

The WDI dataset in `data/WDIData.csv` has a strange shape. Variables are in separate rows, whereas years are in separate columns. This is the opposite of "[tidy data](http://dx.doi.org/10.18637/jss.v059.i10)," where each variable has its own column, and different observations such as different years are in separate rows. We will reshape the data in the tidy format.

Different shapes of the data are useful for different tasks. For example, we may want to create a line graph from a variable. In Stata, this is only possible in years are in different observations (long form), not in different variables (wide form).

![help reshape]({{ "/img/help-reshape.png" | relative_url }})

To practice reshaping, load a somewhat precleaned subset of the WDI dataset from `data/gdp-wide.csv`. We will clean the original data ourselves later.

```
import delimited "data/gdp-wide.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
browse
```
{: .source}

![Data in the wide format]({{ "/img/gdp-wide.png" | relative_url }})

This data is too "wide": column names contain information that we may want to work with. Let us `reshape long`.

```
. reshape long gdp, i(countrycode) j(year)
(note: j = 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 20
> 11 2012 2013 2014 2015 2016 2017)

Data                               wide   ->   long
-----------------------------------------------------------------------------
Number of obs.                      264   ->    7392
Number of variables                  30   ->       4
j variable (28 values)                    ->   year
xij variables:
            gdp1990 gdp1991 ... gdp2017   ->   gdp
-----------------------------------------------------------------------------
```
{: .output}

The option `i()` lists variables that index observations (rows) within the _wide_ dataset. Each observation is a country in this wide format, so we use `i(countrycode)`. We can have multiple variables inside `i()`, like `i(countrycode countryname)`. The option `j()` gives _one_ variable that indexes columns in the _wide_ format. Because `gdp1960`, ..., `gdp2017` correspond to different _years_, we call this variable `year`.

The output of `reshape` is most helpful. After a `reshape long`, we have more observations and fewer variables. We see that we created a new variable called `year` (from the option `j`) and `gdp1960`, ..., `gdp2017` became a single variable, `gdp`.

![Data in the long format]({{ "/img/gdp-long.png" | relative_url }})

How does `reshape` know to look for `gdp1960`, ..., `gdp2017`? Since we said `reshape long gdp, ...` it looks for variable names beginning with `gdp` and puts the remaining part of the variable name in the newly declared variable `year`. This is the most often used, default option, but we can also tell `reshape` what pattern to look for.

To undo this reshape,
```
. reshape wide gdp, i(countrycode) j(year)
(note: j = 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 20
> 11 2012 2013 2014 2015 2016 2017)

Data                               long   ->   wide
-----------------------------------------------------------------------------
Number of obs.                     7392   ->     264
Number of variables                   4   ->      30
j variable (28 values)             year   ->   (dropped)
xij variables:
                                    gdp   ->   gdp1990 gdp1991 ... gdp2017
-----------------------------------------------------------------------------
```
{: .output}
After a `reshape`, we can switch between the wide and long format more easily,
```
. reshape long
(note: j = 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2005 2006 2007 2008 2009 2010 20
> 11 2012 2013 2014 2015 2016 2017)

Data                               wide   ->   long
-----------------------------------------------------------------------------
Number of obs.                      264   ->    7392
Number of variables                  30   ->       4
j variable (28 values)                    ->   year
xij variables:
            gdp1990 gdp1991 ... gdp2017   ->   gdp
-----------------------------------------------------------------------------
```
{: .output}

Suppose we want to compare Euro area GDP to World GDP for each year. For this, it would be great if these two series would be in different variables. We need a `reshape wide`.
```
. keep if inlist(countrycode, "EMU", "WLD")
(7,336 observations deleted)

. reshape wide gdp, i(year) j(countrycode)
variable countrycode is string; specify string option
r(109);
```
{: .error}
Ok, we can do that
```
. reshape wide gdp, i(year) j(countrycode) string
(note: j = EMU WLD)
variable countryname not constant within year
    Your data are currently long.  You are performing a reshape wide.  You typed something like

        . reshape wide a b, i(year) j(countrycode)

    There are variables other than a, b, year, countrycode in your data.  They must be constant within year because
    that is the only way they can fit into wide data without loss of information.

    The variable or variables listed above are not constant within year.  Perhaps the values are in error.  Type
    reshape error for a list of the problem observations.

    Either that, or the values vary because they should vary, in which case you must either add the variables to the
    list of xij variables to be reshaped, or drop them.
r(9);
```
{: .error}
The problem is that `countryname` also depends on `countrycode` and `reshape` does not know what to do with it. We can either reshape it, too, or drop it.
```
. reshape wide gdp countryname, i(year) j(countrycode) string
(note: j = EMU WLD)

Data                               long   ->   wide
-----------------------------------------------------------------------------
Number of obs.                       56   ->      28
Number of variables                   4   ->       5
j variable (2 values)       countrycode   ->   (dropped)
xij variables:
                                    gdp   ->   gdpEMU gdpWLD
                            countryname   ->   countrynameEMU countrynameWLD
-----------------------------------------------------------------------------
```
{: .output}

![Data in the long format]({{ "/img/gdp-transposed.png" | relative_url }})

> ## Challenge
> Create a variable capturing the percentage deviation between Euro area GDP per capita and world GDP per capita.
> > ## Solution
> > ```
> > generate relative_gdp = gdpEMU / gdpWLD * 100 - 100
> > ```
> > {: .source}
> {: .solution}
{: .challenge}

Note that `reshape` changes the dataset in memory and you cannot undo it. Make sure you know what you are doing.

To clean the actual WDI data, we first read metadata from `data/WDISeries.csv`. This file contains the indicator codes and long descriptions. 

We will need the variables "Merchandise trade (% of GDP)", "Life expectancy at birth, total (years)", "GDP per capita, PPP (constant 2011 international $)", "Population, total", "Population density (people per sq. km of land area)".

Look for the indicator code of these variables and copy them into a text editor (like Stata's Do-file Editor).

```
import delimited "data/WDISeries.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear 
browse
```
{: .source}

![Names and codes of indicators]({{ "/img/browse-indicators.png" | relative_url }})

![Do file editor]({{ "/img/do-file-editor.png" | relative_url }})

The operator `|` stands for "or," the operator `&` (not used here) stands for "and."

![Wrap lines]({{ "/img/wrap-lines.png" | relative_url }})

> ## Challenge
> Load the WDI dataset from `WDIData.csv`. 
> Keep the variables "Merchandise trade (% of GDP)", "GDP per capita, PPP (constant 2011 international $)", and "Population, total".
>
> > ## Solution
> > ```
> > import delimited "data/WDIData.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
> > keep if indicatorcode == "TG.VAL.TOTL.GD.ZS" | indicatorcode == "NY.GDP.PCAP.PP.KD" | indicatorcode == "SP.POP.TOTL"
> > ```
> > {: .source}
> > Whenever you are checking a variable against a list of admissible values, you can use the `inlist` function.
> > ```
> > keep if inlist(indicatorcode, "TG.VAL.TOTL.GD.ZS", "NY.GDP.PCAP.PP.KD", "SP.POP.TOTL")
> > ```
> > {: .source}
> {: .solution}
{: .challenge}

Note that variable `v5` corresponds to year 1960, `v63` corresponds to year 2018. Reshape the data so that each year is in a separate row.

Now let's reshape the data.
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
Number of obs.                      792   ->   47520
Number of variables                  64   ->       6
j variable (60 values)                    ->   year
xij variables:
                          v5 v6 ... v64   ->   v
-----------------------------------------------------------------------------

. replace year = year - 5 + 1960
variable year was byte now int
(47,520 real changes made)
```
{: .output}

Create a new string variable `variable_name`. Fill it with more legible variable names based on the WDI `indicatorcode`. It should take the values "merchandise_trade", "gdp_per_capita", "population". 
```
generate str variable_name = ""
replace variable_name = "merchandise_trade" if indicatorcode == "TG.VAL.TOTL.GD.ZS"
replace variable_name = "gdp_per_capita" if indicatorcode == "NY.GDP.PCAP.PP.KD"
replace variable_name = "population" if indicatorcode == "SP.POP.TOTL" 
```
{: .source}

Reshape the data so that each variable is in a separate column. 
You will use the `reshape wide` command. The column names are in `variable_name`, which is a string variable.
```
reshape wide v, i(countrycode year) j(variable_name) string
```
{: .error}
This gives an error "variable indicatorcode not constant within countrycode year. variable indicatorname not constant within countrycode year". Variables that you are not reshaping should be constant within `i()`. Since `indicatorcode` and `indicatorname` are just alternative names for `variable_name`, we can safely drop them.
```
drop indicatorcode indicatorname
reshape wide v, i(countrycode year) j(variable_name) string
```
{: .source}
```
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
```
{: .output}
We now have five new variables, `vgdp_per_capita`, etc, but the variables `v` and `variable_name` have been dropped. Our new variable names look a bit clunky, we can remove the `v` from the beginning.
```
rename v* *
```
{: .source}
A quick `browse` confirms that the data is in the tidy format.
![WDI data in tidy format]({{ "/img/wdi-reshaped.png" | relative_url }})

Time to save our data. Stata 16, Stata 15, and Stata 14 share the same format, so you can just go ahead and save the data using the `save` command.

```
save "data/WDI-select-variables.dta"
```
{: .source}

Load the saved data and generate a dummy variable that takes value one if the `gdp_per_capita` is higher than the mean.
```
generate high_gdp_per_capita = (gdp_per_capita >= 15453.68) if !missing(gdp_per_capita)
```
{: .source}
Now try to save the same data file again. If you do this, Stata will give a warning that the file already exist.

```
. save "data/WDI-select-variables.dta"
file data/WDI-select-variables.dta already exists
r(602);

end of do-file

r(602);
```
{: .error}
Use the `replace` option if you would like to overwrite an existing dataset. 


> ## Save old
> To save a dataset in Stata 14, Stata 15, or Stata 16 so that it can be used in Stata 13, use the `saveold` command. 
{: .callout}

> ```
> saveold "data/WDI-select-variables-13.dta", replace v(13) 
> ```

>
> Note, however, that string variables (and labels) do not allow for Unicode characters before Version 14. If you work with non-latin characters, it is highly recommended to use Stata 14 or later.
{: .callout}

![Review command history]({{ "/img/command-history.png" | relative_url }})

Commands that errored are red in the command history. Select the ones that we want to keep and send them to a .do file.

![Select commands to save as a .do file]({{ "/img/send-to-editor.png" | relative_url }})


```
import delimited "data/WDIData.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
keep if inlist(indicatorcode, "TG.VAL.TOTL.GD.ZS", "NY.GDP.PCAP.PP.KD", "SP.POP.TOTL")
reshape long v, i(countrycode indicatorcode) j(year)
replace year = year - 5 + 1960
generate str variable_name = ""
replace variable_name = "merchandise_trade" if indicatorcode == "TG.VAL.TOTL.GD.ZS"
replace variable_name = "gdp_per_capita" if indicatorcode == "NY.GDP.PCAP.PP.KD"
replace variable_name = "population" if indicatorcode == "SP.POP.TOTL" 
drop indicatorcode indicatorname
reshape wide v, i(countrycode year) j(variable_name) string
rename v* *
save "data/WDI-select-variables.dta", replace
```
{: .source}

In [Episode 5]({{ "/05-programming/" | relative_url }}), we will learn how to better format and document this code and how to run it.

## Aggregate entire datasets

Aggregate the dataset by country and decade, keeping only the mean of each variable. Save this as `data/wdi_decades.dta`.
```
generate decade = int(year / 10) * 10
collapse (mean) gdp_per_capita merchandise_trade population, by(countrycode decade)
save "data/wdi_decades.dta", replace
```
{: .source}
`collapse` can also use multiple groups, like `countrycode` and `decade`

> ## Gotcha
> The command `collapse` creates a new, aggregated dataset in memory, and your old dataset will be gone without any warning. You will typically use `collapse` and save the collapsed data in a new data file or replace an old one. When working on a dataset you are working with the dataset in `Stata` memory, not with the data file itself. Important note: there is no way to recover an original file once you overwrite it. Always retain a copy of the original dataset.
{: .callout}

Reload the data we have just destroyed and create different aggregate statistics
```
use "data/WDI-select-variables.dta", clear
collapse (mean) average_gdp = gdp_per_capita (min) lowest_gdp = gdp_per_capita, by(countrycode)
```
{: .source}
All of this can be done by `egen`. The main difference is that here we have only one observation by group. This is dangerous (we are destroying data), but can be useful when we create datasets to be used elsewhere. Aggregating across different units of observation (e.g., firms, industries, countries) is a common use case of `collapse`.

> ## Challenge
> Using the `wdi_decades.dta` dataset, calculate the ratio of GDP per capita to the average GDP per capita of that decade.
> > ## Solution
> > ```
> > use "data/wdi_decades.dta", clear
> > egen decade_gdp_average = mean(gdp_per_capita), by(decade)
> > generate relative_gdp_per_capita = gdp_per_capita / decade_gdp_average
> > ```
> > {: .source}
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



{% include links.md %}
