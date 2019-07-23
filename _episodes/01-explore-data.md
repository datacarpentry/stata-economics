---
title: "Read and Explore Data"
teaching: 0
exercises: 0
questions:
- "How can I explore my data?"
- "How does Stata deal with variable names it doesn't like?"
objectives:
- "Determine and change your working directory in Stata."
- "Read and write data using relative path."
- "Explore your dataset using `browse`, `describe`, `summarize`, `tabulate` and `inspect`."
keypoints:
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
. summarize dist

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
        dist |     50,176    8481.799    4703.571   .9951369   19951.16

```
{. :output}

```
. summarize dist, detail

         simple distance (most populated cities, km)
-------------------------------------------------------------
      Percentiles      Smallest
 1%     381.8563       .9951369
 5%      1366.76       1.189416
10%      2263.26       1.407336       Obs              50,176
25%     4783.271       1.723628       Sum of Wgt.      50,176

50%     8084.515                      Mean           8481.799
                        Largest       Std. Dev.      4703.571
75%     12030.18       19904.45
90%     15276.66       19904.45       Variance       2.21e+07
95%     16714.46       19951.16       Skewness         .25614
99%     18569.45       19951.16       Kurtosis       2.191578
```
{: .output}

FIXME: if

FIXME: `help summarize`

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

FIXME: how to find help. screenshot

NARRATIVE: by group: command if, options

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
{: .error}

FIXME: add googling step and finding solution. check for open access resources on variable naming.

```
. label variable iso_o "ISO3166 alphanumeric code of origin country"

. describe iso_o 

              storage   display    value
variable name   type    format     label      variable label
---------------------------------------------------------------------------------------------
iso_o           str3    %9s                   ISO3166 alphanumeric code of origin country

```
{: .output}

NARRATIVE: ALWAYS ADD LABELS

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

{% include links.md %}

