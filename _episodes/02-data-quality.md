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
> Load `data/dist_cepii.dta`. Explore the variable `distw` (weighted average distance between cities in the pair of countries).
> 1. What are its measurement units?
> 2. What is its smallest and largest value?
> 3. In how many cases is it missing?
> > ## Solution
> > 1. `describe distw` gives you the variable label "weighted distance (pop-wt, km)". It is hence recorded in kilometers. You also see that the variable is _double_, not _integer_.
> > 2. `summarize distw` shows that the distance varies between  0.995 and 19781.39 kilometers.
> > 3. `inspect distw` shows that it is missing 2,215 cases. This command also gives you the minimum and maximum values.
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


{% include links.md %}

