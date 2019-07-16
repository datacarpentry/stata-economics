---
title: "Effective Programming"
teaching: 0
exercises: 0
questions:
- "Why should I care about code quality?"
- "How do I make my code more legible?"
objectives:
- "Create expressive variable names."
- "Write effective code comments."
- "Write code that is easy to read."
- "Use temporary variables, scalars, and files."
- "Understand and use local and global macros."
- "Reuse the results of other commands."
- "Automate repetitive tasks using `foreach` and `forvalues`."
- Use return values of Stata commands.
keypoints:
- "Write expressive variable names."
- "Comment the why, not the what."
- "Use for loops to automate anything that happens more than twice."
- "Use `return list` after a command to see what you can reuse."
---


> ## Challenge
> Using the `wdi_decades.dta` dataset, calculate the ratio of GDP per capita to the average GDP per capita of that decade.
> > ## Solution
> > ```
> > use "data/wdi_decades.dta", clear
> > tempvar decade_gdp_average
> > egen `decade_gdp_average' = mean(gdp_per_capita), by(decade)
> > generate relative_gdp_per_capita = gdp_per_capita / `decade_gdp_average'
> > ```
> > {: .source}
> > Note the verbose variable names, the use of `egen` and `tempvar`.
> {: .solution}
{: .challenge}


> ## Challenge
> What is the difference between `collapse (mean) average_distance = distw, by(iso_o)` and `egen average_distance = mean(distw), by(iso_o)`?
> > ## Solution
> > Both calculate the average `distw` by origin country code. `collapse` creates a new dataset with one row for each group (origin country code). `egen` keeps the original dataset, its rows and variables, and adds a new variable with the group average.
> {: .solution}
{: .challenge}


{% include links.md %}
