*Import and prepare cpi data (series = CUUR0000SA0, CPI for All Urban Consumers (CPI-U))
* FRED: CPIAUCSL = seasonally adjusted
* FRED: CPIAUCNS = not seasonally adjusted

global CPIVAR "CPIAUCNS"
import fred $CPIVAR

* convert to quarterly
gen z1 = year(daten)
tostring z1, replace
gen z2 = int(month(daten)/4)+1
tostring z2, replace
gen yq =z1+"Q"+z2
gen time = quarterly(yq, "YQ")
format time %tq
drop yq z1 z2 
order time
sort time

* summarize to quarterly level
collapse (mean) cpi = $CPIVAR, by(time)


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
export excel  using "${output}/cpi_series.xlsx",  firstrow(varlabels) replace



