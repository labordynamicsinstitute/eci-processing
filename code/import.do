*Import data from BLS website
cd "${raw_data}"

foreach y in area aspect contacts   estimate footnote industry occupation owner periodicity seasonal series subcell {
	clear
	copy https://download.bls.gov/pub/time.series/ci/ci.`y' f`y'.txt, text replace
	import delimited "${raw_data}\f`y'.txt", delimiter(tab)  stringcols(_all)
	save "${raw_data}\f`y'.dta", replace
	}
	
	
*Three files have odd naming structure and require different commands
	clear
	copy https://download.bls.gov/pub/time.series/ci/ci.data.0.Current fcurrent.txt, text replace
	import delimited "${raw_data}\fcurrent.txt", delimiter(tab) stringcols(_all)
	save "${raw_data}\fcurrent.dta", replace

	clear
	copy https://download.bls.gov/pub/time.series/ci/ci.data.1.AllData falldata.txt, text replace
	import delimited "${raw_data}\falldata.txt", delimiter(tab) stringcols(_all)
	save "${raw_data}\falldata.dta", replace

	clear
	copy https://download.bls.gov/pub/time.series/ci/ci.txt readme.txt, text replace

	clear
	copy https://www.bls.gov/web/eci/echealth.txt health.txt, text replace	
