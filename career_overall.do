/*

career outcomes: overall effects

* Edited by Alex 2025-06-27.

*/

/* ---------------------------------------------------- */
/*           promotion: cohorts [1966, 1975]            */
/*                  sample selection                    */
/* ---------------------------------------------------- */
* a small proportion (10%) of obs have no academic position information

use "$data_path/pre_policy_char_66_75.dta", clear

local varlist female author_birthyr top_scholar3 pre_youth_grant pre_gen_grant i.nsfc_field0 i.wkunit_type

reg rank_sample `varlist', r



/* ---------------------------------------------------- */
/*           promotion: cohorts [1966, 1975]            */
/*                  period: [-5, 10]                    */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & yr_diff >= -5
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
	xline(5.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n5="-5" years_n4=" " years_n3=" " years_n2=" " year_cutoff=" " ///
		years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Promoted to associate" 4 "Promoted to full") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.04(0.02)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted", size(4))

graph export "$figure_path/Fig_promotion_1966_1975.eps", replace
graph export "$figure_path/Fig_promotion_1966_1975.pdf", replace


/* ---------------------------------------------------- */
/*           promotion: cohorts [1966, 1975]            */
/*                 period: [-10, 10]                    */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
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
	legend(order(2 "Promoted to associate" 4 "Promoted to full") pos(6) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.04(0.02)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted", size(4))

graph export "$figure_path/Fig_promotion_1966_1975_20y.eps", replace
graph export "$figure_path/Fig_promotion_1966_1975_20y.pdf", replace	


/* ---------------------------------------------------- */
/*      promotion: cohorts [1966, 1975] + [-5, 10]      */
/*   limiting to the sample recorded in CNKI & NSFC     */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & yr_diff >= -5 & nsfc_record == 1
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
	xline(5.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n5="-5" years_n4=" " years_n3=" " years_n2=" " year_cutoff=" " ///
		years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Promoted to associate" 4 "Promoted to full") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.04(0.02)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted", size(4))

graph export "$figure_path/Fig_promotion_1966_1975_CNKI_NSFC.eps", replace
graph export "$figure_path/Fig_promotion_1966_1975_CNKI_NSFC.pdf", replace


/* ---------------------------------------------------- */
/*    promotion: cohorts [1966, 1975] + [-10, 10]       */
/*   limiting to the sample recorded in CNKI & NSFC     */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & nsfc_record == 1
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
	legend(order(2 "Promoted to associate" 4 "Promoted to full") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.04(0.02)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Was promoted", size(4))

graph export "$figure_path/Fig_promotion_1966_1975_20y_CNKI_NSFC.eps", replace
graph export "$figure_path/Fig_promotion_1966_1975_20y_CNKI_NSFC.pdf", replace


/* ----------------------------------------------------------- */
/*           promotion: female cohorts [1970, 1971]            */
/* ----------------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1970 & author_birthyr <= 1971 & female == 1 & yr_diff >= -5
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
	xline(5.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n5="-5" years_n4=" " years_n3=" " years_n2=" " year_cutoff=" " ///
		years_p0="0" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="5" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="10") ///
	omitted ///
	legend(order(2 "Promoted to associate" 4 "Promoted to full") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.04(0.02)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)") ///
	ytitle("Was promoted")

graph export "$figure_path/Fig_promotion_female_1970_1971.eps", replace
graph export "$figure_path/Fig_promotion_female_1970_1971.pdf", replace	


/* ---------------------------------------------------- */
/*           promotion: cohorts [1966, 1975]            */
/*      associate professor based on calculation        */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & yr_diff >= -5
local controls treat_female i.female#i.year i.treated#i.year

reghdfe assoc_prof2 `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	xlabel(,labsize(4)) ///
	ylabel(-0.04(0.02)0.04,labsize(4)) ///
	xtitle("Years relative to policy start (2011)") ///
	ytitle("Promoted to associate professor")

graph export "$figure_path/Fig_promotion_assoc_prof2_1966_1975.eps", replace
graph export "$figure_path/Fig_promotion_assoc_prof2_1966_1975.pdf", replace


/* ---------------------------------------------------- */
/*   associate + full professor: cohorts [1966, 1975]   */
/*                        table                         */
/*                      [-5, 10]                       */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & yr_diff >= -5
local cond2 `cond1' & (nsfc_field0 == 2 | nsfc_field0 == 3 | nsfc_field0 == 8) 
local cond3 `cond1' & (nsfc_field0 == 1 | nsfc_field0 == 4 | nsfc_field0 == 5 | nsfc_field0 == 6)
local cond4 `cond1' & top_scholar3 == 1
local cond5 `cond1' & top_scholar3 == 0 
local cond6 `cond1' & (wkunit_type == 1 | wkunit_type == 2) 
local cond7 `cond1' & wkunit_type == 4 
local controls treat_female treat_post post_female 

local varlist assoc_prof full_prof
foreach i in `varlist' { // outcome variables
	forvalues j = 1/7 { // samples
		
		reghdfe `i' treat_female_post `controls' if `cond`j'', absorb(author_numid2 year) vce(cluster author_numid2) 
		
		* Saving the parameter estimates
		local te_`i'_`j' = _b[treat_female_post]
		local se_`i'_`j' = _se[treat_female_post]
		
		* Generating t-stats
		local tstat_`i'_`j' = abs(_b[treat_female_post]/_se[treat_female_post])		

		* no of obs
		local n_`i'_`j': di %9.0fc e(N)	
		
		* R-sq
		local rsq_`i'_`j': di %9.3f e(r2)	
		
		* Outcome mean
		sum `i' if `cond`j''
		local mean_`i'_`j': di %9.3f r(mean)	
		
	}
}

foreach i in `varlist' { // outcome variables
	forvalues j = 1/7 { // samples
	
		* Generating stars for significance
		if `tstat_`i'_`j'' >= 1.64 local st_`i'_`j' = "*"
		if `tstat_`i'_`j'' >= 1.96 local st_`i'_`j' = "**"
		if `tstat_`i'_`j'' >= 2.33 local st_`i'_`j' = "***"
		
		* Formatting the parameters (making them the same number of significant figures and pretty for the table)
		local te_`i'_`j': di %9.3f `te_`i'_`j''
		local se_`i'_`j': di %9.3f `se_`i'_`j''
		
		* Dropping the hanging space that this code generates so I can use parentheses around the parameter without it appearing like "(x.xxx )"
		local se_`i'_`j' = subinstr("`se_`i'_`j''"," ","",.)			
		
	}	
}

foreach i in `varlist' { // outcome variables

	local tex_te_`i' "$\beta_{1}$: policy effect"
	local tex_se_`i' ""
	local tex_mean_`i' "\textit{Outcome mean}"
	local tex_obs_`i' "\textit{N}"

}

foreach i in `varlist' { // outcome variables
	forvalues j = 1/7 {
		
		local tex_te_`i' = "`tex_te_`i'' & `te_`i'_`j''`st_`i'_`j''"
		local tex_se_`i' = "`tex_se_`i'' & (`se_`i'_`j'')"
		local tex_mean_`i' = "`tex_mean_`i'' & `mean_`i'_`j''"
		local tex_obs_`i' = "`tex_obs_`i'' & `n_`i'_`j''"	
		
	}
}

texdoc init "$table_path/Tab_promotion_assoc_full_prof.tex", replace force

tex \begin{tabular}{lccccccc}
tex \hline \hline
tex & \multicolumn{1}{c}{Full} & \multicolumn{2}{c}{Proportion female} & \multicolumn{2}{c}{Baseline productivity} & \multicolumn{2}{c}{Prestige of home} \\
tex & \multicolumn{1}{c}{sample} & \multicolumn{2}{c}{in field} & \multicolumn{2}{c}{of scientist} & \multicolumn{2}{c}{institution}
tex & \cmidrule(lr){3-4} \cmidrule(lr){5-6} \cmidrule(lr){7-8}
tex & & Higher & Lower & Higher & Lower & Elite & Other \\
tex \hline
tex & & & & & & & \\
tex \multicolumn{7}{c}{\textbf{Panel A: Promotion to associate professor}} \\
tex & & & & & & & \\
tex `tex_te_assoc_prof' \\
tex `tex_se_assoc_prof' \\
tex & & & & & & & \\
tex `tex_mean_assoc_prof' \\
tex `tex_obs_assoc_prof' \\
tex & & & & & & & \\
tex \hline
tex & & & & & & & \\
tex \multicolumn{7}{c}{\textbf{Panel B: Promotion to full professor}} \\
tex & & & & & & & \\
tex `tex_te_full_prof' \\
tex `tex_se_full_prof' \\
tex & & & & & & & \\
tex `tex_mean_full_prof' \\
tex `tex_obs_full_prof' \\
tex \hline \hline
tex \end{tabular}

texdoc close


/* ---------------------------------------------------- */
/*   associate + full professor: cohorts [1966, 1975]   */
/*                        table                         */
/*                      [-10, 10]                       */
/* ---------------------------------------------------- */

use "$data_path/grants_researcher_year_66_75.dta", clear

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2 `cond1' & (nsfc_field0 == 2 | nsfc_field0 == 3 | nsfc_field0 == 8) 
local cond3 `cond1' & (nsfc_field0 == 1 | nsfc_field0 == 4 | nsfc_field0 == 5 | nsfc_field0 == 6)
local cond4 `cond1' & top_scholar3 == 1
local cond5 `cond1' & top_scholar3 == 0 
local cond6 `cond1' & (wkunit_type == 1 | wkunit_type == 2) 
local cond7 `cond1' & wkunit_type == 4 
local controls treat_female treat_post post_female 

local varlist assoc_prof full_prof
foreach i in `varlist' { // outcome variables
	forvalues j = 1/7 { // samples
		
		reghdfe `i' treat_female_post `controls' if `cond`j'', absorb(author_numid2 year) vce(cluster author_numid2) 
		
		* Saving the parameter estimates
		local te_`i'_`j' = _b[treat_female_post]
		local se_`i'_`j' = _se[treat_female_post]
		
		* Generating t-stats
		local tstat_`i'_`j' = abs(_b[treat_female_post]/_se[treat_female_post])		

		* no of obs
		local n_`i'_`j': di %9.0fc e(N)	
		
		* R-sq
		local rsq_`i'_`j': di %9.3f e(r2)	
		
		* Outcome mean
		sum `i' if `cond`j''
		local mean_`i'_`j': di %9.3f r(mean)	
		
	}
}

foreach i in `varlist' { // outcome variables
	forvalues j = 1/7 { // samples
	
		* Generating stars for significance
		if `tstat_`i'_`j'' >= 1.64 local st_`i'_`j' = "*"
		if `tstat_`i'_`j'' >= 1.96 local st_`i'_`j' = "**"
		if `tstat_`i'_`j'' >= 2.33 local st_`i'_`j' = "***"
		
		* Formatting the parameters (making them the same number of significant figures and pretty for the table)
		local te_`i'_`j': di %9.3f `te_`i'_`j''
		local se_`i'_`j': di %9.3f `se_`i'_`j''
		
		* Dropping the hanging space that this code generates so I can use parentheses around the parameter without it appearing like "(x.xxx )"
		local se_`i'_`j' = subinstr("`se_`i'_`j''"," ","",.)			
		
	}	
}

foreach i in `varlist' { // outcome variables

	local tex_te_`i' "$\beta_{1}$: policy effect"
	local tex_se_`i' ""
	local tex_mean_`i' "\textit{Outcome mean}"
	local tex_obs_`i' "\textit{N}"

}

foreach i in `varlist' { // outcome variables
	forvalues j = 1/7 {
		
		local tex_te_`i' = "`tex_te_`i'' & `te_`i'_`j''`st_`i'_`j''"
		local tex_se_`i' = "`tex_se_`i'' & (`se_`i'_`j'')"
		local tex_mean_`i' = "`tex_mean_`i'' & `mean_`i'_`j''"
		local tex_obs_`i' = "`tex_obs_`i'' & `n_`i'_`j''"	
		
	}
}

texdoc init "$table_path/Tab_promotion_assoc_full_prof_20y.tex", replace force

tex \begin{tabular}{lccccccc}
tex \hline \hline
tex & \multicolumn{1}{c}{Full} & \multicolumn{2}{c}{Proportion female} & \multicolumn{2}{c}{Baseline productivity} & \multicolumn{2}{c}{Prestige of home} \\
tex & \multicolumn{1}{c}{sample} & \multicolumn{2}{c}{in field} & \multicolumn{2}{c}{of scientist} & \multicolumn{2}{c}{institution}
tex & \cmidrule(lr){3-4} \cmidrule(lr){5-6} \cmidrule(lr){7-8}
tex & & Higher & Lower & Higher & Lower & Elite & Other \\
tex \hline
tex & & & & & & & \\
tex \multicolumn{7}{c}{\textbf{Panel A: Promotion to associate professor}} \\
tex & & & & & & & \\
tex `tex_te_assoc_prof' \\
tex `tex_se_assoc_prof' \\
tex & & & & & & & \\
tex `tex_mean_assoc_prof' \\
tex `tex_obs_assoc_prof' \\
tex & & & & & & & \\
tex \hline
tex & & & & & & & \\
tex \multicolumn{7}{c}{\textbf{Panel B: Promotion to full professor}} \\
tex & & & & & & & \\
tex `tex_te_full_prof' \\
tex `tex_se_full_prof' \\
tex & & & & & & & \\
tex `tex_mean_full_prof' \\
tex `tex_obs_full_prof' \\
tex \hline \hline
tex \end{tabular}

texdoc close

/* ---------------------------------------------------- */
/*      associate professor: cohorts [1966, 1975]       */
/*                        table                         */
/* ---------------------------------------------------- */
/*
use "$data_path/grants_researcher_year_66_75.dta", clear

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & yr_diff >= -5
local cond2 `cond1' & (nsfc_field0 == 2 | nsfc_field0 == 3 | nsfc_field0 == 8) 
local cond3 `cond1' & (nsfc_field0 == 1 | nsfc_field0 == 4 | nsfc_field0 == 5 | nsfc_field0 == 6)
local cond4 `cond1' & top_scholar3 == 1
local cond5 `cond1' & top_scholar3 == 0 
local cond6 `cond1' & (wkunit_type == 1 | wkunit_type == 2) 
local cond7 `cond1' & wkunit_type == 4 
local controls treat_female treat_post post_female 

forvalues i = 1/7 {
	
	reghdfe assoc_prof treat_female_post `controls' if `cond`i'', absorb(author_numid2 year) vce(cluster author_numid2) 
	
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
	sum assoc_prof2 if `cond`i''
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


texdoc init "$table_path/Tab_promotion_assoc_prof.tex", replace force

tex \begin{tabular}{lccccccc}
tex \hline \hline
tex & \multicolumn{1}{c}{Full sample} & \multicolumn{2}{c}{Fields with female rep.} & \multicolumn{2}{c}{Scientists' productivity} & \multicolumn{2}{c}{Universities}
tex & \cmidrule(lr){3-4} \cmidrule(lr){5-6} \cmidrule(lr){7-8}
tex & & Higher & Lower & Higher & Lower & High-tier & Lower-tier \\
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
*/

/* ------------------------------------------------ */
/*         mobility: cohorts [1966, 1975]           */
/* ------------------------------------------------ */

use "$data_path/grants_researcher_year_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local controls treat_female i.female#i.year i.treated#i.year

reghdfe mig_yr `treatlist1' `controls' if `cond1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store reg1

coefplot (reg1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
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
	ylabel(-0.01(0.01)0.01,labsize(4)) ///
	xtitle("Years relative to policy start (2011)") ///
	ytitle("Changed jobs")

graph export "$figure_path/Fig_mobility_1966_1975.eps", replace
graph export "$figure_path/Fig_mobility_1966_1975.pdf", replace	

