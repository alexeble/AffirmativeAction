/*

scientific productivity: heterogeneity

* Edited by Alex 2025-06-27.

*/


/* -------------------------------------------------------- */
/*               total number of journal papers:            */
/*                    cohorts [1966, 1975]                  */
/*              high- vs. lower-ability scholars            */
/* -------------------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar3 == 1
local cond2_2 top_scholar3 == 0 
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe n_jpapers_yr `treatlist1' `controls'  if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store reg1
ppmlhdfe n_jpapers_yr `treatlist1' `controls'  if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
*ppmlhdfe n_jpapers_yr `treatlist1' `controls'  if `cond1' & `cond2_2', absorb(author_numid2 year) vce(robust) // no confidence intervals when clustering due to a small number of positive values for this subgroup
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
	legend(order(2 "High-ability scholars" 4 "Lower-ability scholars") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.4(0.2)0.4,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of publications", size(4))

graph export "$figure_path/Fig_pub_1966_1975_ability_het.eps", replace
graph export "$figure_path/Fig_pub_1966_1975_ability_het.pdf", replace	


/* -------------------------------------------------------- */
/*               total number of journal papers:            */
/*                    cohorts [1966, 1975]                  */
/*              top- vs. lower-tieir universities           */
/* -------------------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 (wkunit_type == 1 | wkunit_type == 2) 
local cond2_2 wkunit_type == 4 
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe n_jpapers_yr `treatlist1' `controls'  if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store reg1
ppmlhdfe n_jpapers_yr `treatlist1' `controls'  if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	legend(order(2 "Top-tier universities" 4 "Lower-tier universities") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.4(0.2)0.4,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of publications", size(4))

graph export "$figure_path/Fig_pub_1966_1975_rank_het.eps", replace
graph export "$figure_path/Fig_pub_1966_1975_rank_het.pdf", replace	


/* -------------------------------------------------------- */
/*             number of top 25% journal papers:            */
/*                    cohorts [1966, 1975]                  */
/*              high- vs. lower-ability scholars            */
/* -------------------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 top_scholar3 == 1
local cond2_2 top_scholar3 == 0 
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe n_jpapers25_yr `treatlist1' `controls'  if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store reg1
ppmlhdfe n_jpapers25_yr `treatlist1' `controls'  if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	legend(order(2 "High-performing scholars" 4 "Other scholars") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.4(0.2)0.4,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of top publications", size(4))

graph export "$figure_path/Fig_num_25p_top_1966_1975_ability_het.eps", replace
graph export "$figure_path/Fig_num_25p_top_1966_1975_ability_het.pdf", replace	


/* -------------------------------------------------------- */
/*             number of top 25% journal papers:            */
/*                    cohorts [1966, 1975]                  */
/*              top- vs. lower-tieir universities           */
/* -------------------------------------------------------- */

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

local treatlist1 years_n10 years_n9 years_n8 years_n7 years_n6 years_n5 years_n4 years_n3 years_n2 year_cutoff years_p0 ///
  years_p1 years_p2 years_p3 years_p4 years_p5 years_p6 years_p7 years_p8 years_p9 years_p10 
local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2_1 (wkunit_type == 1 | wkunit_type == 2) 
local cond2_2 wkunit_type == 4 
local controls treat_female i.female#i.year i.treated#i.year

ppmlhdfe n_jpapers_yr `treatlist1' `controls'  if `cond1' & `cond2_1', absorb(author_numid2 year) vce(cluster author_numid2) 
est store reg1
ppmlhdfe n_jpapers_yr `treatlist1' `controls'  if `cond1' & `cond2_2', absorb(author_numid2 year) vce(cluster author_numid2) 
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
	legend(order(2 "Elite universities" 4 "Other universities") pos(6) region(lw(0)) cols(2) symxsize(*1.5) size(4)) ///
	xlabel(,labsize(4)) ///
	ylabel(-0.4(0.2)0.4,labsize(4)) ///
	xtitle("Years relative to policy start (2011)", size(4)) ///
	ytitle("Number of top publications", size(4))

graph export "$figure_path/Fig_num_25p_top_1966_1975_rank_het.eps", replace
graph export "$figure_path/Fig_num_25p_top_1966_1975_rank_het.pdf", replace	


/* ---------------------------------------------------- */
/*          publications: cohorts [1966, 1975]          */
/*                 table: heterogeneity                 */
/* ---------------------------------------------------- */
* limit the sample to [-5, 10] to derive more conservative estimates

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

*### poisson: [-10, 10]

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & top_scholar3 == 1 
local cond2 author_birthyr >= 1966 & author_birthyr <= 1975 & top_scholar3 == 0 
local cond3 author_birthyr >= 1966 & author_birthyr <= 1975 & top_scholar1 == 1 
local cond4 author_birthyr >= 1966 & author_birthyr <= 1975 & top_scholar1 == 0 
local controls treat_female treat_post post_female 
local varlist n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jpapers25_yr n_jcite_yr /*avg_author_jcount_yr*/

forvalues j = 1/4 {
	foreach i in `varlist' {
		
		ppmlhdfe `i' treat_female_post `controls' if `cond`j'', absorb(author_numid2 year) vce(cluster author_numid2) 
		
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

forvalues j = 1/4 {
	foreach i in `varlist' {
		
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

forvalues j = 1/4 {
	
	local tex_te_`j' "$\beta_{1}$: policy effect"
	local tex_se_`j' ""
	local tex_mean_`j' "\textit{Outcome mean}"
	local tex_obs_`j' "\textit{N}"

	foreach i in `varlist' {
		
		local tex_te_`j' = "`tex_te_`j'' & `te_`i'_`j''`st_`i'_`j''"
		local tex_se_`j' = "`tex_se_`j'' & (`se_`i'_`j'')"
		local tex_mean_`j' = "`tex_mean_`j'' & `mean_`i'_`j''"
		local tex_obs_`j' = "`tex_obs_`j'' & `n_`i'_`j''"
		
	}
}

texdoc init "$table_path/Tab_pub_poisson_het.tex", replace force

tex \begin{tabular}{lccccc}
tex \hline \hline
tex & (1)  			& (2)  				& (3)  				& (4)  			& (5) \\
tex & Number of 	& Number of first- 	& Number of last- 	& Number of 	& Number \\
tex & total 		& authored 			& authored 			& top		 	& of \\
tex & publications 	& publications 		& publications 		& publications	& citations \\
tex \hline
tex & & & & & \\
tex \multicolumn{6}{l}{\textbf{Panel A:Has at Least One Indexed Publication Pre-policy}} \\
tex `tex_te_1' \\
tex `tex_se_1' \\
tex & & & & & \\
tex `tex_mean_1' \\
tex `tex_obs_1' \\
tex & & & & & \\
tex \multicolumn{6}{l}{\textbf{Panel B: No Indexed Publications Pre-Policy}} \\
tex `tex_te_2' \\
tex `tex_se_2' \\
tex & & & & & \\
tex `tex_mean_2' \\
tex `tex_obs_2' \\
tex & & & & & \\
tex \multicolumn{6}{l}{\textbf{Panel C:Has at Least One Top Publication Pre-policy}} \\
tex `tex_te_3' \\
tex `tex_se_3' \\
tex & & & & & \\
tex `tex_mean_3' \\
tex `tex_obs_3' \\
tex & & & & & \\
tex \multicolumn{6}{l}{\textbf{Panel D: No Top Publications Pre-Policy}} \\
tex `tex_te_4' \\
tex `tex_se_4' \\
tex & & & & & \\
tex `tex_mean_4' \\
tex `tex_obs_4' \\
tex & & & & & \\
tex \hline \hline
tex \end{tabular}

texdoc close


*### poisson: [-5, 10]

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975 & yr_diff >= -5 & top_scholar3 == 1 
local cond2 author_birthyr >= 1966 & author_birthyr <= 1975 & yr_diff >= -5 & top_scholar3 == 0 
local cond3 author_birthyr >= 1966 & author_birthyr <= 1975 & yr_diff >= -5 & (wkunit_type == 1 | wkunit_type == 2) 
local cond4 author_birthyr >= 1966 & author_birthyr <= 1975 & yr_diff >= -5 & wkunit_type == 4 
local controls treat_female treat_post post_female 
local varlist n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jcite_yr n_jpapers25_yr avg_author_jcount_yr

forvalues j = 1/4 {
	foreach i in `varlist' {
		
		ppmlhdfe `i' treat_female_post `controls' if `cond`j'', absorb(author_numid2 year) vce(cluster author_numid2) 
		
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

forvalues j = 1/4 {
	foreach i in `varlist' {
		
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

forvalues j = 1/4 {
	
	local tex_te_`j' "$\beta_{1}$: policy effect"
	local tex_se_`j' ""
	local tex_mean_`j' "\textit{Outcome mean}"
	local tex_obs_`j' "\textit{N}"

	foreach i in `varlist' {
		
		local tex_te_`j' = "`tex_te_`j'' & `te_`i'_`j''`st_`i'_`j''"
		local tex_se_`j' = "`tex_se_`j'' & (`se_`i'_`j'')"
		local tex_mean_`j' = "`tex_mean_`j'' & `mean_`i'_`j''"
		local tex_obs_`j' = "`tex_obs_`j'' & `n_`i'_`j''"
		
	}
}

texdoc init "$table_path/Tab_pub_poisson2_het.tex", replace force

tex \begin{tabular}{lccccc}
tex \hline \hline
tex & Number of 	& Number of first- 	& Number of last- 	& Number of 	& Number of \\
tex & total 		& authored 			& authored 			& citations 	& top \\
tex & publications 	& publications 		& publications 		& 				& publications 
tex \hline
tex & & & & & \\
tex \multicolumn{6}{c}{\textbf{Panel A: Higher-performing scholars}} \\
tex `tex_te_1' \\
tex `tex_se_1' \\
tex & & & & & \\
tex `tex_mean_1' \\
tex `tex_obs_1' \\
tex & & & & & \\
tex \multicolumn{6}{c}{\textbf{Panel B: Lower-performing scholars}} \\
tex `tex_te_2' \\
tex `tex_se_2' \\
tex & & & & & \\
tex `tex_mean_2' \\
tex `tex_obs_2' \\
tex & & & & & \\
tex \multicolumn{6}{c}{Panel C: Scholars from elite universities}} \\
tex `tex_te_3' \\
tex `tex_se_3' \\
tex & & & & & \\
tex `tex_mean_3' \\
tex `tex_obs_3' \\
tex & & & & & \\
tex \multicolumn{6}{c}{\textbf{Panel D: Scholars from other universities}} \\
tex `tex_te_4' \\
tex `tex_se_4' \\
tex & & & & & \\
tex `tex_mean_4' \\
tex `tex_obs_4' \\
tex \hline \hline
tex \end{tabular}

texdoc close

