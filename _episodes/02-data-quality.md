---
title: "Data Formats and Data Quality"
teaching: 0
exercises: 0
questions:
- "How do I read tabular data?"
- "How does Stata handle missing values?"
objectives:
- "Import spreadsheet data."
- "Convert strings to numerical variables."
- "Deal with missing values."
keypoints:
- "Use the missing value feature of Stata, not a numerical code."
- "Test for missing values with the `missing` function."
- "In Stata expressions, missing values are greater than any number. Functions of missing values are missing value."
- "Check CSV files for separator, variable names, and character encoding."
---

## Read a .csv file

Next we will read the World Development Indicators dataset. The data is in `data/WDIData.csv`. The other .csv files starting with `WDI` give some metadata. For example, `data/WDISeries.csv` describes the variables ("indicators" in World Bank speak), `data/WDICountry.csv` gives a codelist of countries, and `data/WDIFootnote.csv` includes footnotes.

> ## Challenge
> Import the World Development Indicator dataset from .csv format using the command `import delimited data/WDIData.csv`. What goes wrong and how can you fix it?
> 
> > ## Solution
> > Load the data and launch a data browser.
> > ```
> > import delimited "data/WDIData.csv", clear
> > browse
> > ```
> > {: .source}
> > You find that the variables are named `v1` through `v64` and the first row contains the actual variable names. 
> > ![Variable names are not read]({{ "/img/import-header.png" | relative_url }})
> > This is because WDI uses years for variable names, but Stata does not allow purely numeric variable names.
> > ![Variable names are not read]({{ "/img/import-header-2.png" | relative_url }})
> > You can have Stata use the values in row 1 as variable names by using varnames option.
> > ```
> > import delimited "data/WDIData.csv", varnames(1) clear
> > ```
> > {: .source}
> > Note that we are using multiple options for the command.
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
> >   (0 unique value)
> > ```
> > {: .output}
> >
> {: .solution}
{: .challenge}

Reading text data from .csv files can be even more challeging. Let us read the country names and characteristics.

```
import delimited "data/WDICountry.csv", varnames(1) clear
```
{: .source}
```
. import delimited "data/WDICountry.csv", varnames(1) clear
(31 vars, 268 obs)
```
{: .output}

As always, we look at the data first.

![Broken column]({{ "/img/csv-newline.png" | relative_url }})

There are some things that do not belong to the `countrycode` variable. Indeed they look like entire parts of a .csv line. 

FIXME: use this file in shell lesson

After going out to the shell and exploring the file there (for example, `head data/WDICountry.csv`), we will find a text variable is splt on multiple lines. This may strip up `import delimited`.

`"Central Bureau of Statistics and Central Bank of Aruba ; Source of population estimates: UN Population Division's World Population Prospects 2019 PROVISIONAL estimates. Not for circulation. Subject to change. Mining is included in agriculture\n 
Electricty and gas includes manufactures of refined petroleum products"`

```
. import delimited "data/WDICountry.csv", varnames(1) bindquotes(strict) clear
(31 vars, 263 obs)
```
{: .output}

There are 5 fewer lines and the dataset looks fine.

![CSV correctly parsed]({{ "/img/csv-correct.png" | relative_url }})

But browsing further down, we find "Côte d'Ivoire" and "Curaçao" are misspelled. 

![Wrong characters]({{ "/img/wrong-encoding.png" | relative_url }})

The characters `Ã` and `Å` are often indicative that the [encoding of the text is UTF-8](https://en.wikipedia.org/wiki/UTF-8). We can set the encoding as an option to `import delimited`.

```
import delimited "data/WDICountry.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
```
{: .source}

## Variable types 

Now all variables are read, but are variables of the proper type?

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

FIXME: add a section on types: `byte`, `int`, `long` (sometimes you need to declare long), `str`
FIXME: introduce `generate` more gently. show how entire column is changed?


FIXME: destring, assert -> error

What are the non-numeric values?

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

FIXME: introduce 1 function at a time.
FIXME: introduce a chain of functions

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

FIXME: regex may be an extra layer of complexity at this stage. 
Answer: I actually think it's something they should keep in mind. This dataset is relatively "clean" but in other cases the format of the date might not be very "convenient". And, I like the elegance of the subexpression but I think the smooth intro to regexp would be by saying that I'm looking for `\d\d\d\d` pattern in the string. Is there anyway this can be written more concisely? In Python you can do something like \d{4} to tell Python to look for 4 digits in the string. 

If the year is placed anywhere in the string, we can use [regular expressions](https://en.wikipedia.org/wiki/Regular_expression) to extract the year in string format and convert the string to a numeric variable as we did above.


```
. generate year_string = regexs(0) if regexm(latestpopulationcensus, "[0-9][0-9][0-9][0-9]") 
(46 missing values generated)

. generate year = real(year_string)
(46 missing values generated)

. 
. tabulate year, missing

       year |      Freq.     Percent        Cum.
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
       2015 |         14        5.32       71.48
       2016 |         13        4.94       76.43
       2017 |         11        4.18       80.61
       2018 |          5        1.90       82.51
          . |         46       17.49      100.00
------------+-----------------------------------
      Total |        263      100.00
```
{: .output}

> ## Challenge
> Compare the number of missing values in the tables above. Why are they different? What does the regular expression do?
>
> > ## Solution
> > With the first method, `destring` and the option force we have forced all values with non-numerical entries to be missing. This includes entries like "2011. Population data compiled from administrative registers." The second method, converting the first four characters of the string to a number, can parse this entry as 2011 and these entries will not be missing. The third method, will match four digits in the string. Note that it will only grab the first four digits that it encounters, in this case it would be year 2015 for countrycode=="CHI", Channel Islands, and corresponds to Guernsey. In order to grab year 2011 which corresponds to Jersey, 2011 the regular expression needs to get modified.
> {: .solution}
{: .challenge}

In general, we recommend against using `force` options with Stata commands as it might lead to errors. 

## Missing values

FIXME: rewrite examples for this dataset

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

FIXME: move this challenge later

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

FIXME: move missing values to data quality?

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
As this property of missing values is a common *gotcha*, it is recommended to always explicitly test for missing values.
> > ```
> > count if dist < distw & !missing(dist, distw)
> > ```
> > {: .source}
> {: .solution}
{: .challenge}


> ## Challenge
> Load `data/dist_cepii.dta`. Replace missing values in the variable `distw` with the mean of the variable.
> > ## Solution
> > ```
> > . use "data/dist_cepii.dta", clear
> > 
> > . summarize distw, detail
> > 
> >                weighted distance (pop-wt, km)
> > -------------------------------------------------------------
> >       Percentiles      Smallest
> >  1%     443.9466       .9951369
> >  5%     1380.288       1.723628
> > 10%     2258.153       2.225194       Obs              47,961
> > 25%     4687.852       6.225999       Sum of Wgt.      47,961
> > 
> > 50%     8006.123                      Mean           8392.728
> >                         Largest       Std. Dev.      4670.531
> > 75%     11894.69       19735.32
> > 90%     15155.13       19735.32       Variance       2.18e+07
> > 95%     16614.14       19781.39       Skewness       .2676779
> > 99%     18424.84       19781.39       Kurtosis       2.183358
> > 
> > . mvencode distw, mv(8392.728)
> >        distw: 2215 missing values recoded
> > 
> > ```
> > {: .output}
> > In Episode 4, we will see how to reuse the results of a previous command (`summarize`) in the next one (`mvencode`) programmatically.
> {: .solution}
{: .challenge}

FIXME: mvencode example with error

> ## Challenge what happens when you use the mvencode command to replace missing values with a value that already exists?
> > ## Solution
> > You get an error message:
> > [OUTPUT]
> > To force the replacement of missing values with zero (which is an already existing value of `distw`), use `mvencode distw, mv(value) override`.
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

Missing values are excluded from the statistical analyses by default; some commands will permit inclusion of missing values via options. Always be cautious when dealing with missing values and their replacement.  

{% include links.md %}

