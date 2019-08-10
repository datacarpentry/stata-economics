import delimited "data/WDIData.csv", varnames(1) bindquotes(strict) encoding("utf-8") clear
keep if inlist(indicatorcode, "TG.VAL.TOTL.GD.ZS", "NY.GDP.PCAP.PP.KD", "SP.POP.TOTL")
reshape long v, i(countrycode indicatorcode) j(year)
replace year = year - 5 + 1960
generate str variable_name = ""
replace variable_name = "merchandise_trade" if indicatorcode == "TG.VAL.TOTL.GD.ZS"
replace variable_name = "gdp_per_capita" if indicatorcode == "NY.GDP.PCAP.PP.KD"
replace variable_name = "population" if indicatorcode == "SP.POP.TOTL" 
drop indicatorcode indicatorname
reshape wide v, i(countrycode year) j(variable_name) string
rename v* *
save "data/WDI-select-variables.dta", replace
