/*

Youth + general grants

*/



/* ---------------------------------------------------- */
/*    youth + general grants: cohorts [1966, 1975]      */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

reghdfe youth_gen_grant_ry `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	ylabel(-0.05(0.05)0.1,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Won any NSFC grant", size(4))
	
graph export "$figure_path/Fig_young_general_grant_1966_1975.eps", replace
graph export "$figure_path/Fig_young_general_grant_1966_1975.pdf", replace	
	

/* ----------------------------------------------------------- */
/*    youth + general grants: female cohorts [1970, 1971]      */
/* ----------------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1970 & author_birthyr <= 1971 & female == 1 
local controls i.author_birthyr#c.year

reghdfe youth_gen_grant_ry `treatlist1' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	ylabel(-0.03(0.03)0.06,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Won any NSFC grant", size(4))
	
graph export "$figure_path/Fig_young_general_grant_female_1970_1971.eps", replace
graph export "$figure_path/Fig_young_general_grant_female_1970_1971.pdf", replace		
	
	
/* ---------------------------------------------------- */
/*    youth + general grants: cohorts [1966, 1975]      */
/*           high- vs. lower-ability scholars           */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar3 == 1
local cond2_2 top_scholar3 == 0 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe youth_gen_grant_ry `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe youth_gen_grant_ry `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	legend(order(2 "High-ability scholars" 4 "Lower-ability scholars") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.05(0.05)0.1,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Won any NSFC grant", size(4))

graph export "$figure_path/Fig_young_general_grant_female_1966_1975_ability_het.eps", replace
graph export "$figure_path/Fig_young_general_grant_female_1966_1975_ability_het.pdf", replace	


/* ---------------------------------------------------- */
/*    youth + general grants: cohorts [1966, 1975]      */
/*           top-tier vs. lower-tier univs              */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 (wkunit_type == 1 | wkunit_type == 2) 
local cond2_2 wkunit_type == 4 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe youth_gen_grant_ry `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe youth_gen_grant_ry `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	legend(order(2 "Top-tier universities" 4 "Lower-tier universities") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.05(0.05)0.1,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Won any NSFC grant", size(4))

graph export "$figure_path/Fig_young_general_grant_female_1966_1975_rank_het.eps", replace
graph export "$figure_path/Fig_young_general_grant_female_1966_1975_rank_het.pdf", replace	


/* ---------------------------------------------------- */
/*    youth + general grants: cohorts [1966, 1975]      */
/*              amount of NSFC funding                  */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

reghdfe fund_amount_deflated `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	ylabel(-10(5)10,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Amount of NSFC funding (in 10,000 RMB)")
	
graph export "$figure_path/Fig_amount_grant_1966_1975.eps", replace
graph export "$figure_path/Fig_amount_grant_1966_1975.pdf", replace	


/* ----------------------------------------------------------- */
/*    youth + general grants: female cohorts [1970, 1971]      */
/*                  amount of NSFC funding                     */
/* ----------------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1970 & author_birthyr <= 1971 & female == 1 
local controls i.author_birthyr#c.year

reghdfe fund_amount_deflated `treatlist1' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	ylabel(-10(5)10,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Amount of NSFC funding (in 10,000 RMB)")
	
graph export "$figure_path/Fig_amount_grant_female_1970_1971.eps", replace
graph export "$figure_path/Fig_amount_grant_female_1970_1971.pdf", replace	


/* ---------------------------------------------------- */
/*    youth + general grants: cohorts [1966, 1975]      */
/*              amount of NSFC funding                  */
/*           high- vs. lower-ability scholars           */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar3 == 1
local cond2_2 top_scholar3 == 0 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe fund_amount_deflated `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe fund_amount_deflated `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	legend(order(2 "High-ability scholars" 4 "Lower-ability scholars") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-20(10)10,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Amount of NSFC funding (in 10,000 RMB)")

graph export "$figure_path/Fig_amount_grant_female_1966_1975_ability_het.eps", replace
graph export "$figure_path/Fig_amount_grant_female_1966_1975_ability_het.pdf", replace


/* ---------------------------------------------------- */
/*    youth + general grants: cohorts [1966, 1975]      */
/*              amount of NSFC funding                  */
/*           top-tier vs. lower-tier univs              */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 (wkunit_type == 1 | wkunit_type == 2) 
local cond2_2 wkunit_type == 4 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe fund_amount_deflated `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe fund_amount_deflated `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	ylabel(-20(10)10,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Amount of NSFC funding (in 10,000 RMB)")

graph export "$figure_path/Fig_amount_grant_1966_1975_rank_het.eps", replace
graph export "$figure_path/Fig_amount_grant_1966_1975_rank_het.pdf", replace


/* ---------------------------------------------------- */
/*    youth + general grants: cohorts [1966, 1975]      */
/*              amount of NSFC funding                  */
/*            985 vs. 211 vs. other univs               */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 wkunit_type == 1 
local cond2_2 wkunit_type == 2 
local cond2_3 wkunit_type == 4 
local controls treat_female i.female#i.year i.treated#i.year

reghdfe fund_amount_deflated `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe fund_amount_deflated `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2
reghdfe fund_amount_deflated `treatlist1' `controls' if `cond1' & `cond2_3', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant3

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.2)) ///
	(grant2, msymbol(Th) mcolor(gs6) lcolor(gs6) ciopts(recast(rcap) lcolor(gs6) lpattern(dash)) offset(0)) ///
	(grant3, msymbol(S) mcolor(gs12) lcolor(gs12) ciopts(recast(rcap) lcolor(gs12) lpattern(solid)) offset(0.2)), ///
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
	ylabel(-20(10)10,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Amount of NSFC funding (in 10,000 RMB)")

graph export "$figure_path/Fig_amount_grant_1966_1975_3rank_het.eps", replace
graph export "$figure_path/Fig_amount_grant_1966_1975_3rank_het.pdf", replace


/* ------------------------------------------------------------------ */
/*           youth + general grants: cohorts [1966, 1975]             */
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

reghdfe fund_amount_deflated `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe fund_amount_deflated `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2
reghdfe fund_amount_deflated `treatlist1' `controls' if `cond1' & `cond3_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant3
reghdfe fund_amount_deflated `treatlist1' `controls' if `cond1' & `cond3_2', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	legend(order(2 "High-performing scholars + Elite univ." 4 "High-performing scholars + Other univ." ///
		6 "Other scholars + Elite univ." 8 "Other scholars + Other univ.") ///
		pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-40(20)20,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Amount of NSFC funding (in 10,000 RMB)")

graph export "$figure_path/Fig_amount_grant_1966_1975_univ_ability_het.eps", replace
graph export "$figure_path/Fig_amount_grant_1966_1975_univ_ability_het.pdf", replace	


/* ---------------------------------------------------- */
/*      youth + general grants: cohorts [1966, 1975]    */
/*             the total amount of funding              */
/*                        table                         */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2 (author_birthyr >= 1966 & author_birthyr <= 1975) & (nsfc_field0 == 2 | nsfc_field0 == 3 | nsfc_field0 == 8) 
local cond3 (author_birthyr >= 1966 & author_birthyr <= 1975) & (nsfc_field0 == 1 | nsfc_field0 == 4 | nsfc_field0 == 5 | nsfc_field0 == 6)
local cond4 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar3 == 1
local cond5 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar3 == 0 
local cond6 (author_birthyr >= 1966 & author_birthyr <= 1975) & (wkunit_type == 1 | wkunit_type == 2) 
local cond7 (author_birthyr >= 1966 & author_birthyr <= 1975) & wkunit_type == 4 
local controls treat_female treat_post post_female 

forvalues i = 1/7 {
	
	reghdfe fund_amount_deflated treat_female_post `controls' if `cond`i'', absorb(author_numid2 year) vce(cluster author_numid2) 
	
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
	sum fund_amount_deflated if `cond`i''
	local mean_`i': di %9.3f r(mean)	
	
}

forvalues i = 1/7 {
	
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

forvalues i = 1/7 {
	
    local tex_te = "`tex_te' & `te_`i''`st_`i''"
    local tex_se = "`tex_se' & (`se_`i'')"
    local tex_mean = "`tex_mean' & `mean_`i''"
    local tex_obs = "`tex_obs' & `n_`i''"	
	
}

texdoc init "$table_path/Tab_amount_funding.tex", replace force

tex \begin{tabular}{lccccccc}
tex \hline \hline
tex & \multicolumn{1}{c}{Full} & \multicolumn{2}{c}{Proportion female} & \multicolumn{2}{c}{Baseline productivity} & \multicolumn{2}{c}{Prestige of home} \\
tex & \multicolumn{1}{c}{sample} & \multicolumn{2}{c}{in field} & \multicolumn{2}{c}{of scientist} & \multicolumn{2}{c}{institution}
tex & \cmidrule(lr){3-4} \cmidrule(lr){5-6} \cmidrule(lr){7-8}
tex & & Higher & Lower & Higher & Lower & Elite & Other \\
tex \hline
tex & & & & & & & \\
tex `tex_te' \\
tex `tex_se' \\
tex & & & & & & & \\
tex `tex_mean' \\
tex `tex_obs' \\
tex \hline \hline
tex \end{tabular}

texdoc close


/* ---------------------------------------------------- */
/*      youth + general grants: cohorts [1966, 1975]    */
/*             the total number of grants               */
/*                        table                         */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar3 == 1
local cond3 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar3 == 0 
local cond4 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar1 == 1
local cond5 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar1 == 0 
local controls treat_female treat_post post_female 

forvalues i = 1/5 {
	
	reghdfe youth_gen_grant_ry treat_female_post `controls' if `cond`i'', absorb(author_numid2 year) vce(cluster author_numid2) 
	
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
	sum youth_gen_grant_ry if `cond`i''
	local mean_`i': di %9.3f r(mean)	
	
}

forvalues i = 1/5 {
	
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

forvalues i = 1/5 {
	
    local tex_te = "`tex_te' & `te_`i''`st_`i''"
    local tex_se = "`tex_se' & (`se_`i'')"
    local tex_mean = "`tex_mean' & `mean_`i''"
    local tex_obs = "`tex_obs' & `n_`i''"	
	
}

texdoc init "$table_path/Tab_overall_num_grants.tex", replace force

tex \begin{tabular}{lccccc}
tex \hline \hline
tex & \multicolumn{1}{c}{} & \multicolumn{2}{c}{Published in} & \multicolumn{2}{c}{Published in} \\
tex & \multicolumn{1}{c}{} & \multicolumn{2}{c}{any journal} & \multicolumn{2}{c}{top journal} \\
tex & \multicolumn{1}{c}{} & \multicolumn{2}{c}{prior to policy} & \multicolumn{2}{c}{prior to policy} 
tex & \cmidrule(lr){3-4} \cmidrule(lr){5-6} 
tex & (1)  & (2)  & (3)  & (4)  & (5) \\
tex & Full sample & Yes & No  & Yes & No \\
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


