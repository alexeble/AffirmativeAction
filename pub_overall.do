/*

scientific productivity: the overall effect

use "inverse hyperbolic sine transformation" instead:
- see Jiafeng Chen and Jonathan Roth (2024)'s QJE
- see Ash et al. (2022)

* Edited by Alex 2025-06-27.

*/

/* -------------------------------------------------------- */
/*               total number of journal papers:            */
/*                    cohorts [1966, 1975]                  */
/* -------------------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

/*
local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

reghdfe n_jpapers_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.2(0.2)0.2,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of publications", size(4)) 

graph export "$figure_path/Fig_pub_1966_1975.eps", replace
graph export "$figure_path/Fig_pub_1966_1975.pdf", replace	
*/

* poisson 

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe n_jpapers_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.2(0.2)0.4,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of publications", size(4)) 

graph export "$figure_path/Fig_pub_1966_1975_poisson.eps", replace
graph export "$figure_path/Fig_pub_1966_1975_poisson.pdf", replace	

/*------- poisson: moving average 3
* the moving average results are not as good as expected because it smooths away the changes

* prepare the data:

tsset author_numid2 year
tssmooth ma n_jpapers_yr_ma3 = n_jpapers_yr, window(1 1 1)

* regression

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe n_jpapers_yr_ma3 `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.2(0.2)0.4,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of publications", size(4)) 

graph export "$figure_path/Fig_pub_1966_1975_poisson_ma3.eps", replace
graph export "$figure_path/Fig_pub_1966_1975_poisson_ma3.pdf", replace		
*/

/* ----------------------------------------------------------- */
/*               total number of journal papers:               */
/*                female cohorts [1970, 1971]                  */
/* ----------------------------------------------------------- */
/*
use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1970 & author_birthyr <= 1971 & female == 1 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe n_jpapers_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.4(0.2)0.2,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of publications", size(4)) 

graph export "$figure_path/Fig_pub_female_1970_1971.eps", replace
graph export "$figure_path/Fig_pub_female_1970_1971.pdf", replace	
*/

/* -------------------------------------------------------- */
/*               total number of journal papers:            */
/*                    cohorts [1966, 1975]                  */
/*      robustness: limiting to fund-demanding fields       */
/* -------------------------------------------------------- */
* as a robustness check: excluding math/business/economics fields that do not demand much on funding
* not show heterogeneity because the prop of math/business/economics fields is small: 8.55%

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

/*
local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & field_fund == 1
local controls treat_female i.female#i.year i.treated#i.year

reghdfe n_jpapers_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.2(0.2)0.2,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of publications", size(4)) 

graph export "$figure_path/Fig_pub_1966_1975_fund_demanding_field.eps", replace
graph export "$figure_path/Fig_pub_1966_1975_fund_demanding_field.pdf", replace	
*/

* poisson 

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & field_fund == 1
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe n_jpapers_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.2(0.2)0.2,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of publications", size(4)) 

graph export "$figure_path/Fig_pub_1966_1975_fund_demanding_field_poisson.eps", replace
graph export "$figure_path/Fig_pub_1966_1975_fund_demanding_field_poisson.pdf", replace	


/* -------------------------------------------------------- */
/*          number of 1st-authored journal papers:          */
/*                    cohorts [1966, 1975]                  */
/* -------------------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

/*
local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

reghdfe n_jpapers1_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.2(0.2)0.2,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of first-authored publications", size(4)) 

graph export "$figure_path/Fig_first_pub_1966_1975.eps", replace
graph export "$figure_path/Fig_first_pub_1966_1975.pdf", replace
*/

* poisson 

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe n_jpapers1_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.4(0.2)0.4,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of first-authored publications", size(4)) 

graph export "$figure_path/Fig_first_pub_1966_1975_poisson.eps", replace
graph export "$figure_path/Fig_first_pub_1966_1975_poisson.pdf", replace

  
/* --------------------------------------------------------- */
/*          number of last-authored journal papers:          */
/*                    cohorts [1966, 1975]                   */
/* --------------------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

/*
local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

reghdfe n_jpapers9_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.2(0.2)0.2,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of last-authored publications", size(4)) 

graph export "$figure_path/Fig_last_pub_1966_1975.eps", replace
graph export "$figure_path/Fig_last_pub_1966_1975.pdf", replace	
*/

* poisson 

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe n_jpapers9_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.5(0.5)1,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of last-authored publications", size(4)) 

graph export "$figure_path/Fig_last_pub_1966_1975_poisson.eps", replace
graph export "$figure_path/Fig_last_pub_1966_1975_poisson.pdf", replace	


/* --------------------------------------------- */
/*               number of citations:            */
/*               cohorts [1966, 1975]            */
/* --------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

/*
local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

reghdfe n_jcite_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-10(10)10,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of citations") 

graph export "$figure_path/Fig_num_cite_1966_1975.eps", replace
graph export "$figure_path/Fig_num_cite_1966_1975.pdf", replace	
*/

* poisson 

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe n_jcite_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.5(0.5)1,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of citations") 

graph export "$figure_path/Fig_num_cite_1966_1975_poisson.eps", replace
graph export "$figure_path/Fig_num_cite_1966_1975_poisson.pdf", replace	


/* --------------------------------------------------- */
/*          number of top 25% journal papers:          */
/*                 cohorts [1966, 1975]                */
/* --------------------------------------------------- */
* top 25% journals in terms of impact factors

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

/*
local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

reghdfe n_jpapers25_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.2(0.2)0.2,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of top publications", size(4)) 

graph export "$figure_path/Fig_num_25p_top_1966_1975.eps", replace
graph export "$figure_path/Fig_num_25p_top_1966_1975.pdf", replace	
*/

* poisson 

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe n_jpapers25_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.5(0.5)0.5,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of top publications", size(4)) 

graph export "$figure_path/Fig_num_25p_top_1966_1975_poisson.eps", replace
graph export "$figure_path/Fig_num_25p_top_1966_1975_poisson.pdf", replace	


/* --------------------------------------------------- */
/*          number of top 10% journal papers:          */
/*                 cohorts [1966, 1975]                */
/* --------------------------------------------------- */
* top 10% journals in terms of impact factors

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

/*
local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

reghdfe n_jpapers10_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.2(0.2)0.2,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of top publications", size(4)) 

graph export "$figure_path/Fig_num_10p_top_1966_1975.eps", replace
graph export "$figure_path/Fig_num_10p_top_1966_1975.pdf", replace	
*/

* poisson 

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe n_jpapers10_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.5(0.5)1,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of top publications", size(4)) 

graph export "$figure_path/Fig_num_10p_top_1966_1975_poisson.eps", replace
graph export "$figure_path/Fig_num_10p_top_1966_1975_poisson.pdf", replace	


/* --------------------------------------------------- */
/*             number of coauthors per paper:          */
/*                 cohorts [1966, 1975]                */
/* --------------------------------------------------- */
* poisson

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe avg_author_jcount_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.5(0.5)0.5,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of coauthors per paper", size(4)) 

graph export "$figure_path/Fig_num_coauthors_1966_1975_poisson.eps", replace
graph export "$figure_path/Fig_num_coauthors_1966_1975_poisson.pdf", replace	


/* ---------------------------------------------------- */
/*          publications: cohorts [1966, 1975]          */
/*                        table                         */
/* ---------------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

/*
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 
local controls treat_female treat_post post_female 
local varlist n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jcite_yr n_jpapers25_yr avg_author_jcount_yr

foreach i in `varlist' {
	
	reghdfe `i' treat_female_post `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
	
	* Saving the parameter estimates
    local te_`i' = _b[treat_female_post]
    local se_`i' = _se[treat_female_post]
	
    * Generating t-stats
    local tstat_`i' = abs(_b[treat_female_post]/_se[treat_female_post])		

    * no of obs
    local n_`i': di %9.0fc e(N)	
	
    * R-sq
    local rsq_`i': di %9.3f e(r2)	
	
	* Outcome mean
	sum `i' if `cond1'
	local mean_`i': di %9.3f r(mean)	
	
}

foreach i in `varlist' {
	
	* Generating stars for significance
    if `tstat_`i'' >= 1.64 local st_`i' = "*"
    if `tstat_`i'' >= 1.96 local st_`i' = "**"
    if `tstat_`i'' >= 2.33 local st_`i' = "***"
	
    * Formatting the parameters (making them the same number of significant figures and pretty for the table)
    local te_`i': di %9.3f `te_`i''
    local se_`i': di %9.3f `se_`i''
	
    * Dropping the hanging space that this code generates so I can use parentheses around the parameter without it appearing like "(x.xxx )"
    local se_`i' = subinstr("`se_`i''"," ","",.)			
	
}	

local tex_te "$\beta_{1}$: policy effect"
local tex_se ""
local tex_mean "\textit{Outcome mean}"
local tex_obs "\textit{N}"

foreach i in `varlist' {
	
	local tex_te = "`tex_te' & `te_`i''`st_`i''"
	local tex_se = "`tex_se' & (`se_`i'')"
	local tex_mean = "`tex_mean' & `mean_`i''"
	local tex_obs = "`tex_obs' & `n_`i''"
	
}

texdoc init "$table_path/Tab_pub.tex", replace force

tex \begin{tabular}{lccccc}
tex \hline \hline
tex & No. of & No. of first- & No. of last- & No. of & No. of \\
tex & pubs & authored pubs & authored pubs & citations & top pubs \\
tex \hline
tex & & & & & \\
tex `tex_te' \\
tex `tex_se' \\
tex & & & & & \\
tex `tex_mean' \\
tex `tex_obs' \\
tex & & & & & \\
tex \hline \hline
tex \end{tabular}

texdoc close
*/

*### poisson: [-10, 10]

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 
local controls treat_female treat_post post_female 
local varlist n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jpapers25_yr n_jcite_yr

foreach i in `varlist' {
	
	ppmlhdfe `i' treat_female_post `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
	
	* Saving the parameter estimates
    local te_`i' = _b[treat_female_post]
    local se_`i' = _se[treat_female_post]
	
    * Generating t-stats
    local tstat_`i' = abs(_b[treat_female_post]/_se[treat_female_post])		

    * no of obs
    local n_`i': di %9.0fc e(N)	
	
    * R-sq
    local rsq_`i': di %9.3f e(r2)	
	
	* Outcome mean
	sum `i' if `cond1'
	local mean_`i': di %9.3f r(mean)	
	
}

foreach i in `varlist' {
	
	* Generating stars for significance
    if `tstat_`i'' >= 1.64 local st_`i' = "*"
    if `tstat_`i'' >= 1.96 local st_`i' = "**"
    if `tstat_`i'' >= 2.33 local st_`i' = "***"
	
    * Formatting the parameters (making them the same number of significant figures and pretty for the table)
    local te_`i': di %9.3f `te_`i''
    local se_`i': di %9.3f `se_`i''
	
    * Dropping the hanging space that this code generates so I can use parentheses around the parameter without it appearing like "(x.xxx )"
    local se_`i' = subinstr("`se_`i''"," ","",.)			
	
}	

local tex_te "$\beta_{1}$: policy effect"
local tex_se ""
local tex_mean "\textit{Outcome mean}"
local tex_obs "\textit{N}"

foreach i in `varlist' {
	
	local tex_te = "`tex_te' & `te_`i''`st_`i''"
	local tex_se = "`tex_se' & (`se_`i'')"
	local tex_mean = "`tex_mean' & `mean_`i''"
	local tex_obs = "`tex_obs' & `n_`i''"
	
}

texdoc init "$table_path/Tab_pub_poisson.tex", replace force

tex \begin{tabular}{lccccc}
tex \hline \hline
tex & \multicolumn{4}{c}{Number of publications} & \multicolumn{1}{c}{Number of}
tex & \cmidrule(lr){2-5} 
tex & All & First-authored & Last-authored & Top & citations \\
tex \hline
tex & & & & & \\
tex `tex_te' \\
tex `tex_se' \\
tex & & & & & \\
tex `tex_mean' \\
tex `tex_obs' \\
tex \hline \hline
tex \end{tabular}

texdoc close

*### poisson: [-5, 10]

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & yr_diff >= -5
local controls treat_female treat_post post_female 
local varlist n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jpapers25_yr n_jcite_yr

foreach i in `varlist' {
	
	ppmlhdfe `i' treat_female_post `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
	
	* Saving the parameter estimates
    local te_`i' = _b[treat_female_post]
    local se_`i' = _se[treat_female_post]
	
    * Generating t-stats
    local tstat_`i' = abs(_b[treat_female_post]/_se[treat_female_post])		

    * no of obs
    local n_`i': di %9.0fc e(N)	
	
    * R-sq
    local rsq_`i': di %9.3f e(r2)	
	
	* Outcome mean
	sum `i' if `cond1'
	local mean_`i': di %9.3f r(mean)	
	
}

foreach i in `varlist' {
	
	* Generating stars for significance
    if `tstat_`i'' >= 1.64 local st_`i' = "*"
    if `tstat_`i'' >= 1.96 local st_`i' = "**"
    if `tstat_`i'' >= 2.33 local st_`i' = "***"
	
    * Formatting the parameters (making them the same number of significant figures and pretty for the table)
    local te_`i': di %9.3f `te_`i''
    local se_`i': di %9.3f `se_`i''
	
    * Dropping the hanging space that this code generates so I can use parentheses around the parameter without it appearing like "(x.xxx )"
    local se_`i' = subinstr("`se_`i''"," ","",.)			
	
}	

local tex_te "$\beta_{1}$: policy effect"
local tex_se ""
local tex_mean "\textit{Outcome mean}"
local tex_obs "\textit{N}"

foreach i in `varlist' {
	
	local tex_te = "`tex_te' & `te_`i''`st_`i''"
	local tex_se = "`tex_se' & (`se_`i'')"
	local tex_mean = "`tex_mean' & `mean_`i''"
	local tex_obs = "`tex_obs' & `n_`i''"
	
}

texdoc init "$table_path/Tab_pub_poisson2.tex", replace force

tex \begin{tabular}{lccccc}
tex \hline \hline
tex & \multicolumn{4}{c}{Number of publications} & \multicolumn{1}{c}{Number of}
tex & \cmidrule(lr){2-5} 
tex & All & First-authored & Last-authored & Top & citations \\
tex \hline
tex & & & & & \\
tex `tex_te' \\
tex `tex_se' \\
tex & & & & & \\
tex `tex_mean' \\
tex `tex_obs' \\
tex \hline \hline
tex \end{tabular}

texdoc close

