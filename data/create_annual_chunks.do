use "data/WDI-select-variables.dta", clear
keep countrycode year gdp_per_capita 
forvalues t = 1990/2017 {
	preserve
	keep if year == `t'
	drop year
	save "data/gdp`t'.dta", replace
	restore
}
