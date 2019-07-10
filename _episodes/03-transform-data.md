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

The WDI dataset you loaded in the previous episode has a strange shape. Variables are in separate rows, whereas years are in separate columns. This is the opposite of "[tidy data](REF)," where each variable has its own column, and different observations such as different years are in separate rows. We will reshape the data in the tidy format.

> ## Challenge
> Load the WDI dataset you saved in the previous episode. 
> Keep the variables "Merchandise trade (% of GDP)", "Life expectancy at birth, total (years)", "GDP per capita, PPP (constant 2011 international $)", "Population, total", "Population density (people per sq. km of land area)".
>
> > ## Solution
> > To minimize the risk of typos, it is better to use the short idenifier of each variable. You can `browse` the dataset to see which identifier corresponds to which variable.
> > ![Names and codes of indicators]({{ relative_root_path }}{% link img/browse-indicators.png %})
> > Or you can use `tabulate` to see the variable name (`indicatorcode`) in the results window. 
> > ```input
> > tabulate indicatorcode if indicatorname == "Merchandise trade (% of GDP)"
> > ```
> > ```output
> >            Indicator Code |      Freq.     Percent        Cum.
> > --------------------------+-----------------------------------
> >         TG.VAL.TOTL.GD.ZS |        264      100.00      100.00
> > --------------------------+-----------------------------------
> >                     Total |        264      100.00
> > ```
> > After you have found all variable ids, use `keep` to keep only the rows corresponding to these.
> > ```input
> > keep if indicatorcode == "TG.VAL.TOTL.GD.ZS" | indicatorcode == "SP.DYN.LE00.IN" | indicatorcode == "NY.GDP.PCAP.PP.KD" | indicatorcode == "SP.POP.TOTL" | indicatorcode == "EN.POP.DNST"
> > ```
> > Whenever you are checking a variable against a list of admissible values, you can use the `inlist` function,
> > ```input
> > keep if inlist(indicatorcode, "TG.VAL.TOTL.GD.ZS", "SP.DYN.LE00.IN", "NY.GDP.PCAP.PP.KD", "SP.POP.TOTL", "EN.POP.DNST")
> > ```
> {: .solution}
{: .challenge}

FIXME: This is probably too complex a challenge, break it up.

> ## Challenge
>  Note that variable `v5` corresponds to year 1960, `v63` corresponds to year 2018. Reshape the data so that each year is in a separate row.
> > ## Solution
> > ```input
> > reshape long v, i(countrycode indicatorcode) j(year)
> > replace year = year - 5 + 1960
> > ```
> > ```output
> > . reshape long v, i(countrycode indicatorcode) j(year)
> > (note: j = 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 3
> >  > 0 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 
> >  > 57 58 59 60 61 62 63 64)
> > 
> > Data                               wide   ->   long
> > -----------------------------------------------------------------------------
> > Number of obs.                     1320   ->   79200
> > Number of variables                  64   ->       6
> > j variable (60 values)                    ->   year
> > xij variables:
> >                           v5 v6 ... v64   ->   v
> > -----------------------------------------------------------------------------
> > 
> > . replace year = year - 5 + 1960
> > variable year was byte now int
> > (79,200 real changes made)
> > ```
> {: .solution}
{: .challenge}



> ## Challenge
> Create a new string variable `variable_name`. Fill it with more legible variable names based on the WDI `indicatorcode`. It should take the values "merchandise_trade", "life_expectancy", "gdp_per_capita", "population", "population_density". 
> > ## Solution
> > ```input
> > generate str variable_name = ""
> > replace variable_name = "merchandise_trade" if indicatorcode == "TG.VAL.TOTL.GD.ZS"
> > replace variable_name = "life_expectancy" if indicatorcode == "SP.DYN.LE00.IN"
> > replace variable_name = "gdp_per_capita" if indicatorcode == "NY.GDP.PCAP.PP.KD"
> > replace variable_name = "population" if indicatorcode == "SP.POP.TOTL" 
> > replace variable_name = "population_density" if indicatorcode == "EN.POP.DNST"
> > ```
> {: .solution}
{: .challenge}

> ## Challenge
> Reshape the data so that each variable is in a separate column. 
> > ## Solution
> > You will use the `reshape wide` command. The column names are in `variable_name`, which is a string variable.
> > ```input
> > reshape wide v, i(countrycode year) j(variable_name) string
> > ```
> > This gives an error "variable indicatorcode not constant within countrycode year.
variable indicatorname not constant within countrycode year". Variables that you are not reshaping should be constant within `i()`. Since `indicatorcode` and `indicatorname` are just alternative names for `variable_name`, we can safely drop the.
> > ```input
> > drop indicatorcode indicatorname
> > reshape wide v, i(countrycode year) j(variable_name) string
> > ```
> > ```output
> > (note: j = gdp_per_capita life_expectancy merchandise_trade population population_
> >  > density)
> > 
> > Data                               long   ->   wide
> > -----------------------------------------------------------------------------
> > Number of obs.                    79200   ->   15840
> > Number of variables                   5   ->       8
> > j variable (5 values)     variable_name   ->   (dropped)
> > xij variables:
> >                                       v   ->   vgdp_per_capita vlife_expectancy ..
> >  > . vpopulation_density
> > -----------------------------------------------------------------------------
> > ```
> > We now have five new variables, `vgdp_per_capita`, etc, but the variables `v` and `variable_name` have been dropped. Our new variable names look a bit clunky, we can remove the `v` from the beginning,
> > ```input
> > rename v* *
> > ```
> > A quick `browse` confirms that the data is in the tidy format.
> > ![WDI data in tidy format](img/wdi-reshaped.png)
> {: .solution}
{: .challenge}

> ## Challenge
> Check for which years we have data on GDP per capita. Drop the years before and after this sample. 
> > ## Solution
> > `tabulate year if !missing(gdp_per_capita)` reveals that GDP per capital data is only available after 1990 (invlusive) and before 2017 (inclusive).
> > ```input
> > drop if year < 1990 | (year > 2017 & !missing(year)) 
> > ```
> > Note how we control for potential missing values in year to avoid the "missing greater than" gotcha.
> {: .solution}
{: .challenge}

> ## Challenge
> Create a decade variable with `generate decade = int(year/10)*10`. Aggregate the dataset by country and decade, keeping only the mean of each variable. Save this as `data/wdi_decades.dta`.
> > ## Solution
> > ```input
> > collapse (mean) gdp_per_capita life_expectancy merchandise_trade population population_density, by(countrycode decade)
> > ```
> {: .solution}
{: .challenge}

> ## Challenge
> Using the CEPII distance dataset, calculate for each country the average distance to other countries, naming this variable `average_distance`. Save the dataset as `data/average_distance.dta`.
> > ## Solution
> > ```input
> > use "data/dist_cepii.dta", clear
> > collapse (mean) average_distance = distw, by(iso_o)
> > save "data/average_distance.dta", replace
> > ```
> > Because the dataset is symmetric, it does not matter whether you use origin (`iso_o`) or destination (`iso_d`) country.
> {: .solution}
{: .challenge}

> ## Challenge
> Load the decadal WDI data. Merge the average distance measure for each country. 
> > ## Solution
> > ```input
> > use "data/wdi_decades.dta"
> > merge m:1 countrycode using "data/average_distance.dta"
> > ```
> > ```output
> > variable countrycode not found
> > r(111);
> > ```
> > The problem is that in the "using" dataset (`data/average_distance.dta`), country codes are called `iso_o`, not `countrycode`. Merge requires that the keys on which you are merging are called the same in both datasets.
> > ```input
> > use "data/wdi_decades.dta"
> > rename countrycode iso_o
> > merge m:1 iso_o using "data/average_distance.dta"
> > ```
> > ```output
> >     Result                           # of obs.
> >     -----------------------------------------
> >     not matched                           220
> >         from master                       195  (_merge==1)
> >         from using                         25  (_merge==2)
> >     matched                               597  (_merge==3)
> >     -----------------------------------------
> > ```
> {: .solution}
{: .challenge}


> ## Gotcha
> Never do a many-to-many, `m:m` merge. It does not do what you expect. You probably want to do a `joinby` instead.

> ## Challenge
>  
> > ## Solution
> {: .solution}
{: .challenge}


{% include links.md %}
