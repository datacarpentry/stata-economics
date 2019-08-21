---
title: "Repeat Tasks with Loops"
teaching: 0
exercises: 0
questions:
- "How can I minimize bugs in my code?"
objectives:
- "Automate repetitive tasks using `foreach` and `forvalues`."
keypoints:
- "Do not copy-paste your own code."
- "Use for loops to automate anything that happens more than twice."
---

## For loops
Sometimes you will need to do repetitive tasks in the process of data manipulation and analysis. Loops are a way to avoid repeating the same code multiple times.

```
. forvalues i = 1/5 {
  2.     display `i'
  3. }
1
2
3
4
5

```
{: .output}

You should always place the curly braces to open and close the loop. The indentation is optional, but helps read your code better, especially with nested loops.

```
. forvalues i = 1/5
{ required
r(100);
```
{: .error}

We can use multiple commands inside the loop.

```
. forvalues i = 1/5 {
  2.     display `i'
  3.     display 6 - `i'
  4. }
1
5
2
4
3
3
4
2
5
1
```
{: .output}

> ## Challenge
> What would be the output of
> ```
> forvalues i = 0/4 {
>     display `i', 5*`i'  
> }
> ```
> {: .source}
> > ## Solution
> > ```
> > 0 0
> > 1 5
> > 2 10
> > 3 15
> > 4 20
> > ```
> > {: .output}
> {: .solution}
{: .challenge}


You can use the loop variable in any command, in any place.

```
. use /data/WDI-select-variables.dta", clear

.forvalues t = 2010/2017 {
  2.    summarize gdp_per_capita if year == `t'
  3. }

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        239       17122    18892.45    660.211   125140.8

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        242    17372.16    19354.81   682.4322   129349.9

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        239    17645.64    19386.14    706.798   125302.1

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        239    17833.08    19529.57    593.056   135318.8

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        238    17885.82    19371.79   597.1352   130755.2

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        237    18017.96     18936.6   621.5698   119872.6

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        237    18227.89    18957.92   642.8735   118222.4

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        235    18567.77    19230.34     661.24     116932
```
{: .output}

The loop variable is not displayed, so we may not know where the loop is currently unless we explicitly display it.

```
. forvalues t = 2010/2017 {
  2.     display `t'
  3.     summarize gdp_per_capita if year == `t'
  4. }
2010

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        239       17122    18892.45    660.211   125140.8
2011

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        242    17372.16    19354.81   682.4322   129349.9
2012

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        239    17645.64    19386.14    706.798   125302.1
2013

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        239    17833.08    19529.57    593.056   135318.8
2014

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        238    17885.82    19371.79   597.1352   130755.2
2015

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        237    18017.96     18936.6   621.5698   119872.6
2016

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        237    18227.89    18957.92   642.8735   118222.4
2017

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |        235    18567.77    19230.34     661.24     116932

```
{: .output}

Note that the loop variable is a macro, not a scalar. This helps us write code where the loop variable is part of a variable name or is on the left-hand side.

```
. forvalues i = 1/5 {
  2.     generate gdp_`i' = gdp_per_capita^`i'
  3. }
(9,381 missing values generated)
(9,381 missing values generated)
(9,381 missing values generated)
(9,381 missing values generated)
(9,381 missing values generated)

. su gdp_?

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
       gdp_1 |      6,459    15209.41    17872.38   354.2845   135318.8
       gdp_2 |      6,459    5.51e+08    1.42e+09   125517.5   1.83e+10
       gdp_3 |      6,459    3.13e+13    1.38e+14   4.45e+07   2.48e+15
       gdp_4 |      6,459    2.33e+18    1.49e+19   1.58e+10   3.35e+20
       gdp_5 |      6,459    2.06e+23    1.71e+24   5.58e+12   4.54e+25
```
{: .output}

> ## Challenge
> Write a loop that display the first five square numbers. 
> > ## Solution
> > ```
> > . forvalues i = 1/5 {
> >   2.     display `i'^2
> >   3. }
> > 1
> > 4
> > 9
> > 16
> > 25
> > ```
> > {: .output}
> {: .solution}
{: .challenge}

You can set the step size of the loop.

Create an indicator variable for each decade.

```
forvalues decade = 1960(10)2010 {
    generate decade`decade' = (int(year / 10) * 10 == `decade')
}
```
{: .source}

The loop variable increases in step size 10. Note the use of a boolean formula. Whenever it evaluates to true, its value will be 1, otherwise 0.

![Decade indicator variables]({{ "/img/decade-loop.png" | relative_url }})

You can also loop over a list of arbitrary strings, but note the different syntax.

```
. foreach fruit in apple banana carrot {
  2.     display "`fruit'"
  3. }
apple
banana
carrot
```
{: .output}

 Note that loop variable is given the name `fruit`. We can choose any name we want for the looping variables. We might have named it  `unicorn`  and the loop would still work, as long as we correctly invoke the variable inside the loop:

The loop variable is still a macro and is evaluated as part of the command.

```
. foreach fruit in apple banana carrot {
  2.     display `fruit'
  3. }
apple not found
r(111);
```
{: .error}

The error is that in the first run, `fruit` evaluates to `apple`, and Stata would like to run `display apple`. There is no variable or scalar with the name `apple`, so we receive an error.

Note that the error breaks the loop.

The separator in the list is the space. If one of your list elements has spaces, use double quotes.

```
. foreach fruit in apple banana carrot "dragon fruit" {
  2.     display "`fruit'"
  3. }
apple
banana
carrot
dragon fruit
```
{: .output}

> ## Challenge
> What would be the output of
> ```
> foreach fruit in apple banana carrot dragon fruit {
>     display "`fruit'"  
> }
> ```
> {: .source}
> > ## Solution
> > ```
> > apple
> > banana
> > carrot
> > dragon
> > fruit
> > ```
> > {: .output}
> {: .solution}
{: .challenge}


> ## Challenge
> What would be the output of
>```
>foreach fruit in apple banana carrot {
>    display "`fruit' with `fruit's"
>}
>```
> > ## Solution
> > ```
>> .  foreach fruit in apple banana carrot {
>>   2.      display "`fruit's with `fruit's"
>>   3.  }
>> apples with apples
>> bananas with bananas
>> carrots with carrots
> > ```
> > {: .output}
> {: .solution}
{: .challenge}


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
local base_year 1991
foreach var in gdp_per_capita population {
    egen `var'_`base_year' = mean(cond(year == `base_year', `var', .)), by(countrycode)
    generate `var'_indevar = `var' / `var'_`base_year' * 100
}
```
{: .source}

We can also loop over variables rather than arbitrary words.

```
foreach var of varlist gdp_per_capita population {
    egen `var'_`base_year' = mean(cond(year == `base_year', `var', .)), by(countrycode)
    generate `var'_index = `var' / `var'_`base_year' * 100
}
```
{: .source}

Use for loops to ensure consistency and to minimize the risk the errors, not to save typing. Note that `var' appears on both sides. It is a macro that is evaluated before the command is run, so it can become part of the variable name.

```
foreach var of varlist *_index {
    generate log_`var' = log(`var' / 100)
}
```
{: .source}


You can reuse the loop variable later in different loops. Note the use of variable name wildcards.

```
foreach X of varlist population* {
	forvalues i = 1/5 {
		generate `X'_`i'= `X'^`i'
		label variable  `X'_`i' "`X', polynomial of order `i'"
		}
}
```

{% include links.md %}
