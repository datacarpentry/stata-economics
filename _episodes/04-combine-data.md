---
title: "Combine Data"
teaching: 0
exercises: 0
questions:
- "How do I combine data from different files?"
objectives:
- "Merge two different datasets using unique keys."
keypoints:
- "Create tidy data before merging."
---

The commands `append` and `merge` combine a dataset in memory (the "master" data) to another one on disk (the "using" data). `append` adds more observations, `merge` adds more variables by matching keys between the two datasets.

![Combine data vertically or horizontally]({{ "/img/append-merge.png" | relative_url }}) 

> ## Data in memory, data on disk
> Stata is different from other popular statistical and data manipulation languages like R (Data Frame) and Python (Pandas) in that it can only hold one dataset in memory at a time. In most applications, you will work with multiple datasets, so you will need to `merge` them quite often. (Stata 16 will allow for multiple data frames in memory.)
{: .callout}

The command `append` is used to combine datasets with the same columns, each representing a different set of observations. A common use case is combining large datasets broken into smaller chunks.

To practice appending, first create two smaller datasets.
```
use "data/WDI-select-variables.dta", clear
keep if year == 1990
generate old_data = 1
save "data/gdp1990.dta"

use "data/WDI-select-variables.dta", clear
keep if year == 2017
generate new_data = 1
save "data/gdp2017.dta"
```
{: .source}

```
use "data/gdp1990.dta", clear
describe
append using "data/gdp2017.dta"
describe
summarize old_data new_data
```
{: .source}

```
. use "data/gdp1990.dta", clear

. describe

Contains data from data/gdp1990.dta
  obs:           264                          
 vars:             7                          16 Aug 2019 15:04
 size:        22,440                          
----------------------------------------------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
----------------------------------------------------------------------------------------------------------------------
countrycode     str3    %9s                   Country Code
year            int     %9.0g                 
gdp_per_capita  double  %8.0g                 gdp_per_capita v
merchandise_t~e double  %8.0g                 merchandise_trade v
population      double  %8.0g                 population v
countryname     str52   %52s                  Country Name
old_data        float   %9.0g                 
----------------------------------------------------------------------------------------------------------------------
Sorted by: countrycode  year

. append using "data/gdp2017.dta"

. describe

Contains data from data/gdp1990.dta
  obs:           528                          
 vars:             8                          16 Aug 2019 15:04
 size:        46,992                          
----------------------------------------------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
----------------------------------------------------------------------------------------------------------------------
countrycode     str3    %9s                   Country Code
year            int     %9.0g                 
gdp_per_capita  double  %8.0g                 gdp_per_capita v
merchandise_t~e double  %8.0g                 merchandise_trade v
population      double  %8.0g                 population v
countryname     str52   %52s                  Country Name
old_data        float   %9.0g                 
new_data        float   %9.0g                 
----------------------------------------------------------------------------------------------------------------------
Sorted by: 
     Note: Dataset has changed since last saved.

. summarize old_data new_data

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
    old_data |        264           1           0          1          1
    new_data |        264           1           0          1          1
```
{: .output}

Variables that have the same name are combined as expected. Because `old_data` is only defined in the master dataset, its values are filled with missing value for the remaining observations. Similarly, `new_data` is only defined for those observations that come from the using dataset.

![ZWE to ABW]({{ "/img/append.png" | relative_url }}) 

We can also see the edge of the two datasets: the master data ends with "Zimbabwe," the using data starts with "Aruba." (Usually this will not be as obvious.)

Because `append` can be used to combine many small chunks of files, we will return to it when discussing automating repetitive tasks with loops.

## Merge
Load the decadal WDI data. Merge the average distance measure for each country. 

```
use "data/wdi_decades.dta", clear
merge m:1 countrycode using "data/average_distance.dta"
```
{: .source}
```
variable countrycode not found
r(111);
```
{: .error}
The problem is that in the "using" dataset (`data/average_distance.dta`), country codes are called `iso_o`, not `countrycode`. Merge requires that the keys on which you are merging are called the same in both datasets.
```
use "data/wdi_decades.dta", clear
rename countrycode iso_o
merge m:1 iso_o using "data/average_distance.dta"
```
{: .source}
```
    Result                           # of obs.
    -----------------------------------------
    not matched                           220
        from master                       195  (_merge==1)
        from using                         25  (_merge==2)
    matched                               597  (_merge==3)
    -----------------------------------------
```
{: .output}

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

> ## One to many, many to one
> We have seen a many-to-one `m:1` merge, where the "master" data has many rows with the same key, the "using" data has only one row for each key value. One-to-many `1:m` are exactly the flipside of this, with the role of "master" and "using" data reversed. 
{: .callout}

> ## Gotcha
> Never do a many-to-many, `m:m` merge. It does not do what you expect. You probably want to do a `joinby` instead.
{: .callout}

Before saving the final dataset a good practice is to compress the amount of memory used by your data using the `compress` command.

FIXME: use different example

```
. use "data/dist_cepii.dta", clear

. egen average_distance = mean(distw), by(iso_o)
(1120 missing values generated)
.
. rename iso_o countrycode 

. joinby countrycode using "data/wdi_decades.dta"

. 
. compress
  variable decade was float now int
  variable population was double now long
  variable countryname was str52 now str30
  (34,947,584 bytes saved)
```
{: .output}

NB: I removed `joinby`. `append` and `merge` will be enough.

NB: tempfiles are explained in episode 4


{% include links.md %}
