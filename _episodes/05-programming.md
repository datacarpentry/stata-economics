---
title: "Save and Reuse your Work in .do Files"
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
- "Log your results window."
- "Understand and use local macros."
keypoints:
- "Add commands to a .do file."
- "Run .do files _en bloc_, not by parts." 
- "Check what directory you are running .do files from."
---

## Running .do files

Save the .do file in the editor as `read_reshape_gdp.do`. 

Create a `code` folder inside your project folder `dc-economics` and put it there. 

You can use basic shell commands such as `cd`, `pwd`, `ls` and `mkdir` in Stata. 
```
pwd
mkdir code
```
{: .source}

To run the .do file, use the `do` command.

```
do code/read_reshape_gdp.do
```
{: .source}

```
. do code/read_reshape_gdp.do

. import delimited "https://raw.githubusercontent.com/korenmiklos/dc-economics-data/mas
> ter/data/web/gdp.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
(31 vars, 264 obs)

. reshape long gdp, i(countrycode) j(year)
(note: j = 1990 1991 1992 1993 1994 1995 1996 1997 1998 1999 2000 2001 2002 2003 2004 2
> 005 2006 2007 2008 2009 2010 2011 2012 2013 2014 2015 2016 2017 2018)

Data                               wide   ->   long
-----------------------------------------------------------------------------
Number of obs.                      264   ->    7656
Number of variables                  31   ->       4
j variable (29 values)                    ->   year
xij variables:
            gdp1990 gdp1991 ... gdp2018   ->   gdp
-----------------------------------------------------------------------------

. rename gdp gdp_per_capita

. save "data/derived/gdp_per_capita.dta"
file data/derived/gdp_per_capita.dta already exists
r(602);

end of do-file

r(602);
```
{: .error}

The .do file is executed line by line and we see its output as Stata executes. 

As in [Episode 3]({{ "/03-transform-data/" | relative_url }}), Stata lets us know that the file already exists and is unwilling to replace it. As we are using a .do file to create this file, it is totally safe to overwrite. If we make an error, we can fix it and rerun `do code/read_reshape_gdp.do`. That is the whole point of .do files; to make your work more reproducible.

Change the last line of the .do file to `save "data/derived/gdp_per_capita.dta", replace` and rerun it.

```
. save "data/derived/gdp_per_capita.dta", replace
file data/derived/gdp_per_capita.dta saved
```
{: .output}

> # Never execute just part of a .do file
> ![Never do this]({{ "/img/not-by-part.png" | relative_url }}) 
> The .do file editor lets you execute selected lines from your .do file. Never do this. You will not know what state your data is in before clicking that button and you may forget to execute the rest of your .do file. For example, you may omit a crucial `save` command and your data will be lost. Always execute your .do file in its entirety from the command line by running `do code/read_wdi_variables.do`.
> 
> If you are tempted to run your .do file by parts, it is a good indication that it is too long. Try breaking it up into multiple .do files.
{: .callout}

> ## Challenge
> Change you current working directory to `/home/user/dc-economics/data`. How can you run the .do file at `/home/user/dc-economics/code/read_reshape_gdp.do`?
>
> > ## Solution
> > You can run the .do file with its relative path, `do "../code/read_reshape_gdp.do"`. However, the last command uses a relative path, `data/derived/gdp_per_capita.dta`. Starting from the current directory, it would save the dataset under `data/data/derived/gdp_per_capita.dta`, a nonexistent directory! Change to the upper level directory first.
> > ```
> > cd ..
> > do "code/read_reshape_gdp.do"
> > ```
> > {: .source}
> {: .solution}
{: .challenge}

Your .do file begins with loading a dataset and ends with saving one. It leaves no other trace.

> ## Happy Together... ♪
> Mistakes often happen and you should be prepared to minimize them. 
> 1. Never modify the raw data files. Save the results of your data cleaning in a new file.
> 2. Every data file is created by a script. Convert your interactive data cleaning session to a .do file.
> 3. No data file is modified by multiple scripts.
> 4. Intermediate steps are saved in different files (or kept in temporary files) than the final dataset.
> 
> The goal of these rules is that you can unambiguously answer the question "how was this data file created?" You will pose this question countless times even if you work by yourself. 
>
> Under these rules, most of your .do files will begin with `use ..., clear` and end with `save ..., replace`. You have automated your work and should not be afraid to use the options `clear` and `replace`. You will also use "destructive" commands like `keep`, `drop`, `collapse` and `reshape` more freely.
{: .discussion}

> ## Challenge
> What is wrong with the following .do file?
> ```
> ...
> rename gdp gdp_per_capita
> save "data/derived/gdp_per_capita.dta"
> label variable gdp_per_capita "GDP per capita (2011 USD at PPP)"
> save "data/derived/gdp_per_capita.dta"
> ```
> {: .error}
> > ## Solution
> > There is no error in the .do file but it saves two different versions of `gdp_per_capita.dta` under the same name. You cannot be sure which version the data file has. For example, if the command `label` fails with an error, the .dta file will not contain the variable label, and you will be surprised.
> {: .solution}
{: .challenge}

## Break up your work (optional)

We are loading a dataset from the web. For larger datasets, this can be frustratingly slow and we do not want to redo it every time we change something in our .do file. We can put this step in a separate .do file.

The `copy` command is similar to the Shell command `cp` in that `copy x y` copies a file from location `x` to location `y`. But Stata's copy command has the added feature that it can also copy from a URL.

```
mkdir "data/raw"
copy "https://raw.githubusercontent.com/korenmiklos/dc-economics-data/master/data/web/gdp.csv" "data/raw/gdp.csv"
```
{: .source}

Keep raw data separate from data that you are working on to make sure you do not accidentally overwrite it. Even though you are only running this `copy` command once, add it to a .do file. This is a record of what you did: where you downloaded the data from and where you put it.

> ## Challenge
> Create two .do files, `read_gdp.do` and `reshape_gdp.do` to create a local copy of the GDP data and to reshape and save it, respectively.
> > ## Solution
> > The content of `code/read_gdp.do`:
> > ```
> > copy "https://raw.githubusercontent.com/korenmiklos/dc-economics-data/master/data/web/gdp.csv" "data/raw/gdp.csv"
> > ```
> > {: .source}
> > (Note the `mkdir` is not included.) The content of `code/reshape_gdp.do`:
> > ```
> > import delimited "data/raw/gdp.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
> > reshape long gdp, i(countrycode) j(year)
> > rename gdp gdp_per_capita
> > save "data/derived/gdp_per_capita.dta"
> > ```
> > {: .source}
> {: .solution}
{: .challenge}

When you change something in your data cleaning (for example, you add variable labels), you only have to rerun the second .do file.

If you have many .do files (you should!), you should note the order in which they have to be run. One way to do that is to create a "master" .do file, which calls every other .do file. This also shows your coauthor how to run your code. For example, the master .do file below makes it explicit that `read_gdp.do` and `reshape_gdp.do` expect to be run from outside the `code` folder. You can also note it in a comment.

```
* run this from the main project folder, one level up from data/ and code/
do code/read_gdp.do
do code/reshape_gdp.do
```
{: .source}

Another useful convention is to number your .do files in the order in which they run, `01_read_gdp.do`, `02_reshape_gdp.do`. This is super helpful to get a quick overview of how to run your code, but does not quite substitute for a master .do file and comments. 

## Scalars and macros

Macros are useful for storing values and reusing them later. They are the most powerful feature of Stata programming.

There are two types of macros, local and global.  Local macros are valid only in a single
execution of commands in do-files.  Global macros will persist until you delete them or the session is ended.
We recommend the use of local macros and this is what we cover first.

```
. local begin_year 1991
. local name value
. display `begin_year'
1991
. display "`name'"
value
```
{: .output}

Use backticks and single quote to evaluate a macro "name" to its "value."

```
. display `begin_year`
`begin_year` invalid name
r(198);

. display 'begin_year'
'begin_year' invalid name
r(198);

```
{: .error}

Macros are evaluated as part of the command. They are not a variable.

```
. local name value
. display `name'
value not found
r(111);
```
{: .error}

The second line evaluates to `display value` and Stata does not have any object called "value."

Because macros are evaluated before a command is run, they can part of the command.
```
. local begin_year 1991
. local outcome gdp_per_capita 
. summarize `outcome' if year >= `begin_year'

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |      6,251    15331.78    17967.28   354.2845   135318.8

. summarize gdp_per_capita if year >= 1991

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
gdp_per_ca~a |      6,251    15331.78    17967.28   354.2845   135318.8

```
{: .output}

The last two lines do exactly the same.

The macro can be any part of the command, you can attach it to variable names, for example.

```
. local entity country

. describe `entity'code

              storage   display    value
variable name   type    format     label      variable label
----------------------------------------------------------------------------------
countrycode     str3    %9s                   Country Code

. describe `entity'name

              storage   display    value
variable name   type    format     label      variable label
----------------------------------------------------------------------------------
countryname     str52   %52s                  Country Name

```
{: .output}

> ## Gotcha
> Stata does not stop if you use an undefined macro name. It simply uses an empty string for its value. Watch out for typos in macro names!
> ```
> . describe `enty'name
> variable name not found
> r(111);
> ```
> {: .error}
{: .callout}

> ## Challenge
> What does the following code do?
> ```
> local A a
> local B 4
> generate `A' = `B'
> ```
> {: .source}
> 1. Creates a variable called `A` with the value 4.
> 2. Creates a variable called `a` with the value 4.
> 3. Creates a variables called `A` with the value "B".
> 4. Creates a variables called `a` with the value "B".
>
> > ## Solution
> > The correct is 2.
> {: .solution}
{: .challenge}

> ## Challenge
> What does the following code do?
> ```
> local A a
> local B 4
> generate `A' = `B'
> local C c
> generate `C' = `A' + `B'
> ```
> {: .source}
> 1. Creates a variable called `c` with the value 4.
> 2. Creates a variable called `c` with the value "AB".
> 3. Creates a variables called `C` with the value 8.
> 4. Creates a variables called `c` with the value 8.
>
> > ## Solution
> > The correct is 4. `` `A'`` evaluates to `a`, which is a variable with the value 4. `` `B'`` evaluates to 4, so the variable `c` becomes 8.
> {: .solution}
{: .challenge}

```
use "data/derived/gdp_per_capita.dta", clear
local begin_year 1991
local end_year 2010
keep if (year >= `begin_year') & (year <= `end_year') 
```
{: .source}

> ## Challenge (optional)
>
> Use `data/derived/gdp_per_capita.dta` and create an index of GDP per capita for each country in each year, relative to year base year 2000. Store base > year in a local macro that is calle `base_year`. This index should take the value 100 in the base year.
>
> > ## Solution
> > ```
> > use "data/derived/gdp_per_capita.dta", clear
> > local base_year 2000
> > egen gdp_per_capita_`base_year' = mean(cond(year == `base_year', gdp_per_capita, .)), by(countrycode)
> > generate gdp_per_capita_index = gdp_per_capita / gdp_per_capita_`base_year' * 100
> > ```
> > {: .source}
> {: .solution}
{: .challenge}



{% include links.md %}
