/*

focusing on associate professors before the policy

*/

/* ----------------------------------------------------------- */
/*                        preparing data:                      */
/*  sample of associate professors or above before the policy  */
/* ----------------------------------------------------------- */

*--- ids of associate professors or above before the policy

use "$data_path/pre_policy_char_66_75.dta", clear

keep if assoc_prof2 == 1

rename assoc_prof assoc_prof_pre
label var assoc_prof_pre "being an associate professor before the policy"

rename full_prof full_prof_pre
label var full_prof_pre "being a full professor before the policy"

keep author_numid2 assoc_prof_pre full_prof_pre

save "$temp_data_path/assoc_prof_id.dta", replace 

*--- merge with the main dataset

use "$data_path/grants_researcher_year_66_75.dta", clear

merge n:1 author_numid2 using "$temp_data_path/assoc_prof_id.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       796,908
        from master                   796,908  (_merge==1)
        from using                          0  (_merge==2)

    Matched                           307,251  (_merge==3)
    -----------------------------------------
*/

keep if _merge == 3
drop _merge

save "$temp_data_path/grants_researcher_year_assoc_prof.dta", replace 


/* ---------------------------------------------------------------- */
/*                Young scientist grant: cohorts [1966, 1975]                */
/*    pre-assistant prof vs. pre-associate prof vs. pre-full prof   */
/* ---------------------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 pre_assoc_prof == 1
local cond2_2 pre_full_prof == 1
local controls treat_female i.female#i.year i.treated#i.year

reghdfe youth_grant_ry `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe youth_grant_ry `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	ylabel(-0.05(0.05)0.1,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Won a young scientist grant", size(4))

graph export "$figure_path/Fig_young_grant_1966_1975_rank_het.eps", replace
graph export "$figure_path/Fig_young_grant_1966_1975_rank_het.pdf", replace	


/* ---------------------------------------------- */
/*         Young scientist grant + general grants          */
/* ---------------------------------------------- */

use "$temp_data_path/grants_researcher_year_assoc_prof.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

reghdfe youth_grant_ry `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe gen_grant_ry `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	legend(order(2 "Young scientist grant" 4 "General grant") pos(6) region(lw(0)) cols(2) symxsize(*1.5)) ///
	xlabel(,labsize(small)) ///
	ylabel(-0.1(0.05)0.1,labsize(small)) ///
	xtitle("Years relative to policy start (2011)") ///
	ytitle("Won grant")

graph export "$figure_path/Fig_young_gen_grant_assoc_prof_sample.eps", replace
graph export "$figure_path/Fig_young_gen_grant_assoc_prof_sample.pdf", replace	


/* --------------------------------------------------------- */
/*         Young scientist grant: associate vs. full professor        */
/* --------------------------------------------------------- */
* the results for full professors are noisy due to small sample size

use "$temp_data_path/grants_researcher_year_assoc_prof.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 full_prof_pre == 0
local cond2_2 full_prof_pre == 1 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe youth_grant_ry `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe youth_grant_ry `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	legend(order(2 "Associate professor before the policy" 4 "Full professor before the policy") pos(6) region(lw(0)) cols(2) symxsize(*1.5)) ///
	xlabel(,labsize(small)) ///
	ylabel(-0.04(0.04)0.12,labsize(small)) ///
	xtitle("Years relative to policy start (2011)") ///
	ytitle("Won a young scientist grant")

graph export "$figure_path/Fig_young_grant_assoc_prof_sample.eps", replace
graph export "$figure_path/Fig_young_grant_assoc_prof_sample.pdf", replace	


/* ------------------------------------------------------- */
/*       general grants: associate vs. full professor      */
/* ------------------------------------------------------- */
* the results for full professors are noisy due to small sample size

use "$temp_data_path/grants_researcher_year_assoc_prof.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 full_prof_pre == 0
local cond2_2 full_prof_pre == 1 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe gen_grant_ry `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe gen_grant_ry `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	legend(order(2 "Associate professor before the policy" 4 "Full professor before the policy") pos(6) region(lw(0)) cols(2) symxsize(*1.5)) ///
	xlabel(,labsize(small)) ///
	ylabel(-0.12(0.06)0.12,labsize(small)) ///
	xtitle("Years relative to policy start (2011)") ///
	ytitle("Won a general grant")

graph export "$figure_path/Fig_general_grant_assoc_prof_sample.eps", replace
graph export "$figure_path/Fig_general_grant_assoc_prof_sample.pdf", replace	


/* ---------------------------------------------------- */
/*             promotion to full professor              */
/* ---------------------------------------------------- */

use "$temp_data_path/grants_researcher_year_assoc_prof.dta", clear

local treatlist1 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & yr_diff >= -5
local controls treat_female i.female#i.year i.treated#i.year

reghdfe full_prof `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store reg1

coefplot (reg1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(5.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n5="-5" years_n4=" " years_n3=" " years_n2=" " year_cutoff=" " ///
		years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(small)) ///
	ylabel(-0.1(0.1)0.1,labsize(small)) ///
	xtitle("Years relative to policy start (2011)") ///
	ytitle("Was promoted to full professor")

graph export "$figure_path/Fig_full_prof_promotion_assoc_prof_sample.eps", replace
graph export "$figure_path/Fig_full_prof_promotion_assoc_prof_sample.pdf", replace	


/* ---------------------------------------------- */
/*         Young scientist grant + general grants          */
/*            only associate professors           */
/* ---------------------------------------------- */

use "$temp_data_path/grants_researcher_year_assoc_prof.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & full_prof_pre == 0
local controls treat_female i.female#i.year i.treated#i.year

reghdfe youth_grant_ry `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe gen_grant_ry `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	legend(order(2 "Young scientist grant" 4 "General grant") pos(6) region(lw(0)) cols(2) symxsize(*1.5)) ///
	xlabel(,labsize(small)) ///
	ylabel(-0.1(0.05)0.1,labsize(small)) ///
	xtitle("Years relative to policy start (2011)") ///
	ytitle("Won grant")

graph export "$figure_path/Fig_young_gen_grant_assoc_prof_sample2.eps", replace
graph export "$figure_path/Fig_young_gen_grant_assoc_prof_sample2.pdf", replace	

/* ---------------------------------------------- */
/*         Young scientist grant + general grants          */
/* ---------------------------------------------- */

use "$temp_data_path/grants_researcher_year_assoc_prof.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & full_prof_pre == 0
local controls treat_female i.female#i.year i.treated#i.year

reghdfe youth_grant_ry `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe gen_grant_ry `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	legend(order(2 "Young scientist grant" 4 "General grant") pos(6) region(lw(0)) cols(2) symxsize(*1.5)) ///
	xlabel(,labsize(small)) ///
	ylabel(-0.1(0.05)0.1,labsize(small)) ///
	xtitle("Years relative to policy start (2011)") ///
	ytitle("Won grant")

graph export "$figure_path/Fig_young_gen_grant_assoc_prof_sample.eps", replace
graph export "$figure_path/Fig_young_gen_grant_assoc_prof_sample.pdf", replace	
