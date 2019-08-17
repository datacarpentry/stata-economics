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

`describe` shows the type of each variable.
```
. describe

Contains data
  obs:           263                          
 vars:            31                          
 size:       644,613                          
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
----------------------------------------------------------------------------------------------------------------------
Sorted by: 
     Note: Dataset has changed since last saved.
```
{: .output}

`countrycode` is `str3`, a 3-letter string. `alphacode` is `str2`, a 2-letter code. `latesttradedata` is `int`.

![numeric types]({{ "/img/types.png" | relative_url }})

Year is an `int`, because it is less than 32,740 but greater than 100. When we create dummies (0/1 indicator variables), we can safely declare them as `byte` to save space.

```
generate byte low_income = (incomegroup == "Low income")
```
{: .source}

Beware of long integers, such as numerical identifiers. These may easily be greater than 32,740 and have to be declared to be long.

```
generate long identifier = 12345678
```
{: .source}

Note that `generate` creates a new variable and we have filled it with a constant value, 12345678. 

![Fill an entire column with a value]({{ "/img/generate.png" | relative_url }})

To give each observation its separate value, we need to use a function of other variables (like we defined `low_income`), read the data from a file, or merge a variable from another data file (see later). It is possible to change the value of a variable for a single observation, but why would you do that?

Identifiers sometimes have leading zeros, in which case it may be helpful to store them as string.

```
. generate str leading_zero_id = 01234567
type mismatch
r(109);
```
{: .error}

Strings always have to encapsulated in `""`.
```
. generate str leading_zero_id = "01234567"
```
{: .output}

Back to `latestpopulationcensus`. Because it looks like a numerical variable, we try to convert it from string.

```
. destring latestpopulationcensus, generate(censusyear)
latestpopulationcensus: contains nonnumeric characters; no generate
```
{: .error}

`destring` encountered an error (even if Stata does not display this as a red error message). What are the non-numeric values?

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

We can force `destring` to ignore these non-numeric entries (this may not be such a great idea). 

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

In general, we recommend against using `force` options with Stata commands as it might lead to errors. 

Or we can write a function that extracts the year from the text. The function `substr` extracts a portion of a string variable.

```
. drop censusyear

. generate censusyear_string = substr(latestpopulationcensus, 1, 4)
(46 missing values generated)

. generate censusyear = real(censusyear_string)
(47 missing values generated)

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

We can nest functions and write the conversion in one step
```
generate censusyear = real(substr(latestpopulationcensus, 1, 4))
```
{: .source}

> ## Challenge
> Compare the number of missing values in the tables above. Why are they different? 
>
> > ## Solution
> > With the first method, `destring` and the option force we have forced all values with non-numerical entries to be missing. This includes entries like "2011. Population data compiled from administrative registers." The second method, converting the first four characters of the string to a number, can parse this entry as 2011 and these entries will not be missing.
> {: .solution}
{: .challenge}


> ## Challenge
> Extract the national accounts base year as a number from the text variable `nationalaccountsbaseyear`.
> > ## Solution
> > 
> > ```
> > . tabulate nationalaccountsbaseyear 
> > 
> >             National accounts base year |      Freq.     Percent        Cum.
> > ----------------------------------------+-----------------------------------
> >                                    1954 |          1        0.49        0.49
> >                                    1974 |          1        0.49        0.97
> >                                    1984 |          1        0.49        1.46
> >                                    1985 |          1        0.49        1.94
> >                                 1986/87 |          1        0.49        2.43
> >                                    1990 |          4        1.94        4.37
> >                                    1992 |          1        0.49        4.85
> >                                    1994 |          1        0.49        5.34
> >                                    1996 |          1        0.49        5.83
> >                                    1997 |          2        0.97        6.80
> >                                    1998 |          1        0.49        7.28
> >                                    1999 |          2        0.97        8.25
> >                                    2000 |          9        4.37       12.62
> >                                 2000/01 |          1        0.49       13.11
> >                                    2001 |          1        0.49       13.59
> >                              20015/2016 |          1        0.49       14.08
> >                                    2002 |          2        0.97       15.05
> >                                 2002/03 |          1        0.49       15.53
> >                                    2003 |          1        0.49       16.02
> >                                    2004 |          5        2.43       18.45
> >                                    2005 |          9        4.37       22.82
> >                                 2005/06 |          2        0.97       23.79
> >                                    2006 |         16        7.77       31.55
> >                                    2007 |         15        7.28       38.83
> >                                    2008 |          2        0.97       39.81
> >                                 2008/09 |          1        0.49       40.29
> >                                    2009 |          6        2.91       43.20
> >                                 2009/10 |          1        0.49       43.69
> >                                    2010 |         25       12.14       55.83
> >                                    2011 |          5        2.43       58.25
> >                                 2011/12 |          2        0.97       59.22
> >                                    2012 |          5        2.43       61.65
> >                                    2013 |          5        2.43       64.08
> >                                    2014 |          4        1.94       66.02
> >                                    2015 |          4        1.94       67.96
> > Original chained constant price data .. |         66       32.04      100.00
> > ----------------------------------------+-----------------------------------
> >                                   Total |        206      100.00
> > 
> > . generate national_accounts_base_year = real(substr(nationalaccountsbaseyear, 1, 4))
> > (123 missing values generated)
> > 
> > . tabulate national_accounts_base_year, missing
> > 
> > national_ac |
> > counts_base |
> >       _year |      Freq.     Percent        Cum.
> > ------------+-----------------------------------
> >        1954 |          1        0.38        0.38
> >        1974 |          1        0.38        0.76
> >        1984 |          1        0.38        1.14
> >        1985 |          1        0.38        1.52
> >        1986 |          1        0.38        1.90
> >        1990 |          4        1.52        3.42
> >        1992 |          1        0.38        3.80
> >        1994 |          1        0.38        4.18
> >        1996 |          1        0.38        4.56
> >        1997 |          2        0.76        5.32
> >        1998 |          1        0.38        5.70
> >        1999 |          2        0.76        6.46
> >        2000 |         10        3.80       10.27
> >        2001 |          2        0.76       11.03
> >        2002 |          3        1.14       12.17
> >        2003 |          1        0.38       12.55
> >        2004 |          5        1.90       14.45
> >        2005 |         11        4.18       18.63
> >        2006 |         16        6.08       24.71
> >        2007 |         15        5.70       30.42
> >        2008 |          3        1.14       31.56
> >        2009 |          7        2.66       34.22
> >        2010 |         25        9.51       43.73
> >        2011 |          7        2.66       46.39
> >        2012 |          5        1.90       48.29
> >        2013 |          5        1.90       50.19
> >        2014 |          4        1.52       51.71
> >        2015 |          4        1.52       53.23
> >           . |        123       46.77      100.00
> > ------------+-----------------------------------
> >       Total |        263      100.00
> > ```
> > {: .output}
> {: .solution}
{: .challenge}

## Missing values
As seen from the table above, Stata denotes missing values with `.` We can use the `missing` function to test if a variable or an expression returns a missing value.
```
. display missing(2018)
0

. display missing(.)
1
```
{: .output}
Remember, 0 means false, 1 means true.

Operations on missing values return a missing value. So do inadmissible mathematical operations.
```
. display missing(1 + 2 + .)
1

. display missing(4 / 0)
1
```
{: .output}

For strings, the empty string is treated as missing value.
```
. display missing("")
1

. display missing(".")
0
```
{: .output}

> ## Gotcha
> Missing values are greater than any number.
> ```
> . display 2018 < .
> 1
> 
> . display 2018 > .
> 0
> ```
> {: .output}
{: .callout}

> ## Challenge
> Count how many countries have had their population census later than 2008.
> > ## Solution
> > `count if censusyear > 2008 & !missing(censusyear)` gives you an answer of 187. If you use `count if censusyear > 2008`, you get 234. This is because Stata treats missing values as larger than any real number. It hence adds the 47 missing values.
> {: .solution}
{: .challenge}

> ## Challenge
> Which of the following tells you how many countries have more recent population census than trade data?
> ```
> count if censusyear < latesttradedata
> count if censusyear - latesttradedata < 0
> count if latesttradedata - censusyear > 0
> ```
> {: .source}
> > ## Solution
> > The second. When neither variable is missing, the three comparisons give the same answer. However, when `latesttradedata` has missing values, the first comparison evaluates to true, because missing values are greater than anything. The second comparison starts with a mathematical operation, which evaluates to missing and is hence *not* smaller than zero. As this property of missing values is a common *gotcha*, it is recommended to always explicitly test for missing values.
> > ```
> > count if censusyear < latesttradedata & !missing(censusyear, latesttradedata)
> > ```
> > {: .source}
> {: .solution}
{: .challenge}

We are using the logical operators `&` (and), `!` (not) and test for missing values in multiple variables. This latter returns 1 if _any_ of the variables is missing.

Missing values are excluded from the statistical analyses by default; some commands will permit inclusion of missing values via options. Always be cautious when dealing with missing values and their replacement.  

> ## Challenge
> Replace `national_accounts_base_year` with the value extracted from `nationalaccountsreferenceyear` if the former is missing but the latter is not.
> > ## Solution
> > ```
> > . replace national_accounts_base_year = real(substr(nationalaccountsreferenceyear, 1, 4)) if missing(national_accounts_base_year) & !missing(nationalaccountsreferenceyear)
> > (65 real changes made)
> > ```
> > {: .output}
> {: .solution}
{: .challenge}



> # Callout
> ## Regular expressions to the rescue
> If the year is placed anywhere in the string, we can use [regular expressions](https://en.wikipedia.org/wiki/Regular_expression) to extract the year in string format and convert the string to a numeric variable as we did above. Regular expressions describe arbitrary patterns in text and are very powerful to extract data from text. 
>
> ```
> . generate year_string = regexs(0) if regexm( sourceofmostrecentincomeandexpen, "[0-9][0-9][0-9][0-9]") 
> (46 missing values generated)
> 
> . generate year_income = real(year_string)
> (46 missing values generated)
> 
> . browse year_string year sourceofmostrecentincomeandexpen
> ```
> > ![Regexp Browse]({{ "/img/RegExp.png" | relative_url }})
> {: .output}
{: .callout}

{% include links.md %}

