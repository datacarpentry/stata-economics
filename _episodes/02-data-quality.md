---
title: "Data Formats and Data Quality"
teaching: 0
exercises: 0
questions:
- "How do I read and write tabular data?"
- "How does Stata handle missing values?"
objectives:
- "Import and export spreadsheet data."
- "Convert strings to numerical variables."
- "Deal with missing values."
keypoints:
- "Use the missing value feature of Stata, not a numerical code."
- "Test for missing values with the `missing` function."
- "In Stata expressions, missing values are greater than any number. Functions of missing values are missing value."
- "Check CSV files for separator, variable names, and character encoding."
---


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

FIXME: multiple lines instead of line break

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

FIXME: regex may be an extra layer of complexity at this stage.

If the year is placed anywhere in the string, we can use [regular expressions](https://en.wikipedia.org/wiki/Regular_expression) to extract the year in string format and convert the string to a numeric variable as we did above.


```
. generate year_string = regexs(0) if regexm(latestpopulationcensus, "(19|20)[0-9][0-9]") 
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

> > ## Solution
> > The first method, `destring` forces all values with non-numerical entries to be missing. This includes entries like "2011. Population data compiled from administrative registers." The second method, converting the first four characters of the string to a number, can parse this entry as 2011 and these entries will not be missing.
> {: .solution}
{: .challenge}


{% include links.md %}

