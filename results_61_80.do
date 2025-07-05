

* Edited by Alex 2025-06-27.



 
/* ---------------------------------------------------- */
/*         youth grants: cohorts [1961, 1980]           */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1961 & author_birthyr <= 1980
local controls treat_female i.female#i.year i.treated#i.year

reghdfe youth_grant_ry `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Won a young scientist grant", size(4))

graph export "$figure_path/Fig_young_grant_1961_1980.eps", replace
graph export "$figure_path/Fig_young_grant_1961_1980.pdf", replace	



/* ---------------------------------------------------- */
/*         general grants: cohorts [1961, 1980]         */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year.dta", clear
	
local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1961 & author_birthyr <= 1980 
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
	ylabel(-0.05(0.05)0.05, labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Won a general grant", size(4))
	
graph export "$figure_path/Fig_general_grant_1961_1980.eps", replace
graph export "$figure_path/Fig_general_grant_1961_1980.pdf", replace	


/* ---------------------------------------------------- */
/*           promotion: cohorts [1961, 1980]            */
/*                 period: [-10, 10]                    */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1961 & author_birthyr <= 1980
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
	legend(order(2 "Associate professor" 4 "Full professor") pos(6) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.04(0.02)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Likelihood of promotion", size(4))

graph export "$figure_path/Fig_promotion_1961_1980.eps", replace
graph export "$figure_path/Fig_promotion_1961_1980.pdf", replace	


/* ---------------------------------------------------- */
/*     DD - youth grants: cohorts [1961, 1980]          */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_61_80_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1961 & author_birthyr <= 1980
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
	legend(order(2 "Female" 5 "Male") pos(6) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.06(0.03)0.03,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Won a young scientist grant", size(4))

graph export "$figure_path/Fig_young_grant_1961_1980_DD.eps", replace
graph export "$figure_path/Fig_young_grant_1961_1980_DD.pdf", replace	


/* ---------------------------------------------------- */
/*      DD - general grants: cohorts [1961, 1980]       */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_61_80_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1961 & author_birthyr <= 1980
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
	legend(order(2 "Female" 5 "Male") pos(6) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.03(0.03)0.06,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Won a general grant", size(4))

graph export "$figure_path/Fig_general_grant_1961_1980_DD.eps", replace
graph export "$figure_path/Fig_general_grant_1961_1980_DD.pdf", replace	


/* ---------------------------------------------------- */
/*       DD - promotion: cohorts [1961, 1980]           */
/* ---------------------------------------------------- */

*====== promotion to full professor

use "$data_path/grants_researcher_year_61_80_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1961 & author_birthyr <= 1980
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
	legend(order(2 "Female" 5 "Male") pos(6) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.03(0.03)0.06,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Likelihood of full prof promotion", size(4))

graph export "$figure_path/Fig_promotion_fullprof_1961_1980_DD.eps", replace
graph export "$figure_path/Fig_promotion_fullprof_1961_1980_DD.pdf", replace	


*====== promotion to associate professor

use "$data_path/grants_researcher_year_61_80_DD.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1961 & author_birthyr <= 1980
local cond2_1 female == 1
local cond2_2 female == 0

*reghdfe assoc_prof `treatlist1' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
*est store grant1
*reghdfe assoc_prof `treatlist1' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
*est store grant2

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
	legend(order(2 "Female" 5 "Male") pos(6) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.06(0.03)0.06,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Likelihood of assoc prof promotion", size(4))

graph export "$figure_path/Fig_promotion_assocprof_1961_1980_DD.eps", replace
graph export "$figure_path/Fig_promotion_assocprof_1961_1980_DD.pdf", replace	

