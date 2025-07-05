/*

placebo tests: 1966-1970 cohorts vs. 1961-1965 cohorts

no placebo results with young scientist grant:
 - the 1961-1965 cohorts are not qualified for young scientist grant applications during our analysis period [2001, 2021]

*/


/* ---------------------------------------------------- */
/*         general grants: cohorts [1961, 1970]         */
/* ---------------------------------------------------- */

use "$data_path\grants_researcher_year_61_70.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1961 & author_birthyr <= 1970
local controls treat_female i.female#i.year i.treated#i.year

reghdfe gen_grant_ry `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	ylabel(-0.05(0.05)0.05,labsize(4)) ///
	xtitle("Distance to year 2011", size(4)) ///
	ytitle("Likelihood of acquiring a general grant", size(4))

graph export "$figure_path\Fig_general_grant_1961_1970.eps", replace
graph export "$figure_path\Fig_general_grant_1961_1970.pdf", replace	


/* ---------------------------------------------------- */
/*           promotion: cohorts [1961, 1970]            */
/* ---------------------------------------------------- */

use "$data_path\grants_researcher_year_61_70.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1961 & author_birthyr <= 1970
local controls treat_female i.female#i.year i.treated#i.year

reghdfe assoc_prof `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store reg1
reghdfe full_prof `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store reg2

coefplot (reg1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(reg2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Associate professor" 4 "Full professor") pos(6) region(lstyle(solid)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.04(0.02)0.04,labsize(4)) ///
	xtitle("Distance to year 2011", size(4)) ///
	ytitle("Likelihood of promotion", size(4))

graph export "$figure_path\Fig_promotion_1961_1970.eps", replace
graph export "$figure_path\Fig_promotion_1961_1970.pdf", replace	

