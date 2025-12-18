/* 

This .do file generates the new table 1

* Steps: 
- Put all stuff here
- Drop the columns for hetero by field
- Try hetero by top pubs vs. not
- Report back to Feng

*/


* Youth grants


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
tex \multicolumn{6}{c}{\textbf{Panel A: Ever won the young scientist grant (person-level)}}
tex & & & & & \\
tex `tex_te' \\
tex `tex_se' \\
tex & & & & & \\
tex `tex_mean' \\
tex `tex_obs' \\
tex & & & & & \\


/*

* OLD CODE
use "$data_path/grants_researcher_year_66_75.dta", clear

collapse youth_grant_ry author_birthyr female treat_female top_scholar3 top_scholar1, by(author_numid2)

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar3 == 1
local cond3 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar3 == 0 
local cond4 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar1 == 1
local cond5 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar1 == 0 
local controls female  

forvalues i = 1/5 {
	
	reghdfe youth_grant_ry treat_female `controls' if `cond`i''
	
	* Saving the parameter estimates
    local te_`i' = _b[treat_female]
    local se_`i' = _se[treat_female]
	
    * Generating t-stats
    local tstat_`i' = abs(_b[treat_female]/_se[treat_female])		

    * no of obs
    local n_`i': di %9.0fc e(N)	
	
    * R-sq
    local rsq_`i': di %9.3f e(r2)	
	
	* Outcome mean
	sum youth_grant_ry if `cond`i''
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

texdoc init "$table_path/NewTable1regressionresults2het.tex", replace force

tex \begin{tabular}{lccccc}
tex \hline \hline
tex & \multicolumn{1}{c}{} & \multicolumn{2}{c}{Published in} & \multicolumn{2}{c}{Published in} \\
tex & \multicolumn{1}{c}{Full} & \multicolumn{2}{c}{any journal} & \multicolumn{2}{c}{top journal} \\
tex & \multicolumn{1}{c}{sample} & \multicolumn{2}{c}{prior to policy} & \multicolumn{2}{c}{prior to policy} 
tex & \cmidrule(lr){3-4} \cmidrule(lr){5-6} 
tex & (1)  & (2)  & (3)  & (4)  & (5) \\ 
tex & Full sample & Yes & No  & Yes & No \\
tex \hline
tex & & & & & \\
tex \multicolumn{6}{c}{Panel A: Ever Won the Young Scientist Grant}
tex & & & & & \\

tex `tex_te' \\
tex `tex_se' \\
tex & & & & & \\
tex `tex_mean' \\
tex `tex_obs' \\
tex & & & & & \\
tex \hline 
*/

* General grants

use "$data_path/grants_researcher_year_66_75.dta", clear

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar3 == 1
local cond3 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar3 == 0 
local cond4 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar1 == 1
local cond5 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar1 == 0 
local controls treat_female treat_post post_female 

forvalues i = 1/5 {
	
	reghdfe gen_grant_ry treat_female_post `controls' if `cond`i'', absorb(author_numid2 year) vce(cluster author_numid2) 
	
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
	sum gen_grant_ry if `cond`i''
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

tex & & & & & \\
tex \multicolumn{6}{c}{\textbf{Panel B: Number of General Grants Won (person-by-year-level)}}
tex & & & & & \\
tex `tex_te' \\
tex `tex_se' \\
tex & & & & & \\
tex `tex_mean' \\
tex `tex_obs' \\
tex & & & & & \\
tex \hline 


* Total funding

use "$data_path/grants_researcher_year_66_75.dta", clear

local cond1 author_birthyr >= 1966 & author_birthyr <= 1975
local cond2 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar3 == 1
local cond3 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar3 == 0 
local cond4 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar1 == 1
local cond5 (author_birthyr >= 1966 & author_birthyr <= 1975) & top_scholar1 == 0 
local controls treat_female treat_post post_female 


forvalues i = 1/5 {
	
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


tex & & & & & \\
tex \multicolumn{6}{c}{Panel C: Total amount of funding earned (person-by-year-level, unit: 10,000 CNY)}
tex & & & & & \\
tex `tex_te' \\
tex `tex_se' \\
tex & & & & & \\
tex `tex_mean' \\
tex `tex_obs' \\
tex \hline \hline
tex \end{tabular}

texdoc close
