/*

compare DD results for females and males to justify the use of DDD in the main analysis

* Edited by Alex 2025-06-27.

*/


/* ---------------------------------------------------- */
/*         youth grants: cohorts [1966, 1975]           */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 female == 1
local cond2_2 female == 0

reghdfe youth_grant_ry `treatlist1' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe youth_grant_ry `treatlist1' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, recast(scatter) msymbol(Oh) mcolor(gs0) ciopts(recast(rcap) lcolor(gs0))) ///
	(grant1, recast(line) lcolor(gs0) lpattern(solid) noci) ///
	(grant2, recast(scatter) msymbol(S) mcolor(gs10) offset(0.1) ciopts(recast(rcap) lcolor(gs8))) ///
	(grant2, recast(line) lcolor(gs10) lpattern(dash) noci), ///	
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Female" 5 "Male") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.03(0.03)0.06,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Won the young scientist grant", size(4))

graph export "$figure_path/Fig_young_grant_1966_1975_DD.eps", replace
graph export "$figure_path/Fig_young_grant_1966_1975_DD.pdf", replace	


/* ---------------------------------------------------- */
/*         general grants: cohorts [1966, 1975]         */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 female == 1
local cond2_2 female == 0

reghdfe gen_grant_ry `treatlist1' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe gen_grant_ry `treatlist1' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, recast(scatter) msymbol(Oh) mcolor(gs0) ciopts(recast(rcap) lcolor(gs0))) ///
	(grant1, recast(line) lcolor(gs0) lpattern(solid) noci) ///
	(grant2, recast(scatter) msymbol(S) mcolor(gs10) offset(0.1) ciopts(recast(rcap) lcolor(gs8))) ///
	(grant2, recast(line) lcolor(gs10) lpattern(dash) noci), ///	
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Female" 5 "Male") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.06(0.03)0.03,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Won a general grant", size(4))

graph export "$figure_path/Fig_general_grant_1966_1975_DD.eps", replace
graph export "$figure_path/Fig_general_grant_1966_1975_DD.pdf", replace	


/* ---------------------------------------------------- */
/*           promotion: cohorts [1966, 1975]            */
/* ---------------------------------------------------- */

*====== promotion to full professor

use "$data_path/grants_researcher_year_66_75_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 female == 1
local cond2_2 female == 0

reghdfe full_prof `treatlist1' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe full_prof `treatlist1' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, recast(scatter) msymbol(Oh) mcolor(gs0) ciopts(recast(rcap) lcolor(gs0))) ///
	(grant1, recast(line) lcolor(gs0) lpattern(solid) noci) ///
	(grant2, recast(scatter) msymbol(S) mcolor(gs10) offset(0.1) ciopts(recast(rcap) lcolor(gs8))) ///
	(grant2, recast(line) lcolor(gs10) lpattern(dash) noci), ///	
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Female" 5 "Male") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.04(0.02)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to full professor", size(4))

graph export "$figure_path/Fig_promotion_fullprof_1966_1975_DD.eps", replace
graph export "$figure_path/Fig_promotion_fullprof_1966_1975_DD.pdf", replace	


*====== promotion to associate professor

use "$data_path/grants_researcher_year_66_75_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 female == 1
local cond2_2 female == 0

reghdfe assoc_prof `treatlist1' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe assoc_prof `treatlist1' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, recast(scatter) msymbol(Oh) mcolor(gs0) ciopts(recast(rcap) lcolor(gs0))) ///
	(grant1, recast(line) lcolor(gs0) lpattern(solid) noci) ///
	(grant2, recast(scatter) msymbol(S) mcolor(gs10) offset(0.1) ciopts(recast(rcap) lcolor(gs8))) ///
	(grant2, recast(line) lcolor(gs10) lpattern(dash) noci), ///	
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Female" 5 "Male") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.04(0.02)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted to associate professor", size(4))

graph export "$figure_path/Fig_promotion_assocprof_1966_1975_DD.eps", replace
graph export "$figure_path/Fig_promotion_assocprof_1966_1975_DD.pdf", replace	


/* -------------------------------------------------------- */
/*               total number of journal papers:            */
/*                    cohorts [1966, 1975]                  */
/* -------------------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 female == 1
local cond2_2 female == 0

ppmlhdfe n_jpapers_yr `treatlist1' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
ppmlhdfe n_jpapers_yr `treatlist1' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, recast(scatter) msymbol(Oh) mcolor(gs0) ciopts(recast(rcap) lcolor(gs0))) ///
	(grant1, recast(line) lcolor(gs0) lpattern(solid) noci) ///
	(grant2, recast(scatter) msymbol(S) mcolor(gs10) offset(0.1) ciopts(recast(rcap) lcolor(gs8))) ///
	(grant2, recast(line) lcolor(gs10) lpattern(dash) noci), ///	
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Female" 5 "Male") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.4(0.2)0.4,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of publications", size(4))

graph export "$figure_path/Fig_pub_1966_1975_DD.eps", replace
graph export "$figure_path/Fig_pub_1966_1975_DD.pdf", replace	


/* -------------------------------------------------------- */
/*          number of 1st-authored journal papers:          */
/*                    cohorts [1966, 1975]                  */
/* -------------------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 female == 1
local cond2_2 female == 0

ppmlhdfe n_jpapers1_yr `treatlist1' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
ppmlhdfe n_jpapers1_yr `treatlist1' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, recast(scatter) msymbol(Oh) mcolor(gs0) ciopts(recast(rcap) lcolor(gs0))) ///
	(grant1, recast(line) lcolor(gs0) lpattern(solid) noci) ///
	(grant2, recast(scatter) msymbol(S) mcolor(gs10) offset(0.1) ciopts(recast(rcap) lcolor(gs8))) ///
	(grant2, recast(line) lcolor(gs10) lpattern(dash) noci), ///	
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Female" 5 "Male") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.8(0.4)0.4,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of first-authored publications", size(4))

graph export "$figure_path/Fig_pub1_1966_1975_DD.eps", replace
graph export "$figure_path/Fig_pub1_1966_1975_DD.pdf", replace	


/* -------------------------------------------------------- */
/*          number of last-authored journal papers:         */
/*                    cohorts [1966, 1975]                  */
/* -------------------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 female == 1
local cond2_2 female == 0

ppmlhdfe n_jpapers9_yr `treatlist1' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
ppmlhdfe n_jpapers9_yr `treatlist1' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, recast(scatter) msymbol(Oh) mcolor(gs0) ciopts(recast(rcap) lcolor(gs0))) ///
	(grant1, recast(line) lcolor(gs0) lpattern(solid) noci) ///
	(grant2, recast(scatter) msymbol(S) mcolor(gs10) offset(0.1) ciopts(recast(rcap) lcolor(gs8))) ///
	(grant2, recast(line) lcolor(gs10) lpattern(dash) noci), ///	
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Female" 5 "Male") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.8(0.4)0.4,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of last-authored publications", size(4))

graph export "$figure_path/Fig_pub9_1966_1975_DD.eps", replace
graph export "$figure_path/Fig_pub9_1966_1975_DD.pdf", replace	


/* --------------------------------------------- */
/*               number of citations:            */
/*               cohorts [1966, 1975]            */
/* --------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 female == 1
local cond2_2 female == 0

ppmlhdfe n_jcite_yr `treatlist1' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
ppmlhdfe n_jcite_yr `treatlist1' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, recast(scatter) msymbol(Oh) mcolor(gs0) ciopts(recast(rcap) lcolor(gs0))) ///
	(grant1, recast(line) lcolor(gs0) lpattern(solid) noci) ///
	(grant2, recast(scatter) msymbol(S) mcolor(gs10) offset(0.1) ciopts(recast(rcap) lcolor(gs8))) ///
	(grant2, recast(line) lcolor(gs10) lpattern(dash) noci), ///	
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Female" 5 "Male") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-1(0.5)1,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of citations", size(4))

graph export "$figure_path/Fig_num_cite_1966_1975_DD.eps", replace
graph export "$figure_path/Fig_num_cite_1966_1975_DD.pdf", replace	


/* --------------------------------------------------- */
/*          number of top 25% journal papers:          */
/*                 cohorts [1966, 1975]                */
/* --------------------------------------------------- */
* top 25% journals in terms of impact factors

use "$data_path/psInfo_scopus_pubs_yr_66_75_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 female == 1
local cond2_2 female == 0

ppmlhdfe n_jpapers25_yr `treatlist1' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
ppmlhdfe n_jpapers25_yr `treatlist1' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2

coefplot (grant1, recast(scatter) msymbol(Oh) mcolor(gs0) ciopts(recast(rcap) lcolor(gs0))) ///
	(grant1, recast(line) lcolor(gs0) lpattern(solid) noci) ///
	(grant2, recast(scatter) msymbol(S) mcolor(gs10) offset(0.1) ciopts(recast(rcap) lcolor(gs8))) ///
	(grant2, recast(line) lcolor(gs10) lpattern(dash) noci), ///	
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Female" 5 "Male") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-1(0.5)0.5,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of top publications", size(4))

graph export "$figure_path/Fig_num_25p_top_1966_1975_DD.eps", replace
graph export "$figure_path/Fig_num_25p_top_1966_1975_DD.pdf", replace	

