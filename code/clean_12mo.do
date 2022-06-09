*prep 12 month data for analysis

use "${mod_data}/fseries_12month.dta", clear


*define recession periods (https://www.nber.org/cycles.html)
gen recession=0
replace recession=1 if time>=quarterly("2001Q1","YQ") & time<=quarterly("2001Q4","YQ")
replace recession=1 if time>=quarterly("2007Q4","YQ") & time<=quarterly("2009Q2","YQ")
replace recession=1 if time>=quarterly("2019Q4","YQ") & time<=quarterly("2020Q2","YQ")
label var recession "Recession"


*make a series obs number for sorting
bysort id: gen n=_n

*other variable labels
label var time "Time"
label var value "ECI"

sort id year


save "${clean_data}/fseries_12month.dta", replace
