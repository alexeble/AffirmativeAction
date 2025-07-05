/*

application behaviors of those who were associate professors before the policy

*/


/* ----------------------------------------------------------- */
/*                        preparing data                       */
/* ----------------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

merge n:1 author_numid2 using "$data_path/pre_policy_char_66_75.dta", keepusing(author_numid2 pre_youth_grant pre_gen_grant pre_full_prof pre_assoc_prof)

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                             0
    Matched                         1,103,802  (_merge==3)
    -----------------------------------------
*/

drop _merge

save "$temp_data_path/grants_researcher_year_for_discussion.dta", replace 


/* ------------------------------------- */
/*                key facts              */
/* ------------------------------------- */

*------ gender diffs in taste for competition

use "$data_path/author_wkunit_psInfo_grant.dta", clear

local cond1 age_gengrant <= 35 & youth_grant == 0
local cond2 author_birthyr >= 1966 & author_birthyr <= 1970 & gen_grant == 1 // limit to older cohorts who received general grants

gen d_gengrant_young = 0
replace d_gengrant_young = 1 if `cond1'

tab female if `cond2', sum(d_gengrant_young) // male: 0.034; female: 0.010


/* --------------------------------------------------------- */
/*       youth/general grants: success rate by gender        */
/* --------------------------------------------------------- */

use "$raw_data_path/grant_success_rate.dta", clear

keep if year >= 2008

*###### all

twoway (connected youth_grant_success year, color(gs0) msymbol(O) lpattern(solid))  ///
    (connected gen_grant_success year, color(gs10) msymbol(Th) lpattern(dash)), ///
    legend(order(1 "All: young scientist grant" 2 "All: general grant") pos(6) cols(2) region(lstyle(solid)) size(4)) ///
    xlabel(2008(3)2021,labsize(4)) ///
	ylabel(0.1(0.1)0.3,labsize(4)) ///
    xline(2010.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Year", margin(small) size(4)) ///
	ytitle("Success rate of grant applications", size(4))	

graph export "$figure_path/Fig_success_rate_grant_app.eps", replace
graph export "$figure_path/Fig_success_rate_grant_app.pdf", replace   

*###### by gender

twoway (connected youth_grant_female_success year, color(gs0) msymbol(O) lpattern(solid))  ///
    (connected youth_grant_male_success year, color(gs10) msymbol(Th) lpattern(dash)) ///
	(connected gen_grant_female_success year, color(blue%80) msymbol(O) lpattern(solid))  ///
    (connected gen_grant_male_success year, color(blue%30) msymbol(Th) lpattern(dash)), ///
    legend(order(1 "Female: young scientist grant" 2 "Male: young scientist grant" 3 "Female: general grant" 4 "Male: general grant") pos(6) cols(2) region(lstyle(solid)) size(4)) ///
    xlabel(2008(3)2021,labsize(4)) ///
	ylabel(0.1(0.1)0.3,labsize(4)) ///
    xline(2010.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Year", margin(small) size(4)) ///
	ytitle("Success rate of grant applications", size(4))	

graph export "$figure_path/Fig_success_rate_grant_app_by_gender.eps", replace
graph export "$figure_path/Fig_success_rate_grant_app_by_gender.pdf", replace   


/* ----------------------------------------------------------- */
/*          age at promotion: by gender and over time          */
/*                    cohorts [1961, 1991]                     */
/* ----------------------------------------------------------- */

*--- age at promotion to full professor

use "$data_path/grants_researcher_year.dta", clear

gen age_full_prof = full_prof_year - author_birthyr
keep if age_full_prof < .

sort author_numid2
by author_numid2: gen count = _n
keep if count == 1
drop count

collapse (mean) age_full_prof if female < ., by(full_prof_year female)
rename full_prof_year year

save "$temp_data_path/age_promotion_full_prof.dta", replace

*--- age at promotion to associate professor

use "$data_path/grants_researcher_year.dta", clear

gen age_assoc_prof = assoc_prof_year - author_birthyr
keep if age_assoc_prof < .

sort author_numid2
by author_numid2: gen count = _n
keep if count == 1
drop count

collapse (mean) age_assoc_prof if female < ., by(assoc_prof_year female)
rename assoc_prof_year year

*--- combine datasets

merge 1:1 year female using "$temp_data_path/age_promotion_full_prof.dta"
drop _merge

keep if year >= 2001

*--- graph

twoway (connected age_full_prof year if female == 1, color(gs0) msymbol(O) lpattern(solid))  ///
    (connected age_full_prof year if female == 0, color(gs10) msymbol(Th) lpattern(dash)) ///
	(connected age_assoc_prof year if female == 1, color(blue%80) msymbol(O) lpattern(solid))  ///
    (connected age_assoc_prof year if female == 0, color(blue%30) msymbol(Th) lpattern(dash)), ///
    legend(order(1 "Promotion to full professor: female" 2 "Promotion to full professor: male" ///
		3 "Promotion to associate professor: female" 4 "Promotion to associate professor: male") ///
		pos(6) cols(2) region(lstyle(solid)) size(3)) ///
    xlabel(2001(5)2021,labsize(4)) ///
	ylabel(30(10)50,labsize(4)) ///
    xline(2010.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Year", margin(small) size(4)) ///
	ytitle("Age at promotion", size(4))	

graph export "$figure_path/Fig_age_promotion_by_gender.eps", replace
graph export "$figure_path/Fig_age_promotion_by_gender.pdf", replace 


/* ---------------------------------------------------------------- */
/*                young scientist grants: cohorts [1966, 1975]                */
/*       pre-associate prof vs. pre-full or pre-assistant prof      */
/* ---------------------------------------------------------------- */
/*

* Note to Feng - commenting these out, because I think grouping assistant with full is hard to defend.
use "$temp_data_path/grants_researcher_year_for_discussion.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 pre_assoc_prof == 1
local cond2_2 pre_assoc_prof == 0
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
	legend(order(2 "Associate professor" 4 "Assistant/Full professor") pos(6) region(lstyle(solid)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.05(0.05)0.1,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Likelihood of acquiring a young scientist grant", size(4))

graph export "$figure_path/Fig_young_grant_1966_1975_rank2_het.eps", replace
graph export "$figure_path/Fig_young_grant_1966_1975_rank2_het.pdf", replace	


/* ---------------------------------------------------------------- */
/*                young scientist grants: cohorts [1966, 1975]                */
/*    pre-assistant prof vs. pre-associate prof vs. pre-full prof   */
/* ---------------------------------------------------------------- */

use "$temp_data_path/grants_researcher_year_for_discussion.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 pre_assoc_prof == 1
local cond2_2 pre_full_prof == 1
local cond2_3 pre_assoc_prof == 0 & pre_full_prof == 0
local controls treat_female i.female#i.year i.treated#i.year

reghdfe youth_grant_ry `treatlist1' `controls' if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant1
reghdfe youth_grant_ry `treatlist1' `controls' if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant2
reghdfe youth_grant_ry `treatlist1' `controls' if `cond1' & `cond2_3', absorb(author_numid2 year) vce(cluster author_numid2) 
est store grant3

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.15)) ///
	(grant2, msymbol(Th) mcolor(gs6) lcolor(gs6) ciopts(recast(rcap) lcolor(gs6) lpattern(dash)) offset(0)) ///
	(grant3, msymbol(Sh) mcolor(gs12) lcolor(gs12) ciopts(recast(rcap) lcolor(gs12) lpattern(solid)) offset(0.15)), ///	
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="-10" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="-5" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Assoc prof." 4 "Full prof." 6 "Asst prof.") pos(6) region(lstyle(solid)) cols(3) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.05(0.05)0.1,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Likelihood of acquiring a young scientist grant", size(4))

graph export "$figure_path/Fig_young_grant_1966_1975_rank3_het.eps", replace
graph export "$figure_path/Fig_young_grant_1966_1975_rank3_het.pdf", replace
*/

/* ---------------------------------------------------------------- */
/*                young scientist grants: cohorts [1966, 1975]                */
/*       pre-associate prof vs. pre-full or pre-assistant prof      */
/*                    limit to 985-project univ.                    */
/* ---------------------------------------------------------------- */

use "$temp_data_path/grants_researcher_year_for_discussion.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & wkunit_type == 1
local cond2_1 pre_assoc_prof == 1
local cond2_2 pre_assoc_prof == 0
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
	legend(order(2 "Assoc prof." 4 "Asst/Full prof.") pos(6) region(lstyle(solid)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.05(0.05)0.1,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Won the young scientist grant", size(4))

graph export "$figure_path/Fig_young_grant_1966_1975_rank2_het_985.eps", replace
graph export "$figure_path/Fig_young_grant_1966_1975_rank2_het_985.pdf", replace

/*

/* ---------------------------------------------------------------- */
/*                young scientist grants: cohorts [1966, 1975]                */
/*       pre-associate prof vs. pre-full or pre-assistant prof      */
/*                    limit to 211-project univ.                    */
/* ---------------------------------------------------------------- */

use "$temp_data_path/grants_researcher_year_for_discussion.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & (wkunit_type == 1 | wkunit_type == 2)
local cond2_1 pre_assoc_prof == 1
local cond2_2 pre_assoc_prof == 0
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
	legend(order(2 "Assoc prof." 4 "Asst/Full prof.") pos(6) region(lstyle(solid)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.05(0.05)0.1,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Likelihood of acquiring a young scientist grant", size(4))

graph export "$figure_path/Fig_young_grant_1966_1975_rank2_het_211.eps", replace
graph export "$figure_path/Fig_young_grant_1966_1975_rank2_het_211.pdf", replace


