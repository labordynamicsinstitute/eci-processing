*Import and prepare cpi data (series = CUUR0000SA0, CPI for All Urban Consumers (CPI-U))

import excel "${raw_data}/bls_cpi.xlsx", sheet("modified") firstrow case(lower) clear

*prepare for reshape
keep year q*
forvalues i=1(1)4 {
	rename q`i' cpi_`i'
	}
reshape long cpi_, i(year) j(qtr)
rename cpi_ cpi

*set date format
tostring year, gen(z1)
tostring qtr, gen(z2)
gen yq =z1+"Q"+z2
gen time = quarterly(yq, "YQ")
format time %tq
drop yq z1 z2 year qtr
order time


*make 12 month percent change cpi measure
gen cpi_12mo = (cpi - cpi[_n-4])/(cpi[_n-4])*100


save "${mod_data}/cpi.dta", replace


*make series style data
keep if time>=164 & time<=${max_time}
keep time cpi_12mo
gen id = 9999
gen series_title = "CPI, 12-month change"
gen owner_code = 999
rename cpi value
order series_title id time value owner_code
save "${mod_data}/cpi_series.dta", replace


