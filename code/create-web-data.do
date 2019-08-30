use "data/WDI-select-variables.dta", clear

local gdp gdp_per_capita
local pop population
local trade trade_per_gdp

local variables gdp pop trade
foreach variable in `variables' {
	preserve
	
	keep countrycode countryname year ``variable''
	keep if year >= 1990 & year <= 2018
	rename ``variable'' `variable'
	reshape wide `variable', i(countrycode) j(year)
	export delimited data/web/`variable'.csv, replace
	
	restore
}
