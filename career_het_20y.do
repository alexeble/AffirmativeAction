/*

career outcomes: heterogeneity

* Edited by Alex 2025-06-27.

*/


/* ---------------------------------------------------- */
/*         full professor: cohorts [1966, 1975]         */
/*        female-representative vs. other fields        */
/* ---------------------------------------------------- */
* no field heterogeneity

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 (nsfc_field0 == 2 | nsfc_field0 == 3 | nsfc_field0 == 8) 
local cond2_2 (nsfc_field0 == 1 | nsfc_field0 == 4 | nsfc_field0 == 5 | nsfc_field0 == 6)
local controls treat_female i.female#i.year i.treated#i.year

reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Fields with more females" 4 "Fields with fewer females") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to full professor", size(4))

graph export "$figure_path/Fig_full_prof_1966_1975_field_20y_het.eps", replace
graph export "$figure_path/Fig_full_prof_1966_1975_field_20y_het.pdf", replace	


/* ---------------------------------------------------- */
/*         full professor: cohorts [1966, 1975]         */
/*            fields: science vs. engineering           */
/* ---------------------------------------------------- */
* no field heterogeneity

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10  
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 (nsfc_field0 == 1 | nsfc_field0 == 2 | nsfc_field0 == 3 | nsfc_field0 == 4 | nsfc_field0 == 8) 
local cond2_2 (nsfc_field0 == 5 | nsfc_field0 == 6)
local controls treat_female i.female#i.year i.treated#i.year

reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Science fields" 4 "Engineering fields") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to full professor", size(4))

graph export "$figure_path/Fig_full_prof_1966_1975_field2_20y_het.eps", replace
graph export "$figure_path/Fig_full_prof_1966_1975_field2_20y_het.pdf", replace	


/* ---------------------------------------------------- */
/*       associate professor: cohorts [1966, 1975]      */
/*        female-representative vs. other fields        */
/* ---------------------------------------------------- */
* no field heterogeneity

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 (nsfc_field0 == 2 | nsfc_field0 == 3 | nsfc_field0 == 8) 
local cond2_2 (nsfc_field0 == 1 | nsfc_field0 == 4 | nsfc_field0 == 5 | nsfc_field0 == 6)
local controls treat_female i.female#i.year i.treated#i.year

reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Fields with more females" 4 "Fields with fewer females") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to associate professor", size(4))

graph export "$figure_path/Fig_assoc_prof_1966_1975_field_20y_het.eps", replace
graph export "$figure_path/Fig_assoc_prof_1966_1975_field_20y_het.pdf", replace	


/* ---------------------------------------------------- */
/*       associate professor: cohorts [1966, 1975]      */
/*            fields: science vs. engineering           */
/* ---------------------------------------------------- */
* no field heterogeneity

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 (nsfc_field0 == 1 | nsfc_field0 == 2 | nsfc_field0 == 3 | nsfc_field0 == 4 | nsfc_field0 == 8) 
local cond2_2 (nsfc_field0 == 5 | nsfc_field0 == 6)
local controls treat_female i.female#i.year i.treated#i.year

reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Science fields" 4 "Engineering fields") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to associate professor", size(4))

graph export "$figure_path/Fig_assoc_prof_1966_1975_field2_20y_het.eps", replace
graph export "$figure_path/Fig_assoc_prof_1966_1975_field2_20y_het.pdf", replace	


/* ---------------------------------------------------- */
/*         full professor: cohorts [1966, 1975]         */
/*         higher vs. lower-performing scholars         */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar3 == 1
local cond2_2 top_scholar3 == 0 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Has publication pre-policy" 4 "Others") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to full professor", size(4))

graph export "$figure_path/Fig_full_prof_1966_1975_ability_20y_het.eps", replace
graph export "$figure_path/Fig_full_prof_1966_1975_ability_20y_het.pdf", replace	

/* ---------------------------------------------------- */
/*         full professor: cohorts [1966, 1975]         */
/*         higher vs. lower-performing scholars         */
/*         top publication						         */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar1 == 1
local cond2_2 top_scholar1 == 0 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Has top publication pre-policy" 4 "Others") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to full professor", size(4))

graph export "$figure_path/Fig_full_prof_1966_1975_ability_20y_hettoppub.eps", replace
graph export "$figure_path/Fig_full_prof_1966_1975_ability_20y_hettoppub.pdf", replace	


/* ---------------------------------------------------- */
/*       associate professor: cohorts [1966, 1975]      */
/*         higher vs. lower-performing scholars         */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar3 == 1
local cond2_2 top_scholar3 == 0 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Has publication pre-policy" 4 "Others") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to associate professor", size(4))

graph export "$figure_path/Fig_assoc_prof_1966_1975_ability_20y_het.eps", replace
graph export "$figure_path/Fig_assoc_prof_1966_1975_ability_20y_het.pdf", replace	

/* ---------------------------------------------------- */
/*       associate professor: cohorts [1966, 1975]      */
/*         higher vs. lower-performing scholars         */
/*         top journals							         */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar1 == 1
local cond2_2 top_scholar1 == 0 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Has top publication pre-policy" 4 "Others") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to associate professor", size(4))

graph export "$figure_path/Fig_assoc_prof_1966_1975_ability_20y_hettoppub.eps", replace
graph export "$figure_path/Fig_assoc_prof_1966_1975_ability_20y_hettoppub.pdf", replace	


/* ------------------------------------------------------- */
/*    associate professor: female cohorts [1966, 1975]     */
/*          higher vs. lower-performing scholars           */
/*        associate professor based on calculation         */
/* ------------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar3 == 1
local cond2_2 top_scholar3 == 0 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe assoc_prof3 `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe assoc_prof3 `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Higher-performing scientists" 4 "Lower-performing scientists") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to associate professor", size(4))

graph export "$figure_path/Fig_assoc_prof3_1966_1975_ability_20y_het.eps", replace
graph export "$figure_path/Fig_assoc_prof3_1966_1975_ability_20y_het.pdf", replace	


/* ---------------------------------------------------- */
/*         full professor: cohorts [1966, 1975]         */
/*            top-tier vs. lower-tier univs             */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 (wkunit_type == 1 | wkunit_type == 2) 
local cond2_2 wkunit_type == 4 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Elite universities" 4 "Other universities") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to full professor", size(4))

graph export "$figure_path/Fig_full_prof_1966_1975_rank_20y_het.eps", replace
graph export "$figure_path/Fig_full_prof_1966_1975_rank_20y_het.pdf", replace	


/* ---------------------------------------------------- */
/*         full professor: cohorts [1966, 1975]         */
/*             985 vs. 211 vs. other univs              */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 wkunit_type == 1 
local cond2_2 wkunit_type == 2 
local cond2_3 wkunit_type == 4 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2
reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_3', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant3

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.15)) ///
	(grant2, msymbol(Th) mcolor(gs6) lcolor(gs6) ciopts(recast(rcap) lcolor(gs6) lpattern(dash)) offset(0)) ///
	(grant3, msymbol(S) mcolor(gs12) lcolor(gs12) ciopts(recast(rcap) lcolor(gs12) lpattern(solid)) offset(0.15)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Project 985" 4 "Project 211" 6 "Other universities") pos(6) region(lw(0)) cols(3) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to full professor", size(4))

graph export "$figure_path/Fig_full_prof_1966_1975_3rank_20y_het.eps", replace
graph export "$figure_path/Fig_full_prof_1966_1975_3rank_20y_het.pdf", replace	


/* -------------------------------------------------------- */
/*         associate professor: cohorts [1966, 1975]        */
/*              top-tier vs. lower-tier univs               */
/* -------------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 (wkunit_type == 1 | wkunit_type == 2) 
local cond2_2 wkunit_type == 4 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Elite universities" 4 "Other universities") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.08,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to associate professor", size(4))

graph export "$figure_path/Fig_assoc_prof_1966_1975_rank_20y_het.eps", replace
graph export "$figure_path/Fig_assoc_prof_1966_1975_rank_20y_het.pdf", replace	


/* --------------------------------------------------------------- */
/*            associate professor: cohorts [1966, 1975]            */
/*                  top-tier vs. lower-tier univs                  */
/*             associate professor based on calculation            */
/* --------------------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 (wkunit_type == 1 | wkunit_type == 2) 
local cond2_2 wkunit_type == 4 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe assoc_prof2 `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe assoc_prof2 `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Elite universities" 4 "Other universities") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.08,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to associate professor", size(4))

graph export "$figure_path/Fig_assoc_prof2_1966_1975_rank_20y_het.eps", replace
graph export "$figure_path/Fig_assoc_prof2_1966_1975_rank_20y_het.pdf", replace	


/* ---------------------------------------------------- */
/*      associate professor: cohorts [1966, 1975]       */
/*             985 vs. 211 vs. other univs              */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 wkunit_type == 1 
local cond2_2 wkunit_type == 2 
local cond2_3 wkunit_type == 4 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2
reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_3', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant3

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.15)) ///
	(grant2, msymbol(Th) mcolor(gs6) lcolor(gs6) ciopts(recast(rcap) lcolor(gs6) lpattern(dash)) offset(0)) ///
	(grant3, msymbol(S) mcolor(gs12) lcolor(gs12) ciopts(recast(rcap) lcolor(gs12) lpattern(solid)) offset(0.15)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Project 985" 4 "Project 211" 6 "Other universities") pos(6) region(lw(0)) cols(3) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to associate professor", size(4))

graph export "$figure_path/Fig_assoc_prof_1966_1975_3rank_20y_het.eps", replace
graph export "$figure_path/Fig_assoc_prof_1966_1975_3rank_20y_het.pdf", replace	


/*
/* ---------------------------------------------------- */
/*         full professor: cohorts [1966, 1975]         */
/*                   lab vs. desk fields                */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
	years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 field_lab == 1
local cond2_2 field_lab == 2
local controls treat_female i.female#i.year i.treated#i.year

reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n5="-5" years_n4=" " years_n3=" " years_n2=" " year_cutoff=" " ///
		years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Laboratory fields" 4 "Desk fields") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to full professor", size(4))

graph export "$figure_path/Fig_full_prof_1966_1975_lab_20y_het.eps", replace
graph export "$figure_path/Fig_full_prof_1966_1975_lab_20y_het.pdf", replace	


/* ---------------------------------------------------- */
/*          associate professor: cohorts [1966, 1975]       */
/*                   lab vs. desk fields                */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
	years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 field_lab == 1
local cond2_2 field_lab == 2
local controls treat_female i.female#i.year i.treated#i.year

reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n5="-5" years_n4=" " years_n3=" " years_n2=" " year_cutoff=" " ///
		years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Laboratory fields" 4 "Desk fields") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.08,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to associate professor", size(4))

graph export "$figure_path/Fig_assoc_prof_1966_1975_lab_20y_het.eps", replace
graph export "$figure_path/Fig_assoc_prof_1966_1975_lab_20y_het.pdf", replace	
*/

/* ---------------------------------------------------- */
/*         full professor: cohorts [1966, 1975]         */
/*          scholars with vs. without top pubs          */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar1 == 1
local cond2_2 top_scholar1 == 0 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Higher-performing scientists" 4 "Lower-performing scientists") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to full professor", size(4))

graph export "$figure_path/Fig_full_prof_1966_1975_ability2_20y_het.eps", replace
graph export "$figure_path/Fig_full_prof_1966_1975_ability2_20y_het.pdf", replace	


/* ------------------------------------------------------- */
/*    associate professor: female cohorts [1966, 1975]     */
/*            scholars with vs. without top pubs           */
/* ------------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar1 == 1
local cond2_2 top_scholar1 == 0 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe assoc_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Higher-performing scientists" 4 "Lower-performing scientists") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.08,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to associate professor", size(4))

graph export "$figure_path/Fig_assoc_prof_1966_1975_ability2_20y_het.eps", replace
graph export "$figure_path/Fig_assoc_prof_1966_1975_ability2_20y_het.pdf", replace	


/* ------------------------------------------------------------------ */
/*               full professor: cohorts [1966, 1975]                 */
/*    top- vs. lower-tier univs + high- vs. lower-ability scholars    */
/* ------------------------------------------------------------------ */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 (wkunit_type == 1 | wkunit_type == 2) & top_scholar3 == 1
local cond2_2 wkunit_type == 4 & top_scholar3 == 1 
local cond3_1 (wkunit_type == 1 | wkunit_type == 2) & top_scholar3 == 0
local cond3_2 wkunit_type == 4 & top_scholar3 == 0 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2
reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond3_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant3
reghdfe full_prof `treatlist1' `controls' if `cond1' & `cond3_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant4

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.22)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(-0.08)) ///
	(grant3, msymbol(O) mcolor(blue%80) lcolor(blue%80) ciopts(recast(rcap) lcolor(blue%80) lpattern(solid)) offset(0.08)) ///
	(grant4, msymbol(Th) mcolor(blue%30) lcolor(blue%30) ciopts(recast(rcap) lcolor(blue%30) lpattern(dash)) offset(0.22)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "High-performing scientists + elite univ." 4 "High-performing scientists + other univ." ///
		6 "Other scientists + elite univ." 8 "Other scientists + other univ.") ///
		pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.08(0.04)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to full professor", size(4))
	


