/*

This code is for the policy effect on likelihood of obtaining the NSFC young scientist grant at the cohort level

*/

*#########################################################
*#                                                       #
*#                   data preparation                    #
*#                                                       #
*#########################################################

use "$data_path/author_wkunit_psInfo_grant.dta", clear // source: "prep_grant.do"

*--- treatment-related variables

gen post = 0
replace post = 1 if author_birthyr >= 1971

gen treat_post = female * post

// gen ever_grant = 0
// replace ever_grant = 1 if youth_grant == 1 | gen_grant == 1

keep if author_birthyr >= 1961 & author_birthyr <= 1991 // restrict the analysis sample to cohorts [1961, 1991]

* new variables: dummies for years until treatment

gen yr_diff = author_birthyr - 1971 

gen yearsuntil = yr_diff if female == 1

forval i = 1/10 {
	gen years_n`i' = 0
	replace years_n`i' = 1 if yearsuntil == - `i'
}

forval i = 0/20 {
	gen years_p`i' = 0
	replace years_p`i' = 1 if yearsuntil == `i'
}

gen year_cutoff = 0  // for graphing the event study estimates

*--- pre-policy productivity categories: only for cohorts 1966-1975

merge 1:1 author_numid2 using "$temp_data_path/top_scholar_66_75.dta" // source: "prep_pub.do"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       289,256
        from master                   288,877  (_merge==1)
        from using                        379  (_merge==2)

    Matched                            52,170  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2
drop _merge

save "$data_path/grants_researcher_cohort_61_91.dta", replace


*#########################################################
*#                                                       #
*#                  empirical analysis                   #
*#                                                       #
*#########################################################

/* ----------------------------------- */
/*       Event study estimates:        */
/*            main results             */
/*          cohorts 1961-1981          */
/* ----------------------------------- */
* only for reference

use "$data_path/grants_researcher_cohort_61_91.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1961 & author_birthyr <= 1981

reghdfe youth_grant `treatlist1' female if `cond1', absorb(author_birthyr wkunit_nsfcid) vce(cluster wkunit_nsfcid) 
est store grant1
// reghdfe gen_grant `treatlist1' female if `cond1', absorb(author_birthyr wkunit_nsfcid) vce(cluster wkunit_nsfcid) 
// est store grant2
// reghdfe ever_grant `treatlist1' female if `cond1', absorb(author_birthyr wkunit_nsfcid) vce(cluster wkunit_nsfcid) 
// est store grant3

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(10.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n10="1961" years_n9=" " years_n8=" " years_n7=" " years_n6=" " years_n5="1966" years_n4=" " ///
		years_n3=" " years_n2=" " year_cutoff=" " years_p0="1971" years_p1=" " years_p2=" " years_p3=" " years_p4=" " ///
		years_p5="1976" years_p6=" " years_p7=" " years_p8=" " years_p9=" " years_p10="1981")  ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.1(0.1)0.2,labsize(4)) ///
	xtitle("Cohorts", size(4)) ///
	ytitle("Won a young scientist grant", size(4))
  
graph export "$figure_path/Fig_young_grant_1961_1981_cohort.eps", replace
graph export "$figure_path/Fig_young_grant_1961_1981_cohort.pdf", replace	


/* ----------------------------------- */
/*       Event study estimates:        */
/*            main results             */
/*          cohorts 1966-1975          */
/* ----------------------------------- */

use "$data_path/grants_researcher_cohort_61_91.dta", clear

keep if  author_birthyr >= 1966 & author_birthyr <= 1975
local treatlist1 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975

reghdfe youth_grant `treatlist1' female if `cond1', absorb(author_birthyr wkunit_nsfcid) vce(cluster wkunit_nsfcid) 
est store grant1
// reghdfe gen_grant `treatlist1' female if `cond1', absorb(author_birthyr wkunit_nsfcid) vce(cluster wkunit_nsfcid) 
// est store grant2
// reghdfe ever_grant `treatlist1' female if `cond1', absorb(author_birthyr wkunit_nsfcid) vce(cluster wkunit_nsfcid) 
// est store grant3

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid))), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(5.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n5="1966" years_n4="1967" years_n3="1968" years_n2="1969" year_cutoff="1970" ///
		years_p0="1971" years_p1="1972" years_p2="1973" years_p3="1974" years_p4="1975") ///
	omitted ///
	legend(off) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.1(0.1)0.3,labsize(4)) ysc(range(-0.1 0.35)) ///
	xtitle("Birth cohort", size(4)) ///
	ytitle("Won the young scientist grant", size(4))
  
graph export "$figure_path/Fig_young_grant_1966_1975_cohort.eps", replace
graph export "$figure_path/Fig_young_grant_1966_1975_cohort.pdf", replace	


/* --------------------------------------- */
/*         Event study estimates:          */
/*  heterogeneity: yes vs. no scopus pub   */
/*            cohorts 1966-1975            */
/* --------------------------------------- */

use "$data_path/grants_researcher_cohort_61_91.dta", clear

local treatlist1 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar3 == 1
local cond2_2 top_scholar3 == 0 

reghdfe youth_grant `treatlist1' female if `cond1' & `cond2_1', absorb(author_birthyr wkunit_nsfcid) vce(cluster wkunit_nsfcid) 
est store grant1
reghdfe youth_grant `treatlist1' female if `cond1' & `cond2_2', absorb(author_birthyr wkunit_nsfcid) vce(cluster wkunit_nsfcid) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(5.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n5="1966" years_n4="1967" years_n3="1968" years_n2="1969" year_cutoff="1970" ///
		years_p0="1971" years_p1="1972" years_p2="1973" years_p3="1974" years_p4="1975") ///
	omitted ///
	legend(order(2 "Has publication pre-policy" 4 "Others") pos(6) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.1(0.1)0.3,labsize(4)) ysc(range(-0.1 0.35)) ///
	xtitle("Birth cohort", size(4)) ///
	ytitle("Won the young scientist grant", size(4))
  
graph export "$figure_path/Fig_young_grant_1966_1975_cohort_het1.eps", replace
graph export "$figure_path/Fig_young_grant_1966_1975_cohort_het1.pdf", replace	


/* --------------------------------------- */
/*         Event study estimates:          */
/*    heterogeneity: yes vs. no top pub    */
/*            cohorts 1966-1975            */
/* --------------------------------------- */

use "$data_path/grants_researcher_cohort_61_91.dta", clear

local treatlist1 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar1 == 1
local cond2_2 top_scholar1 == 0 

reghdfe youth_grant `treatlist1' female if `cond1' & `cond2_1', absorb(author_birthyr wkunit_nsfcid) vce(cluster wkunit_nsfcid) 
est store grant1
reghdfe youth_grant `treatlist1' female if `cond1' & `cond2_2', absorb(author_birthyr wkunit_nsfcid) vce(cluster wkunit_nsfcid) 
est store grant2

coefplot (grant1, msymbol(O) mcolor(gs0) lcolor(gs0) ciopts(recast(rcap) lcolor(gs0) lpattern(solid)) offset(-0.1)) ///
	(grant2, msymbol(Th) mcolor(gs8) lcolor(gs8) ciopts(recast(rcap) lcolor(gs8) lpattern(dash)) offset(0.1)), ///
	keep(`treatlist1') ///
	vertical ///
	yline(0, lcolor(red%50)) ///
	xline(5.5, lpattern(solid) lcolor(blue%50)) ///	
	coeflabels(years_n5="1966" years_n4="1967" years_n3="1968" years_n2="1969" year_cutoff="1970" ///
		years_p0="1971" years_p1="1972" years_p2="1973" years_p3="1974" years_p4="1975") ///
	omitted ///
	legend(order(2 "Has top publication pre-policy" 4 "Others") pos(6) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.1(0.1)0.3,labsize(4)) ysc(range(-0.1 0.35)) ///
	xtitle("Birth cohort", size(4)) ///
	ytitle("Won the young scientist grant", size(4))
  
graph export "$figure_path/Fig_young_grant_1966_1975_cohort_het2.eps", replace
graph export "$figure_path/Fig_young_grant_1966_1975_cohort_het2.pdf", replace	


/* --------------------------------------- */
/*                  Table:                 */
/*            cohorts 1966-1975            */
/* --------------------------------------- */

use "$data_path/grants_researcher_cohort_61_91.dta", clear

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2 author_birthyr >= 1966 & author_birthyr <= 1975 & top_scholar3 == 1
local cond3 author_birthyr >= 1966 & author_birthyr <= 1975 & top_scholar3 == 0 
local cond4 author_birthyr >= 1966 & author_birthyr <= 1975 & top_scholar1 == 1
local cond5 author_birthyr >= 1966 & author_birthyr <= 1975 & top_scholar1 == 0 

forvalues i = 1/5 {
	
	reghdfe youth_grant treat_post female if `cond`i'', absorb(author_birthyr wkunit_nsfcid) vce(cluster wkunit_nsfcid)  
	
	* Saving the parameter estimates
    local te_`i' = _b[treat_post]
    local se_`i' = _se[treat_post]
	
    * Generating t-stats
    local tstat_`i' = abs(_b[treat_post]/_se[treat_post])		

    * no of obs
    local n_`i': di %9.0fc e(N)	
	
    * R-sq
    local rsq_`i': di %9.3f e(r2)	
	
	* Outcome mean
	sum youth_grant if `cond`i''
	local mean_`i': di %9.4f r(mean)	
	
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

texdoc init "$table_path/Tab_youth_grants_cohort.tex", replace force

tex \begin{tabular}{lccccc}
tex \hline \hline
tex & \multicolumn{1}{c}{} & \multicolumn{2}{c}{Published in} & \multicolumn{2}{c}{Published in} \\
tex & \multicolumn{1}{c}{} & \multicolumn{2}{c}{any journal} & \multicolumn{2}{c}{top journal} \\
tex & \multicolumn{1}{c}{} & \multicolumn{2}{c}{prior to policy} & \multicolumn{2}{c}{prior to policy} 
tex & \cmidrule(lr){3-4} \cmidrule(lr){5-6}
tex & (1) & (2) & (3) & (4) & (5) \\
tex & Full sample & Yes & No & Yes & No \\
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

