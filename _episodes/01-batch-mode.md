---
title: "Running Stata in Batch Mode"
teaching: 0
exercises: 0
questions:
- "How can .do files make my work more reproducible?"
- "How do I run my or someone else's .do file?"
objectives:
- "Run commands and .do files from the Stata command line."
- "Run .do files from Unix shell or the Windows terminal."
- "Pass parameters from the command line."
- "Determine and change your working directory in Stata."
- "Log your results window."
- "Use interactive dialogs to find the exact syntax of a command."
keypoints:
- "Only use interactive dialogs to find the command you need."
- "Add commands to a .do file."
- "Check what directory you are running .do files from."
- "Run .do files _en bloc_, not by parts." 
- "Always use forward slash `/` in path names."
- "Never abbreviate. Always write out the file extensions."
---

FIXME: introduce standard stata syntax: `command expression, options`

How do you find your current working directory? Check the bottom line of the Stata application window, or enter the command `pwd`.

![Two ways of checking your working directory]({{ relative_root_path }}{% link img/pwd.png %})

> ## Backward or forward?
> On a Windows machine, Stata will display your working directory with a backslash (`\`) separating its components, like
> `C:\Users\koren\Dropbox\teaching\courses\2019\carpentries\stata-economics`.
> You should still refer to directories using a forward slash (`/`) to stay compatible with other platforms. The forward slash is understood by all three major platforms, whereas the backslash has a special meaning on Unix and Mac.
{: .callout}

> ## Challenge
>
> If your current working directory is `/home/user/dc-economics/data`, which of the following Stata commands can you use to run the .do file at `/home/user/dc-economics/code/read_data.do`?
> 1. `do read_data.do`
> 2. `do ../read_data.do`
> 3. `do ../code/read_data.do`
> 4. `do /home/user/dc-economics/code/read_data.do`
> 5. `cd ../code`
>    `do read_data.do`
>
> > ## Solution
> > 1. No. This looks for `read_data.do` in the current directory, `/home/user/dc-economics/data`.
> > 2. No. This looks for `read_data.do` one level up from the current directory, `/home/user/dc-economics/`.
> > 3. Yes. This looks for `read_data.do` in the `code` folder one level up from the current folder. This is where your .do file is.
> > 4. Yes. You can always use the fully qualified, absolute path to run a .do file. It is, however, not good practice to do so, as the absolute path may be different on a different computer.
> > 5. Yes. This first changes the working directory to `/home/user/dc-economics/code`, the runs `read_data.do` from there.
> {: .solution}
{: .challenge}

> ## Challenge
>
> List three ways of running `read_data.do`.
>
> > ## Solution
> > 1. From Stata: `do /home/user/dc-economics/code/read_data.do`
> > 2. From Stata: `do read_data.do` (if current working directory is `/home/user/dc-economics/code`)
> > 3. From the shell: `stata -b do read_data.do` (if current working directory is `/home/user/dc-economics/code`)
> {: .solution}
{: .challenge}

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

{% include links.md %}

