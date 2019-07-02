---
title: "Data Formats and Data Quality"
teaching: 0
exercises: 0
questions:
- "How do I read and write tabular data?"
- "How can I explore my data?"
- "How does Stata handle missing values?"
objectives:
- "Read and write data using relative path."
- "Import and export spreadsheet data."
- "Explore your dataset using `browse`, `describe`, `summarize`, `tabulate` and `inspect`."
- "Convert strings to numerical variables."
- "Deal with missing values."
keypoints:
- "Use the missing value feature of Stata, not a numerical code."
- "Test for missing values with the `missing` function."
- "In Stata expressions, missing values are greater than any number. Functions of missing values are missing value."
- "Check CSV files for separator, variable names, and character encoding."
- "Always write out filename extensions to avoid confusion."
---

> ## Challenge
> Your current working directory is `/home/user/dc-economics`. Which of the following can load the data in `/home/user/dc-economics/data/dist_cepii.dta`?
> 1. `use "/home/user/dc-economics/data/dist_cepii.dta"`
> 2. `use "data/dist_cepii.dta"`
> 3. `use "/data/dist_cepii.dta"`
> 4. `use "data\dist_cepii.dta"`
> 5. `use "../dist_cepii.dta"`
> 
> > ## Solution
> > 1. Yes. You can always use the _absolute path_ of a datafile you want to load. It is good practice to put the filename inside double quotes to guard against space and other special characters. Note, however, that your code may not run on someone else's computer where the absolute path is different.
> > 2. Yes. You are using a _relative path_. 
> > 3. No. This is an absolute path because it starts with `/`, but it is not the correct absolute path of `/home/user/dc-economics/data/dist_cepii.dta`.
> > 4. It depends. It will work on Windows, but not on Linux and Mac machines. Use forward slash, `/` instead.
> > 5. No. This would look for `dist_cepii.dta` in the directory `/home/user`, one level up from the current working directory, `/home/user/dc-economics`.
> {: .solution}
{: .challenge}

> ## Challenge
> Import the World Development Indicator dataset from .csv format using the command `import delimited data/WDIData.csv`. What goes wrong and how can you fix it?
> 
> > ## Solution
> > Load the data and launch a data browser.
> > ```
> > import delimited data/WDIData.csv
> > browse
> > ```
> > You find that the variables are named `v1` through `v64` and the first row contains the actual variable names. 
> > ![](img/import-header.png)
> > This is because WDI uses years for variable names, but Stata does not allow purely numeric variable names.
> > ![](img/import-header-2.png)
> > ```
> > import delimited data/WDIData.csv, varnames(1) clear
> > ```
> {: .solution}
{: .challenge}

FIXME: How to get rid of byte-order-marker?

> ## Challenge
> Explore the variables `v5`, `v63` and `v64`. Which years do they correspond to? Do they have missing values?
>
> > ## Solution
> > ```input
> > inspect v5 v63 v64
> > ```
> > v5:  1960                                       Number of Observations
> > ---------                              ---------------------------------------
> >                                              Total      Integers   Nonintegers
> > |      #                     Negative          692           240           452
> > |      #                     Zero            1,269         1,269             -
> > |      #                     Positive       36,335         8,139        28,196
> > |      #                               -----------   -----------   -----------
> > |      #                     Total          38,296         9,648        28,648
> > |  .   #   .   .   .         Missing       383,840
> > +----------------------                -----------
> > -3.34e+14      8.35e+14                    422,136
> > (More than 99 unique values)
> > 
> > v63:  2018                                      Number of Observations
> > ----------                             ---------------------------------------
> >                                              Total      Integers   Nonintegers
> > |  #                         Negative           75             -            75
> > |  #                         Zero              690           690             -
> > |  #                         Positive       29,482         8,816        20,666
> > |  #                                   -----------   -----------   -----------
> > |  #                         Total          30,247         9,506        20,741
> > |  #   .   .   .   .         Missing       391,889
> > +----------------------                -----------
> > -43.86237      6.82e+13                    422,136
> > (More than 99 unique values)
> > 
> > v64:                                            Number of Observations
> > ------                                 ---------------------------------------
> >                                              Total      Integers   Nonintegers
> > |                            Negative            -             -             -
> > |                            Zero                -             -             -
> > |                            Positive            -             -             -
> > |                                      -----------   -----------   -----------
> > |                            Total               -             -             -
> > |                            Missing       422,136
> > +----------------------                -----------
> > .             -9.0e+307                    422,136
   (0 unique value)
> > ```output
> >
> {: .solution}
{: .challenge}


> ## Challenge
> Load `data/dist_cepii.dta`. Explore the variable `distw` (weighted average distance between cities in the pair of countries).
> 1. What are its measurement units?
> 2. What is its smallest and largest value?
> 3. In how many cases is it missing?
>
> > ## Solution
> > 1. `describe distw` gives you the variable label "weighted distance (pop-wt, km)". It is hence recorded in kilometers. You also see that the variable is _double_, not _integer_.
> > 2. `summarize distw` shows that the distance varies between  0.995 and 19781.39 kilometers.
> > 3. `inspect distw` shows that it is missing 2,215 cases. This command also gives you the minimum and maximum values.
> {: .solution}
{: .challenge}


> ## Challenge
> Using the weighted distance between countries, count how many pairs of countries are farther than 15,000 km.
> > ## Solution
> > `count if distw > 15000 & !missing(distw)` gives you an answer of 5,070. If you use `count if distw > 15000`, you get 7,285. This is because Stata treats missing values as larger than any real number. It hence adds the 2,215 missing values.
> {: .solution}
{: .challenge}

> ## Gotcha
> Missing values are greater than any number.

> ## Challenge
> Which of the following tells you how often the weighted distance is greater than the simple unweighted distance?
> ```
> count if dist < distw
> count if dist - distw < 0
> count if distw - dist > 0
> ```
> > ## Solution
> > The second. When neither variable is missing, the three comparisons give the same answer. However, when `distw` has missing values, the first comparison evaluates to true, because missing values are greater than anything. The second comparison starts with a mathematical operation, which evaluates to missing and is hence *not* smaller than zero. 
> > As this property of missing values is a regular *gotcha*, you should always explicitly test for missing values like so
> > ```
> > count if dist < distw & !missing(dist, distw)
> > ```
> {: .solution}
{: .challenge}


> ## Challenge
> Load `data/dist_cepii.dta`. Replace missing values in the variable `distw` with 0.
> ```
> use "data/dist_cepii.dta"
> mvencode distw, mv(0)
> ```
> What happens?
> > ## Solution
> > You get an error message:
> > [OUTPUT]
> > To force the replacement of missing values with zero, an already existing value of `distw`, use `mvencode distw, mv(0) override`.
> {: .solution}
{: .challenge}

> ## Challenge
> Load `data/dist_cepii.dta`. If the variable `distw` is missing, replace it with the value from the variable `dist`.
> > ## Solution
> > ```
> > use "data/dist_cepii.dta"
> > replace distw = dist if missing(distw)
> > ```
> {: .solution}
{: .challenge}


{% include links.md %}

