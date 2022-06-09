*Merge data files with alldata file

*start with all data file
use "${raw_data}\falldata.dta", clear

*merge series file
	merge m:1 series_id using "${raw_data}\fseries.dta"
	*confirm everything merged properly
		gen temp1=_merge==1
		gen temp2=_merge==2
		assert temp1+ temp2==0
	drop _merge temp*
*drop 3 month change series 
drop if periodicity_code=="Q"

*Owner
destring owner, replace
label define owner_lbl 1 `"Civilian workers"'
label define owner_lbl 2 `"Private industry workers"', add
label define owner_lbl 3 `"State and local government workers"', add
label values owner owner_lbl 


*Industry
	replace industry_code="520100" if industry_code=="520A00"
	replace industry_code="540100" if industry_code=="540A00"
	replace industry_code="999999" if industry_code=="DISCON"
	replace industry_code="991000" if industry_code=="G00000"
	replace industry_code="992000" if industry_code=="S00000"
	destring industry_code, replace
	label define ind_lbl 0 `"All workers"'
	label define ind_lbl 220000 `"Utilities"', add
	label define ind_lbl 230000 `"Construction"', add
	label define ind_lbl 300000 `"Manufacturing"', add
	label define ind_lbl 310000 `"Durable Goods manufacturers"', add
	label define ind_lbl 320000 `"Non-durable Goods manufacturers"', add
	label define ind_lbl 336411 `"Aircraft manufacturing"', add
	label define ind_lbl 400000 `"Trade, transportation, and utilities"', add
	label define ind_lbl 412000 `"Retail trade"', add
	label define ind_lbl 420000 `"Wholesale trade"', add
	label define ind_lbl 430000 `"Transportation and warehousing"', add
	label define ind_lbl 510000 `"Information"', add
	label define ind_lbl 520000 `"Finance and insurance"', add
	label define ind_lbl 520100 `"Financial activities"', add
	label define ind_lbl 522000 `"Credit intermediation"', add
	label define ind_lbl 524000 `"Insurance carriers"', add
	label define ind_lbl 530000 `"Real estate and rental and leasing"', add
	label define ind_lbl 540000 `"Professional, scientific, and technical services"', add
	label define ind_lbl 540100 `"Professional and business services"', add
	label define ind_lbl 560000 `"Administrative and support and waste management and remediation services"', add
	label define ind_lbl 600000 `"Education and health services"', add
	label define ind_lbl 610000 `"Educational services"', add
	label define ind_lbl 610500 `"Schools"', add
	label define ind_lbl 611100 `"Elementary and secondary schools"', add
	label define ind_lbl 612000 `"Junior colleges, colleges, universities, and professional schools"', add
	label define ind_lbl 620000 `"Health care and social assistance"', add
	label define ind_lbl 622000 `"Hospitals"', add
	label define ind_lbl 623000 `"Nursing and residential care facilities"', add
	label define ind_lbl 623100 `"Nursing care facilities"', add
	label define ind_lbl 700000 `"Leisure and hospitality"', add
	label define ind_lbl 720000 `"Accommodation and food services"', add
	label define ind_lbl 810000 `"Other services (except public administration)"', add
	label define ind_lbl 920000 `"Public administration"', add
	label define ind_lbl 999999 `"Discontinued codes"', add
	label define ind_lbl 991000 `"Goods producing"', add
	label define ind_lbl 992000 `"Service providing"', add
	label values industry_code ind_lbl


*Occupation
replace occupation_code="999999" if occupation_code=="DISCON"
destring occupation_code, replace
label define occ_lbl 0 `"All workers"'
label define occ_lbl 1 `"All workers, excluding sales"', add
label define occ_lbl 111300 `"Management, business, and financial occupations"', add
label define occ_lbl 112900 `"Management, professional and related occupations"', add
label define occ_lbl 114300 `"All white collar workers"', add
label define occ_lbl 114301 `"All while collar workers, excluding sales"', add
label define occ_lbl 152900 `"Professional and related occupations"', add
label define occ_lbl 313900 `"Service occupations"', add
label define occ_lbl 410000 `"Sales and related occupations"', add
label define occ_lbl 414300 `"Sales and office occupations"', add
label define occ_lbl 430000 `"Office and administrative support occupations"', add
label define occ_lbl 454700 `"Construction, and extraction, farming, fishing, and forestry occupations"', add
label define occ_lbl 454900 `"Natural resources, construction, and maintenance occupations"', add
label define occ_lbl 455300 `"All blue collar workers"', add
label define occ_lbl 490000 `"Installation, maintenance, and repair occupations"', add
label define occ_lbl 510000 `"Production occupations"', add
label define occ_lbl 515300 `"Production, transportation, and material moving occupations"', add
label define occ_lbl 530000 `"Transportation and material moving occupations"', add
label define occ_lbl 999999 `"Discontinued Codes"', add
label values occupation_code occ_lbl


*Subcell (only numeric values exist in data)
destring subcell, replace
label define subcell_lbl 0 `"All workers"', add
label define subcell_lbl 23 `"Union"', add
label define subcell_lbl 24 `"Nonunion"', add
label define subcell_lbl 27 `"Time"', add
label values subcell subcell_lbl


*Area
destring area, replace
label define area_lbl 122 `"Atlanta-Athens-Clarke County-Sandy Springs, GA CSA"'
label define area_lbl 148 `"Boston-Worcester-Providence, MA-RI-NH-CT CSA"', add
label define area_lbl 176 `"Chicago-Naperville, IL-IN-WI CSA"', add
label define area_lbl 206 `"Dallas-Fort Worth, TX-OK CSA"', add
label define area_lbl 220 `"Detroit-Warren-Ann Arbor, MI CSA"', add
label define area_lbl 288 `"Houston-The Woodlands, TX CSA"', add
label define area_lbl 348 `"Los Angeles-Long Beach, CA CSA"', add
label define area_lbl 378 `"Minneapolis-St. Paul, MN-WI CSA"', add
label define area_lbl 408 `"New York-Newark, NY-NJ-CT-PA CSA"', add
label define area_lbl 428 `"Philadelphia-Reading-Camden, PA-NJ-DE-MD CSA"', add
label define area_lbl 488 `"San Jose-San Francisco-Oakland, CA CSA"', add
label define area_lbl 500 `"Seattle-Tacoma, WA CSA"', add
label define area_lbl 548 `"Washington-Baltimore-Arlington, DC-MD-VA-WV-PA CSA"', add
label define area_lbl 33100 `"Miami-Fort Lauderdale-Port St. Lucie, FL CSA"', add
label define area_lbl 38060 `"Phoenix-Mesa-Scottsdale, AZ MSA"', add
label define area_lbl 98100 `"Northeast Region"', add
label define area_lbl 98200 `"South Region"', add
label define area_lbl 98300 `"Midwest Region"', add
label define area_lbl 98400 `"West Region"', add
label define area_lbl 98999 `"Census Regions and Divisions"', add
label define area_lbl 99100 `"New England Census Division"', add
label define area_lbl 99120 `"Middle Atlantic Census Division"', add
label define area_lbl 99130 `"East South Central Census Division"', add
label define area_lbl 99140 `"South Atlantic Census Division"', add
label define area_lbl 99150 `"East North Central Census Division"', add
label define area_lbl 99160 `"West North Central Census Division"', add
label define area_lbl 99170 `"West South Central Census Division"', add
label define area_lbl 99180 `"Mountain Census Division"', add
label define area_lbl 99190 `"Pacific Census Division"', add
label define area_lbl 99200 `"Metropolitan Statistical Area"', add
label define area_lbl 99210 `"Metropolitan"', add
label define area_lbl 99220 `"Nonmetropolitan"', add
label define area_lbl 99999 `"United States (National)"', add
label values area area_lbl


*Periodicity
encode periodicity_code, gen(p2)
drop periodicity_code
rename p2 periodicity_code
label define per_lbl 1 `"12-month percent change"'
label define per_lbl 2 `"Index number"', add
label values periodicity_code per_lbl


*Estimate
destring estimate_code, replace
label define est_lbl 1 `"Total compensation"', add
label define est_lbl 2 `"Wages and salaries"', add
label define est_lbl 3 `"Total benefits"', add
label values estimate_code est_lbl

*clean value var
replace value="" if value=="           -"
destring value, replace


*make stata-formatted date variable
gen yq =year+period
gen time = quarterly(yq, "YQ")
format time %tq
drop yq

*make numeric id
sort series_id series_title
egen id=group(series_id)
xtset id time

*confirm that core series maintain the same ID value over data releases
assert series_title=="Total compensation for All Civilian workers in All industries and occupations, 12-month percent change" if id==147
global id_tc = 147
assert series_title=="Wages and salaries for All Civilian workers in All industries and occupations, 12-month percent change" if id==285
global id_ws = 285 // previously 207
assert series_title=="Total benefits for All Civilian workers in All industries and occupations, 12-month percent change" if id==423
global id_tb = 423 // previously 267


/*
*bring in cpi data
merge m:1 time using "${mod_data}\cpi.dta"
keep if _merge==3
drop _merge
*/

*reoder
order series_title series_id id time  year period value  seasonal owner_code  industry_code  occupation_code  subcell_code  area_code  periodicity_code estimate_code begin_year begin_period end_year end_period     footnote_codes 


*make a seasonally adjusted index file
preserve
	keep if seasonal=="S"
	save "${mod_data}\fseries_seasonal_index.dta", replace
	restore

*make a 12-month change file
preserve
	keep if periodicity_code==1
	save "${mod_data}\fseries_12month.dta", replace
	restore
