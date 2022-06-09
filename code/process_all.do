*File to process the data management and analysis for the ECEC analysis

set more off
clear all
capture log close

*Directory setup
cd ..
global rootdir : pwd
global datadir "${rootdir}/"
global outputs "${rootdir}/Analysis"

global raw_data "${datadir}/raw"
global mod_data "${datadir}/modified"
global clean_data "${datadir}/clean"
global output "${outputs}/Output"
global log "${outputs}/Log_Files"
global do_files "${rootdir}/code"
cd "$rootdir"

foreach dir in datadir outputs raw_data mod_data clean_data output log {
	cap mkdir `dir'
}


*Log setup
local timestamp=subinstr(string(date(c(current_date), "DMY"), "%tdCCYY_NN_DD")," ","_",2)
log using "${log}/ecec_`timestamp'.log", replace text

/*Notes:
	- I have to manually update the raw/bls_cpi.xlsx file with current Q data
	- I have to manually add 1 to "global cpi_max_time" for each new Q's of data (on 1/31/20 I increased to 239. on 10/29/21 i increased to 246. on 01/28/22 I increased to 247
*/

*Specify globals used in command files
global max_time=247



*Set sections of code to run with the following code (0 = don't run; 1 = run)
global do_import = 1
global do_cpi = 1
global do_merge = 1
global do_clean_12mo = 1
global do_analysis_12mo = 1





*Execute do files
if ${do_import}==1 					do "${do_files}/import.do"
if ${do_cpi}==1 					do "${do_files}/cpi.do"
if ${do_merge}==1 					do "${do_files}/merge.do"
if ${do_clean_12mo}==1 				do "${do_files}/clean_12mo.do"
if ${do_analysis_12mo}==1 			do "${do_files}/analysis_12mo.do"

log close

