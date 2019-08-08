---
title: "Data Formats and Data Quality"
teaching: 0
exercises: 0
questions:
- "How do I read and write tabular data?"
- "How can I explore my data?"
- "How does Stata deal with variable names doesn't like?"
- "How does Stata handle missing values?"
objectives:
- "Determine and change your working directory in Stata."
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
- "Always use forward slash `/` in path names."
---

![The Stata interface]({{ "/img/interface.png" | relative_url }})

How do you find your current working directory? Check the bottom line of the Stata application window, or enter the command `pwd`.

![Two ways of checking your working directory]({{ "/img/pwd.png" | relative_url }})

> ## Backward or forward?
> On a Windows machine, Stata will display your working directory with a backslash (`\`) separating its components, like
> `C:\Users\koren\Dropbox\teaching\courses\2019\carpentries\stata-economics`.
> You should still refer to directories using a forward slash (`/`) to stay compatible with other platforms. The forward slash is understood by all three major platforms, whereas the backslash has a special meaning on Unix and Mac.
{: .callout}

```
cd data
```
{: .source}
```
/Users/koren/Dropbox/teaching/courses/2019/carpentries/stata-economics/data
```
{: .output}

```
ls
```
{: .source}
```
total 537216
-rwxr-xr-x@ 1 koren  staff     785984 Jul 10 15:20 WDICountry-Series.csv*
-rwxr-xr-x@ 1 koren  staff     169534 Jul 10 15:20 WDICountry.csv*
-rwxr-xr-x@ 1 koren  staff  213164145 Jul 10 15:21 WDIData.csv*
-rwxr-xr-x@ 1 koren  staff   49492815 Jul 10 15:21 WDIFootNote.csv*
-rwxr-xr-x@ 1 koren  staff      43570 Jul 10 15:21 WDISeries-Time.csv*
-rwxr-xr-x@ 1 koren  staff    3898578 Jul 10 15:21 WDISeries.csv*
-rw-r--r--@ 1 koren  staff    1909446 Mar 18  2014 dist_cepii.dta
```
{: .output}

FIXME: this will look different on a Windows machine

```
cd ..
```
{: .source}
```
/Users/koren/Dropbox/teaching/courses/2019/carpentries/stata-economics
```
{: .output}

![Open a Stata file]({{ "/img/open.png" | relative_url }})

```
use "/Users/koren/Dropbox/teaching/courses/2019/carpentries/stata-economics/data/dist_cepii.dta"
```
{: .source}


> ## Challenge
> If your current working directory is `/home/user/dc-economics`, which of the following can you use to load the data in `/home/user/dc-economics/data/dist_cepii.dta`?
> 1. `use "/home/user/dc-economics/data/dist_cepii.dta"`
> 2. `use "data/dist_cepii.dta"`
> 3. `use "/data/dist_cepii.dta"`
> 4. `use "data\dist_cepii.dta"`
> 5. `use "../dist_cepii.dta"`
> 
> > ## Solution
> > 1. Yes. You can always use the _absolute path_ of a datafile you want to load. It is good practice to put the filename inside double quotes to guard against problems caused by spaces and other special characters in filenames. Note, however, that your code may not run on someone else's computer where the absolute path is different.
> > 2. Yes. Here you are using a _relative path_. 
> > 3. No. This is an absolute path because it starts with `/`, but it is not the correct absolute path for `/home/user/dc-economics/data/dist_cepii.dta`.
> > 4. It depends. This will work on Windows, but not on Linux and Mac machines. Use forward slash, `/` instead.
> > 5. No. This would look for `dist_cepii.dta` in the directory `/home/user`, one level up from the current working directory, `/home/user/dc-economics`.
> {: .solution}
{: .challenge}

```
. bysort contig: summarize dist, detail 

---------------------------------------------------------------------------------------------
-> contig = 0

         simple distance (most populated cities, km)
-------------------------------------------------------------
      Percentiles      Smallest
 1%     509.7472       .9951369
 5%     1554.469       1.189416
10%     2449.292       1.407336       Obs              49,560
25%     4901.463       1.723628       Sum of Wgt.      49,560

50%     8167.061                      Mean           8573.666
                        Largest       Std. Dev.      4658.176
75%     12075.63       19904.45
90%     15305.38       19904.45       Variance       2.17e+07
95%     16741.36       19951.16       Skewness       .2599526
99%     18570.86       19951.16       Kurtosis       2.197631

---------------------------------------------------------------------------------------------
-> contig = 1

         simple distance (most populated cities, km)
-------------------------------------------------------------
      Percentiles      Smallest
 1%     85.94135       10.47888
 5%     172.7219       10.47888
10%     215.0746       59.61723       Obs                 616
25%     417.8577       59.61723       Sum of Wgt.         616

50%     789.7066                      Mean           1090.698
                        Largest       Std. Dev.      1004.337
75%     1357.383       5795.045
90%      2380.92       5795.045       Variance        1008693
95%     3277.169       6418.446       Skewness       2.030284
99%     4464.312       6418.446       Kurtosis       8.019088

```
{: .output}

`set more off, permanently`

```
bysort contig: summarize dist if dist<1000, detail 
```
{: .source}

> ## Never abbreviate
> A quirky feature of Stata is that it lets you abbreviate everything: commands, variable names, even file names. Abbreviation might save you some typing, but destroys legibility of your code, so please think of your coauthors and your future self and never do it. 
> ```
> u data
> g gdp_per_capita = 1
> ren gdp gdp
> ```
> {: .source}
> means the same as
> ```
> use "data.dta"
> generate gdp_per_capita = 1
> rename gdp_per_capita gdp
> ```
> {: .source}
> but the latter is much more explicit. The built-in editor of Stata 16 offers [tab completion](https://www.stata.com/new-in-stata/do-file-editor-autocompletion/) so you don't even have to type to write out the full command and variable names.
{: .callout}

```
. describe

Contains data from /Users/koren/Dropbox/teaching/courses/2019/carpentries/stata-economics/dat
> a/dist_cepii.dta
  obs:        50,176                          
 vars:            14                          8 Oct 2004 20:08
 size:     1,906,688                          
---------------------------------------------------------------------------------------------
              storage   display    value
variable name   type    format     label      variable label
---------------------------------------------------------------------------------------------
iso_o           str3    %9s                   ISO3 alphanumeric
iso_d           str3    %9s                   ISO3 alphanumeric
contig          byte    %8.0g                 1 for contiguity
comlang_off     byte    %8.0g                 1 for common official of primary language
comlang_ethno   byte    %8.0g                 1 if a language is spoken by at least 9% of the
                                                population in both countries
colony          byte    %8.0g                 1 for pairs ever in colonial relationship
comcol          byte    %8.0g                 1 for common colonizer post 1945
curcol          byte    %8.0g                 1 for pairs currently in colonial relationship
col45           byte    %8.0g                 1 for pairs in colonial relationship post 1945
smctry          byte    %9.0g                 1 if countries were or are the same country
dist            float   %9.0g                 simple distance (most populated cities, km)
distcap         float   %9.0g                 simple distance between capitals (capitals, km)
distw           double  %9.0g                 weighted distance (pop-wt, km)
distwces        double  %9.0g                 weighted distance (pop-wt, km) CES distances
                                                with theta=-1
---------------------------------------------------------------------------------------------
Sorted by: iso_o  iso_d
```
{: .output}

```
. rename iso_o iso_3166_alphanumeric_origin_country
1 new variable name invalid
    You attempted to rename iso_o to iso_3166_alphanumeric_origin_country.  That is an
    invalid Stata variable name.
r(198);
```
{: .output}

![help limits]({{ "/img/help-limits.png" | relative_url }})


```
. label variable iso_o "ISO3166 alphanumeric code of origin country"

. describe iso_o 

              storage   display    value
variable name   type    format     label      variable label
---------------------------------------------------------------------------------------------
iso_o           str3    %9s                   ISO3166 alphanumeric code of origin country

```
{: .output}

> ## Challenge
> Load `data/dist_cepii.dta`. Explore the variable `distw` (weighted average distance between cities in the pair of countries).
> 1. What is the unit of measurement?
> 2. What is the smallest and largest value?
> 3. In how many cases is this variable missing?
> 
> > ## Solution
> > 1. `describe distw` gives you the variable label "weighted distance (pop-wt, km)". It is hence recorded in kilometers. This command also shows that the variable is _double_, not _integer_.
> > 2. `summarize distw` shows that the distance varies between 0.995 and 19781.39 kilometers.
> > 3. `inspect distw` shows that `distw` is missing in 2,215 cases. This command also gives you the minimum and maximum values.
> {: .solution}
{: .challenge}

> ## Challenge
> Load `data/dist_cepii.dta`. Do you use `codebook` or `inspect` to check how many district countries are coded in `iso_d`?
> > ## Solution
> > ```
> > codebook iso_d
> > ```
> > {: .source}
> > ```
> > ----------------------------------------------------------------------------------------------------------------------
> > iso_d                                                                                                ISO3 alphanumeric
> > ----------------------------------------------------------------------------------------------------------------------
> > 
> >                   type:  string (str3)
> > 
> >          unique values:  224                      missing "":  0/50,176
> > 
> >               examples:  "CPV"
> >                          "HTI"
> >                          "MRT"
> >                          "SLV"
> > ```
> > {: .output}
> > `inspect` only works for numeric variables.
> > ```
> > inspect iso_d
> > ```
> > {: .source}
> > ```
> > iso_d:  ISO3 alphanumeric                       Number of Observations
> > -------------------------              ---------------------------------------
> >                                              Total      Integers   Nonintegers
> > |                            Negative            -             -             -
> > |                            Zero                -             -             -
> > |                            Positive            -             -             -
> > |                                      -----------   -----------   -----------
> > |                            Total               -             -             -
> > |                            Missing        50,176
> > +----------------------                -----------
> > .             -9.0e+307                     50,176
> >    (0 unique value)
> > ```
> > {: .output}
> {: .solution}
{: .challenge}


> ## Challenge
> Using the weighted distance between countries, count how many pairs of countries are farther than 15,000 km.
> > ## Solution
> > `count if distw > 15000 & !missing(distw)` gives you an answer of 5,070. If you use `count if distw > 15000`, you get 7,285. This is because Stata treats missing values as larger than any real number. It hence adds the 2,215 missing values.
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
{: .callout}

> ## Challenge
> Which of the following tells you how often the weighted distance is greater than the simple unweighted distance?
> ```
> count if dist < distw
> count if dist - distw < 0
> count if distw - dist > 0
> ```
> {: .source}
> > ## Solution
> > The second. When neither variable is missing, the three comparisons give the same answer. However, when `distw` has missing values, the first comparison evaluates to true, because missing values are greater than anything. The second comparison starts with a mathematical operation, which evaluates to missing and is hence *not* smaller than zero. 
> > As this property of missing values is a common *gotcha*, you should always explicitly test for missing values like so
> > ```
> > count if dist < distw & !missing(dist, distw)
> > ```
> > {: .source}
> {: .solution}
{: .challenge}


> ## Challenge
> Load `data/dist_cepii.dta`. Replace missing values in the variable `distw` with 0.
> ```
> use "data/dist_cepii.dta"
> mvencode distw, mv(0)
> ```
> {: .source}
> What happens?
> > ## Solution
> > You get an error message:
> > [OUTPUT]
> > To force the replacement of missing values with zero (which is an already existing value of `distw`), use `mvencode distw, mv(0) override`.
> {: .solution}
{: .challenge}

> ## Challenge
> Load `data/dist_cepii.dta`. If the variable `distw` is missing, replace it with the value from the variable `dist`.
> > ## Solution
> > ```
> > use "data/dist_cepii.dta"
> > replace distw = dist if missing(distw)
> > ```
> > {: .source}
> {: .solution}
{: .challenge}

Next we will read the World Development Indicators dataset. The data is in `data/WDIData.csv`. The other .csv files starting with `WDI` give some metadata. For example, `data/WDISeries.csv` describes the variables ("indicators" in World Bank speak), `data/WDICountry.csv` gives a codelist of countries, and `data/WDIFootnote.csv` includes footnotes.

> ## Challenge
> Import the World Development Indicator dataset from .csv format using the command `import delimited data/WDIData.csv`. What goes wrong and how can you fix it?
> 
> > ## Solution
> > Load the data and launch a data browser.
> > ```
> > import delimited "data/WDIData.csv"
> > browse
> > ```
> > {: .source}
> > You find that the variables are named `v1` through `v64` and the first row contains the actual variable names. 
> > ![Variable names are not read]({{ "/img/import-header.png" | relative_url }})
> > This is because WDI uses years for variable names, but Stata does not allow purely numeric variable names.
> > ![Variable names are not read]({{ "/img/import-header-2.png" | relative_url }})
> > You can force Stata to use the values in row 1 as variable names.
> > ```
> > import delimited "data/WDIData.csv", varnames(1) clear
> > ```
> > {: .source}
> > But since 1960, 1961, etc., are not valid variable names, these will still be called `v5` through `v64`.
> {: .solution}
{: .challenge}

> ## Challenge
> Explore the variables `v5`, `v63` and `v64`. Which years do they correspond to? Do they have missing values?
>
> > ## Solution
> > ```
> > inspect v5 v63 v64
> > ```
> > {: .source}
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
> > ```
> > {: .output}
> >
> {: .solution}
{: .challenge}



```
import delimited "data/WDICountry.csv", varnames(1) clear
```
{: .source}
```
. import delimited "data/WDICountry.csv", varnames(1) clear
(31 vars, 268 obs)
```
{: .output}

![Broken column]({{ "/img/csv-newline.png" | relative_url }})

`"Central Bureau of Statistics and Central Bank of Aruba ; Source of population estimates: UN Population Division's World Population Prospects 2019 PROVISIONAL estimates. Not for circulation. Subject to change. Mining is included in agriculture\n 
Electricty and gas includes manufactures of refined petroleoum products"`

```
. import delimited "data/WDICountry.csv", varnames(1) bindquotes(strict) clear
(31 vars, 263 obs)
```
{: .output}

There are 5 fewer lines. 

![CSV correctly parsed]({{ "/img/csv-correct.png" | relative_url }})

"Côte d'Ivoire" and "Curaçao" are misspelled.

![Wrong characters]({{ "/img/wrong-encoding.png" | relative_url }})

```
import delimited "data/WDICountry.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
```
{: .source}

```
. codebook latestpopulationcensus 

----------------------------------------------------------------------------------
latestpopulationcensus                                    Latest population census
----------------------------------------------------------------------------------

                  type:  string (str166)

         unique values:  34                       missing "":  46/263

              examples:  "1989"
                         "2010"
                         "2011"
                         "2014"

               warning:  variable has embedded blanks

```
{: .output}

From the examples, this looks like a numerical field, but is encoded as a 166-long string.

```
. tabulate latestpopulationcensus

               Latest population census |      Freq.     Percent        Cum.
----------------------------------------+-----------------------------------
                                   1943 |          1        0.46        0.46
                                   1979 |          1        0.46        0.92
                                   1984 |          2        0.92        1.84
                                   1987 |          1        0.46        2.30
                                   1989 |          1        0.46        2.76
                                   1997 |          1        0.46        3.23
                                   2001 |          1        0.46        3.69
                                   2002 |          2        0.92        4.61
                                   2003 |          2        0.92        5.53
                                   2004 |          2        0.92        6.45
                                   2005 |          2        0.92        7.37
                                   2006 |          3        1.38        8.76
                                   2007 |          3        1.38       10.14
                                   2008 |          7        3.23       13.36
                                   2009 |         11        5.07       18.43
2009. Population data compiled from a.. |          1        0.46       18.89
                                   2010 |         37       17.05       35.94
2010. Population data compiled from a.. |          1        0.46       36.41
2010. Population data compiled from a.. |          3        1.38       37.79
                                   2011 |         40       18.43       56.22
2011. Population data compiled from a.. |          9        4.15       60.37
2011. Population data compiled from a.. |          6        2.76       63.13
2011. Population figures compiled fro.. |          1        0.46       63.59
                                   2012 |         16        7.37       70.97
2012. Population data compiled from a.. |          2        0.92       71.89
                                   2013 |          7        3.23       75.12
                                   2014 |         11        5.07       80.18
                                   2015 |         12        5.53       85.71
2015. Population data compiled from a.. |          1        0.46       86.18
                                   2016 |         13        5.99       92.17
                                   2017 |         11        5.07       97.24
                                   2018 |          4        1.84       99.08
2018. Population data compiled from a.. |          1        0.46       99.54
          Guernsey: 2015; Jersey: 2011. |          1        0.46      100.00
----------------------------------------+-----------------------------------
                                  Total |        217      100.00
```
{: .output}

```
. destring latestpopulationcensus, generate(censusyear) force
latestpopulationcensus: contains nonnumeric characters; censusyear generated as int
(72 missing values generated)

. tabulate censusyear, missing

     Latest |
 population |
     census |      Freq.     Percent        Cum.
------------+-----------------------------------
       1943 |          1        0.38        0.38
       1979 |          1        0.38        0.76
       1984 |          2        0.76        1.52
       1987 |          1        0.38        1.90
       1989 |          1        0.38        2.28
       1997 |          1        0.38        2.66
       2001 |          1        0.38        3.04
       2002 |          2        0.76        3.80
       2003 |          2        0.76        4.56
       2004 |          2        0.76        5.32
       2005 |          2        0.76        6.08
       2006 |          3        1.14        7.22
       2007 |          3        1.14        8.37
       2008 |          7        2.66       11.03
       2009 |         11        4.18       15.21
       2010 |         37       14.07       29.28
       2011 |         40       15.21       44.49
       2012 |         16        6.08       50.57
       2013 |          7        2.66       53.23
       2014 |         11        4.18       57.41
       2015 |         12        4.56       61.98
       2016 |         13        4.94       66.92
       2017 |         11        4.18       71.10
       2018 |          4        1.52       72.62
          . |         72       27.38      100.00
------------+-----------------------------------
      Total |        263      100.00
```
{: .output}

```
. drop censusyear

. generate censusyear = real(substr(latestpopulationcensus, 1, 4))
(57 missing values generated)

. tabulate censusyear, missing

 censusyear |      Freq.     Percent        Cum.
------------+-----------------------------------
       1943 |          1        0.38        0.38
       1979 |          1        0.38        0.76
       1984 |          2        0.76        1.52
       1987 |          1        0.38        1.90
       1989 |          1        0.38        2.28
       1997 |          1        0.38        2.66
       2001 |          1        0.38        3.04
       2002 |          2        0.76        3.80
       2003 |          2        0.76        4.56
       2004 |          2        0.76        5.32
       2005 |          2        0.76        6.08
       2006 |          3        1.14        7.22
       2007 |          3        1.14        8.37
       2008 |          7        2.66       11.03
       2009 |         12        4.56       15.59
       2010 |         41       15.59       31.18
       2011 |         56       21.29       52.47
       2012 |         18        6.84       59.32
       2013 |          7        2.66       61.98
       2014 |         11        4.18       66.16
       2015 |         13        4.94       71.10
       2016 |         13        4.94       76.05
       2017 |         11        4.18       80.23
       2018 |          5        1.90       82.13
          . |         47       17.87      100.00
------------+-----------------------------------
      Total |        263      100.00

```
{: .output}

> ## Challenge
> Compare the number of missing values in the two tables above. Why are they different?
> > ## Solution
> > The first method, `destring` forces all values with non-numerical entries to be missing. This includes entries like "2011. Population data compiled from administrative registers." The second method, converting the first four characters of the string to a number, can parse this entry as 2011 and these entries will not be missing.
When the destring replace or destring generate method was unsuccessful Stata doesn't quit with an error code. What you got is a feedback to the viewer window like `contains nonnumeric characters; no replace`. We would recommend you to use destring along with `assert` command. 
> {: .solution}
{: .challenge}


{% include links.md %}

