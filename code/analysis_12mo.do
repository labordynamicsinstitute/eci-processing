*Analysis of 12 month change ECI data

use  "${clean_data}/fseries_12month.dta", clear

***define recession graph commands
local all_shade bgshade time,shaders(recession) sstyle(lwidth(1.15) lcolor(gs14)) legend
local recent_shade bgshade time if time>=224,shaders(recession) sstyle(lwidth(4.7) lcolor(gs14)) legend
local regions_shade bgshade time if time>=224,shaders(recession) sstyle(lwidth(1.7) lcolor(gs14)) legend


*ECI Trend for Total Compensation - All Civilian Workers 
preserve
	keep if id==${id_tc}
	sum value
	local y = r(max)
	gen upper = recession*`y'*1.05
	format %2.1f value
	tostring value, gen(v2)
	gen length=length(v2)
	replace v2=v2+".0" if length==1
	gen marker = "{bf:" + v2 + "}"
	gen marker2=marker
	replace marker="" if time==${max_time}
	replace marker2="" if time<${max_time}
	twoway   (line upper time if inrange(time, 164, 167), recast(area) color(gs14)) (line upper time if inrange(time, 191, 197), recast(area) color(gs14)) (line upper time if inrange(time, 239, 242), recast(area) color(gs14)) (line value time, lcolor(maroon)) (scatter value time, mlabcolor(black) msym(none) mlabel(marker2) mlabsize(small) mlabangle(0) mlabposition(3) mlabgap(0)) (scatter value time, mlabcolor(black) msym(none) mlabel(marker) mlabsize(tiny) mlabangle(90) mlabposition(12) mlabgap(*3) xlab(164(4)${max_time},labsize(small) angle(45)) yscale(range(0 4.5)) yla(0 (1) 4.5) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("All Civilian Workers, 12-month Percent Change") legend(order(4 2) label(2 "Recession") label(3 "ECI")) note("Institute for Compensation Studies at Cornell University" "Source: U.S. Bureau of Labor Statistics’ 12-month Employment Cost Index"))
	sleep 5000
	gr export "${output}/eci_total_comp_allciv_wnotes.pdf", replace
	twoway   (line upper time if inrange(time, 164, 167), recast(area) color(gs14)) (line upper time if inrange(time, 191, 197), recast(area) color(gs14)) (line upper time if inrange(time, 239, 242), recast(area) color(gs14)) (line value time, lcolor(maroon)) (scatter value time, mlabcolor(black) msym(none) mlabel(marker2) mlabsize(small) mlabangle(0) mlabposition(3) mlabgap(0)) (scatter value time, mlabcolor(black) msym(none) mlabel(marker) mlabsize(tiny) mlabangle(90) mlabposition(12) mlabgap(*3) xlab(164(4)${max_time},labsize(small) angle(45)) yscale(range(0 4.5)) yla(0 (1) 4.5) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("All Civilian Workers, 12-month Percent Change") legend(order(4 2) label(2 "Recession") label(3 "ECI")))
	sleep 5000
	gr export "${output}/eci_total_comp_allciv_nonotes.pdf", replace
	export excel id series_title time value using "${output}/eci_total_comp_allciv.xls",  firstrow(varlabels) replace
	restore
	

	

*ECI Full Breakdown for all civilian workers (Total Comp = ${id_tc}; Wages & Sal = ${id_ws}; Total Ben = ${id_tb})
preserve
	keep if id==${id_tc}	
	label var value "Total Compensation"
	export excel time value using "${output}/eci_breakdown_all_civ.xls", sheet("breakdown") cell(A1) firstrow(varlabels) replace
	restore
preserve
	keep if id==${id_ws}
	label var value "Wages and Salaries"
	export excel value using "${output}/eci_breakdown_all_civ.xls", sheet("breakdown") sheetmodify cell(C1) firstrow(varlabels)
	restore
preserve
	keep if id==${id_tb}
	label var value "Total Benefits"
	export excel value using "${output}/eci_breakdown_all_civ.xls", sheet("breakdown") sheetmodify cell(D1) firstrow(varlabels)
	restore
preserve
	use "${mod_data}/health_series.dta", clear
	label var value "Health Benefits"
	export excel value using "${output}/eci_breakdown_all_civ.xls", sheet("breakdown") sheetmodify cell(E1) firstrow(varlabels)
	restore	

	
*ECI for Total Compensation  - All Private Workers (comparison across occupations)
preserve
	keep if owner==2 & area==99999 & estimate_code==1 & subcell==0 & ind==0
	keep if occupation_code==0 | occupation_code==112900 | occupation_code==313900 | occupation_code==414300 | occupation_code==454900 | occupation_code==515300
	label define occ2 0 "All Workers" 112900 "Mgmt., Prof.,  Related" 313900 "Service" 414300 "Sales and Office" 454900 "Nat. Res., Constr., Maint." 515300 "Prod., Trans., Mat. Moving"
	label values occ occ2
	tab occ, gen(xocc_)
	forvalues i=1(1)6 {
		local x1: variable label xocc_`i'
		local ylbl_`i' = substr("`x1'",18,.)
		}
	sum value
	local vmax=r(max)
	local vmin=r(min)
	gen upper=`vmax'*recession
	sort time
	keep if time>=164
	`all_shade' twoway (tsline value if occ==0 || tsline value if occ==112900 || tsline value if occ==313900 || tsline value if occ==414300 || tsline value if occ== 454900 || tsline value if occ==515300,  xlab(164(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("All Private Workers, 12-month Percent Change") legend(label(2 "All Workers") label(3 "Mgmt., Prof.,  Related") label(4 "Service") label(5 "Sales and Office") label(6 "Nat. Res., Constr., Maint.") label(7 "Prod., Trans., Mat. Moving")	size(vsmall) col(3) order( 2 3 4 5 6 7)))
	*twoway (area upper time, color(gs14) ) (tsline value if occ==0) (tsline value if occ==112900) (tsline value if occ==313900) (tsline value if occ==414300) (tsline value if occ== 454900) (tsline value if occ==515300,  xlab(164(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("All Private Workers, 12-month Percent Change") legend(label(2 "All Workers") label(3 "Mgmt., Prof.,  Related") label(4 "Service") label(5 "Sales and Office") label(6 "Nat. Res., Constr., Maint.") label(7 "Prod., Trans., Mat. Moving")	size(vsmall) col(3) order( 2 3 4 5 6 7)))
	*xtline value,t(time) i(occ) overlay  xlab(164(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("All Private Workers, 12-month Percent Change") legend(size(vsmall) col(3) order(1 2 3 4 5 6)) addplot((line upper time if inrange(time, 164, 167), recast(area) color(gs14)) (line upper time if inrange(time, 191, 197), recast(area) color(gs14)) (line upper time if inrange(time, 240, ${max_time}), recast(area) color(gs14) below))
	*sleep 5000
	gr export "${output}/eci_total_comp_allprivate.pdf", replace
	keep time value occ
	reshape wide value, i(time) j(occ) 
	local i=1
	foreach y in value0 value112900 value313900 value414300 value454900 value515300 {
		label var `y' "`ylbl_`i''"
		local i=`i'+1
		}
	export excel  using "${output}/eci_total_comp_allprivate.xls",  firstrow(varlabels) replace
	restore
	

*ECI for Wages & Salaries  - All Private Workers (comparison across occupations)
preserve
	keep if owner==2 & area==99999 & estimate_code==2 & subcell==0 & ind==0
	keep if occupation_code==0 | occupation_code==112900 | occupation_code==313900 | occupation_code==414300 | occupation_code==454900 | occupation_code==515300
	label define occ2 0 "All Workers" 112900 "Mgmt., Prof.,  Related" 313900 "Service" 414300 "Sales and Office" 454900 "Nat. Res., Constr., Maint." 515300 "Prod., Trans., Mat. Moving"
	label values occ occ2
	sum value
	local vmax=r(max)
	local vmin=r(min)
	gen upper=`vmax'*recession
	sort time
	keep if time>=164
	`all_shade' twoway (tsline value if occ==0 || tsline value if occ==112900 || tsline value if occ==313900 || tsline value if occ==414300 || tsline value if occ== 454900 || tsline value if occ==515300,  xlab(164(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Wages and Salaries") subtitle("All Private Workers, 12-month Percent Change") legend(label(2 "All Workers") label(3 "Mgmt., Prof.,  Related") label(4 "Service") label(5 "Sales and Office") label(6 "Nat. Res., Constr., Maint.") label(7 "Prod., Trans., Mat. Moving")	size(vsmall) col(3) order( 2 3 4 5 6 7)))
	*twoway (area upper time, color(gs14) ) (tsline value if occ==0) (tsline value if occ==112900) (tsline value if occ==313900) (tsline value if occ==414300) (tsline value if occ== 454900) (tsline value if occ==515300,  xlab(164(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Wages and Salaries") subtitle("All Private Workers, 12-month Percent Change") legend(label(2 "All Workers") label(3 "Mgmt., Prof.,  Related") label(4 "Service") label(5 "Sales and Office") label(6 "Nat. Res., Constr., Maint.") label(7 "Prod., Trans., Mat. Moving")	size(vsmall) col(3) order( 2 3 4 5 6 7)))
	*xtline value,t(time) i(occ) overlay  xlab(164(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Wages and Salaries") subtitle("All Private Workers, 12-month Percent Change") legend( size(vsmall) col(3) order(1 2 3 4 5 6)) addplot((line upper time if inrange(time, 164, 167), recast(area) color(gs14)) (line upper time if inrange(time, 191, 197), recast(area) color(gs14)) (line upper time if inrange(time, 240, ${max_time}), recast(area) color(gs14) below))
	*sleep 5000
	gr export "${output}/eci_ws_allprivate.pdf", replace
	keep time value occ
	reshape wide value, i(time) j(occ) 
	label var value0 "All Workers"
	label var value112900 "Mgmt., Prof.,  Related"
	label var value313900 "Service"
	label var value414300 "Sales and Office"
	label var value454900 "Nat. Res., Constr., Maint." 
	label var value515300 "Prod., Trans., Mat. Moving"
	export excel  using "${output}/eci_ws_allprivate.xls",  firstrow(varlabels) replace
	restore	
	

*ECI for Wages & Salaries  - All Private Workers (comparison across ALL occupations)
preserve
	keep if owner==2 & area==99999 & estimate_code==2 & subcell==0 & ind==0
	bysort occ: gen N=_N
	drop if N==24
	tab occ, gen(xocc_)
	forvalues i=1(1)14 {
		local x1: variable label xocc_`i'
		local ylbl_`i' = substr("`x1'",18,.)
		}
	keep time value occ
	reshape wide value, i(time) j(occ) 
	local i=1
	foreach y in value0 value111300 value112900 value152900 value313900 value410000 value414300 value430000 value454700 value454900 value490000 value510000 value515300 value530000 {
		label var `y' "`ylbl_`i''"
		local i=`i'+1
		}
	export excel  using "${output}/eci_ws_allprivate_allocc.xls",  firstrow(varlabels) replace
	restore		
	
*ECI for Total Compensation - by Class of Worker
preserve
	keep if area==99999 & estimate_code==1 & subcell==0 & ind==0 & occ==0
	keep series_title id time value owner recession
	append using "${mod_data}/cpi_series.dta"
	label define owner2 1 "Civilian" 2 "Private" 3 "Public" 999 "CPI"
	label values owner_code owner2
	sum value
	local vmax=r(max)
	local vmin=round(r(min),1)
	di "`vmin'"
	gen upper=`vmax'*recession
	replace upper=`vmin' if upper==0
	sort time
	keep if time>=164
	`all_shade' twoway (tsline value if owner==1 || tsline value if owner==2 || tsline value if owner==3 || tsline value if owner==999,  xlab(164(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("All Workers, 12-month Percent Change") legend(label(2 "Civilian") label(3 "Private") label(4 "Public") label(5 "CPI") 	size(vsmall) col(3) order( 2 3 4 5)))
*	twoway (area upper time, color(gs14) base(`vmin') ) (tsline value if owner==1) (tsline value if owner==2) (tsline value if owner==3) (tsline value if owner==999,  xlab(164(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("All Workers, 12-month Percent Change") legend(label(2 "Civilian") label(3 "Private") label(4 "Public") label(5 "CPI") 	size(vsmall) col(3) order( 2 3 4 5)))
*	xtline value,t(time) i(owner) overlay  xlab(164(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("All Workers, 12-month Percent Change") legend(order(1 2 3 4) size(vsmall) col(4)) addplot((line upper time if inrange(time, 164, 167), recast(area) color(gs14) base(-2)) (line upper time if inrange(time, 191, 197), recast(area) color(gs14) base(-2)) (line upper time if inrange(time, 240, ${max_time}), recast(area) color(gs14) base(-2) below))
*	sleep 5000
	gr export "${output}/eci_tc_allworkers.pdf", replace
	drop upper
	sum value if time>=224
	local vmax=r(max)
	local vmin=round(r(min),1)
	di "`vmin'"
	gen upper=`vmax'*recession
	replace upper=`vmin' if upper==0
	sort time
	`recent_shade' twoway (tsline value if owner==1 & time>=224 || tsline value if owner==2 & time>=224 || tsline value if owner==3 & time>=224 || tsline value if owner==999  & time>=224,  xlab(224(4)${max_time},labsize(small) angle(45)) xtick(#11) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("All Workers, 12-month Percent Change") legend(label(2 "Civilian") label(3 "Private") label(4 "Public") label(5 "CPI") 	size(vsmall) col(3) order( 2 3 4 5)))
*	twoway (area upper time if time>=224, color(gs14) base(`vmin') ) (tsline value if owner==1 & time>=224) (tsline value if owner==2 & time>=224) (tsline value if owner==3 & time>=224) (tsline value if owner==999  & time>=224,  xlab(224(4)${max_time},labsize(small) angle(45)) xtick(#11) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("All Workers, 12-month Percent Change") legend(label(2 "Civilian") label(3 "Private") label(4 "Public") label(5 "CPI") 	size(vsmall) col(3) order( 2 3 4 5)))
*	xtline value if time>=224,t(time) i(owner) overlay  xlab(224(4)${max_time},labsize(small) angle(45)) xtick(#11) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("All Workers, 12-month Percent Change") legend(order(1 2 3 4) size(vsmall) col(4)) addplot((line upper time if inrange(time, 240, ${max_time}), recast(area) color(gs14) below))
*	sleep 5000
	gr export "${output}/eci_tc_allworkers_recent.pdf", replace
	keep time value owner
	reshape wide value, i(time) j(owner) 
	label var value1 "Civilian"
	label var value2 "Private"
	label var value3 "Public"
	label var value999 "CPI"
	export excel  using "${output}/eci_tc_allworkers.xls",  firstrow(varlabels) replace
	restore	


*ECI for Total Benefits - by Class of Worker
preserve
	keep if area==99999 & estimate_code==3 & subcell==0 & ind==0 & occ==0
	keep series_title id time value owner recession
	append using "${mod_data}/cpi_series.dta"
	label define owner2 1 "Civilian" 2 "Private" 3 "Public" 999 "CPI"
	label values owner_code owner2
	sum value
	local vmax=r(max)
	local vmin=round(r(min),1)
	di "`vmin'"
	gen upper=`vmax'*recession
	replace upper=`vmin' if upper==0
	sort time
	keep if time>=164
	`all_shade' twoway (tsline value if owner==1 || tsline value if owner==2 || tsline value if owner==3 || tsline value if owner==999,  xlab(164(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Benefits") subtitle("All Workers, 12-month Percent Change") legend(label(2 "Civilian") label(3 "Private") label(4 "Public") label(5 "CPI") 	size(vsmall) col(3) order( 2 3 4 5)))
*	twoway (area upper time, color(gs14) base(`vmin') ) (tsline value if owner==1) (tsline value if owner==2) (tsline value if owner==3) (tsline value if owner==999,  xlab(164(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Benefits") subtitle("All Workers, 12-month Percent Change") legend(label(2 "Civilian") label(3 "Private") label(4 "Public") label(5 "CPI") 	size(vsmall) col(3) order( 2 3 4 5)))
*	xtline value,t(time) i(owner) overlay  xlab(164(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Benefits") subtitle("All Workers, 12-month Percent Change") legend(order(1 2 3 4) size(vsmall) col(4)) addplot((line upper time if inrange(time, 164, 167), recast(area) color(gs14) base(-2)) (line upper time if inrange(time, 191, 197), recast(area) color(gs14) base(-2)) (line upper time if inrange(time, 240, ${max_time}), recast(area) color(gs14) base(-2) below))
*	sleep 5000
	gr export "${output}/eci_tb_allworkers.pdf", replace
	drop upper
	sum value if time>=224
	local vmax=r(max)
	local vmin=round(r(min),1)
	di "`vmin'"
	gen upper=`vmax'*recession
	replace upper=`vmin' if upper==0
	sort time
	`recent_shade' twoway (tsline value if owner==1 & time>=224 || tsline value if owner==2 & time>=224 || tsline value if owner==3 & time>=224 || tsline value if owner==999  & time>=224,  xlab(224(4)${max_time},labsize(small) angle(45)) xtick(#11) xtitle("") ytitle("Percent Change (%)")  title("Employment Cost Index for Total Benefits") subtitle("All Workers, 12-month Percent Change") legend(label(2 "Civilian") label(3 "Private") label(4 "Public") label(5 "CPI") 	size(vsmall) col(3) order( 2 3 4 5)))
*	twoway (area upper time if time>=224, color(gs14) base(`vmin') ) (tsline value if owner==1 & time>=224) (tsline value if owner==2 & time>=224) (tsline value if owner==3 & time>=224) (tsline value if owner==999  & time>=224,  xlab(224(4)${max_time},labsize(small) angle(45)) xtick(#11) xtitle("") ytitle("Percent Change (%)")  title("Employment Cost Index for Total Benefits") subtitle("All Workers, 12-month Percent Change") legend(label(2 "Civilian") label(3 "Private") label(4 "Public") label(5 "CPI") 	size(vsmall) col(3) order( 2 3 4 5)))
*	xtline value if time>=224,t(time) i(owner) overlay  xlab(224(4)${max_time},labsize(small) angle(45)) xtick(#11) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Benefits") subtitle("All Workers, 12-month Percent Change") legend(order(1 2 3 4) size(vsmall) col(4)) addplot((line upper time if inrange(time, 240, ${max_time}), recast(area) color(gs14) base(-2) below))
*	sleep 5000
	gr export "${output}/eci_tb_allworkers_recent.pdf", replace
	keep time value owner
	reshape wide value, i(time) j(owner) 
	label var value1 "Civilian"
	label var value2 "Private"
	label var value3 "Public"
	label var value999 "CPI"
	export excel  using "${output}/eci_tb_allworkers.xls",  firstrow(varlabels) replace
	restore	


*ECI for Total Compensation  - Private - Over Census Divisions
preserve
	keep if owner==2 & estimate_code==1 & subcell==0 & ind==0 & occ==0 
	keep if area>=99100 & area<=99190
	label define area2 99100 "New England" 99120 "Middle Atlantic" 99130 "East South Central" 99140 "South Atlantic" 99150 "East North Central" 99160 "West North Central" 99170 "West South Central" 99180 "Mountain" 99190 "Pacific" 
	label values area area2
	sum value
	local vmax=r(max)
	local vmin=round(r(min),1)
	di "`vmin'"
	gen upper=`vmax'*recession
	replace upper=`vmin' if upper==0
	sort time
	keep if time>=164
	`regions_shade' twoway (tsline value if area==99100 & time>=184 || tsline value if area==99120 & time>=184 || tsline value if area==99130 & time>=184 || tsline value if area==99140 & time>=184 || tsline value if area==99150 & time>=184 || tsline value if area==99160 & time>=184 || tsline value if area==99170 & time>=184 || tsline value if area==99180 & time>=184 || tsline value if area==99190 & time>=184,  xlab(184(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("Private Workers, 12-month Percent Change") legend(label(2 "New England") label(3 "Middle Atlantic") label(4 "East South Central") label(5 "South Atlantic") label(6 "East North Central") label(7 "West North Central") label(8 "West South Central") label(9 "Mountain") label(10 "Pacific") 	size(vsmall) col(3) order( 2 3 4 5 6 7 8 9 10)))
*	twoway (area upper time if time>=184, color(gs14) base(`vmin') ) (tsline value if area==99100 & time>=184) (tsline value if area==99120 & time>=184) (tsline value if area==99130 & time>=184) (tsline value if area==99140 & time>=184) (tsline value if area==99150 & time>=184) (tsline value if area==99160 & time>=184) (tsline value if area==99170 & time>=184) (tsline value if area==99180 & time>=184) (tsline value if area==99190 & time>=184,  xlab(184(4)${max_time},labsize(small) angle(45)) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("Private Workers, 12-month Percent Change") legend(label(2 "New England") label(3 "Middle Atlantic") label(4 "East South Central") label(5 "South Atlantic") label(6 "East North Central") label(7 "West North Central") label(8 "West South Central") label(9 "Mountain") label(10 "Pacific") 	size(vsmall) col(3) order( 2 3 4 5 6 7 8 9 10)))
*	xtline value if time>=224,t(time) i(area) overlay  xlab(224(4)${max_time},labsize(small) angle(45)) xtick(#11) xtitle("") ytitle("Percent Change (%)") title("Employment Cost Index for Total Compensation") subtitle("Private Workers, 12-month Percent Change") legend(size(vsmall) col(3) order(1 2 3 4 5 6 7 8 9)) addplot((line upper time if inrange(time, 240, ${max_time}), recast(area) color(gs14) base(-2) below))
*	sleep 5000
	gr export "${output}/eci_tc_regions.pdf", replace
	tab area, gen(xarea_)
	forvalues i=1(1)9 {
		local x1: variable label xarea_`i'
		local ylbl_`i' = substr("`x1'",12,.)
		}
	keep time value area
	reshape wide value, i(time) j(area) 
	local i=1
	foreach y in value99100 value99120 value99130 value99140 value99150 value99160 value99170 value99180 value99190 {
		label var `y' "`ylbl_`i''"
		local i=`i'+1
		}
	export excel  using "${output}/eci_tc_regions.xls",  firstrow(varlabels) replace
	restore	
