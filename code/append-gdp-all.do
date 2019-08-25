
clear all
use "data/gdp1990.dta", clear
generate year=1990

forvalues year = 1991/2017 {

	append using "data/gdp`year'.dta"
	replace year=`year' if missing(year)
	}

save "data/gdp1990-2017.dta", replace
