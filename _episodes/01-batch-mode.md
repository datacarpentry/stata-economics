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
---

> ## Challenge
>
> How do you find your current working directory?
>
> > ## Solution
> > Check the bottom line of the Stata application window [SCREENSHOT], or enter the command `pwd`.
> {: .solution}
{: .challenge}

> ## Challenge
>
> If your current working directory is `/home/user/dc-economics/data`, which of the following Stata commands can you use to run the .do file at `/home/user/dc-economics/code/read_data.do`?
> 1. `do read_data`
> 2. `do ../read_data`
> 3. `do code/read_data`
> 4. `do /home/user/dc-economics/code/read_data.do`
> 5. `cd ../code`
>    `do read_data`
>
> > ## Solution
> {: .solution}
{: .challenge}

> ## Challenge
>
> List three ways of running `read_data.do`.
>
> > ## Solution
> > 1. From Stata: `do /home/user/dc-economics/code/read_data.do`
> > 2. From Stata: `do read_data` (if current working directory is `/home/user/dc-economics/code`)
> > 3. From the shell: `stata -b do read_data` (if current working directory is `/home/user/dc-economics/code`)
> {: .solution}
{: .challenge}

{% include links.md %}

