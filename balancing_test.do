/*

balancing tests: pre-policy characteristics 

* Edited by Alex 2025-06-27. Works.

*/

/* ----------------------------------------------------------- */
/*        balancing test of pre-policy characteristics         */
/*                 female cohorts [1966, 1975]                 */
/* ----------------------------------------------------------- */
* home institution type, field type, number of youth grants until 2010, number of general grants until 2010
* academic rank in 2010, average annual number of pubs until 2010, average annual number of citations until 2010

use "$data_path/pre_policy_char_66_75.dta", clear

local varlist nsfc_field0_1 nsfc_field0_2 nsfc_field0_3 nsfc_field0_4 nsfc_field0_5 nsfc_field0_6 ///
	nsfc_field0_7 nsfc_field0_8 wkunit_type1 wkunit_type2 wkunit_type3 wkunit_type4 wkunit_type5  ///
    pre_assoc_prof pre_full_prof pre_youth_grant pre_gen_grant top_scholar1 top_scholar3
local cond female == 1

foreach var in `varlist' {
    
    preserve
    
    reg `var' cohorts_1971 if `cond'    
    gen outcome = "`var'"
    gen coef_est = r(table)[1,1]
    gen se_est = r(table)[2,1]
    
    sum `var' if `cond'
    gen scale = 1/r(sd)
    
    keep outcome coef_est se_est scale
    keep if _n == 1
    save "$temp_data_path/est_`var'.dta", replace
    
    restore
    
}

* append datasets

clear

local varlist nsfc_field0_1 nsfc_field0_2 nsfc_field0_3 nsfc_field0_4 nsfc_field0_5 nsfc_field0_6 ///
	nsfc_field0_7 nsfc_field0_8 wkunit_type1 wkunit_type2 wkunit_type3 wkunit_type4 wkunit_type5  ///
    pre_assoc_prof pre_full_prof pre_youth_grant pre_gen_grant top_scholar1 top_scholar3

foreach var in `varlist' {    

    append using "$temp_data_path/est_`var'.dta"
    
}

replace coef_est = coef_est * scale
replace se_est = se_est * scale
gen ci_lower = coef_est - 1.96 * se_est
gen ci_upper = coef_est + 1.96 * se_est

gen group = 1 if _n >= 14 & _n <= 19
replace group = 2 if _n >= 9 & _n <= 13
replace group = 3 if _n >= 1 & _n <= 8

gen n = _N + group - _n

label define n_label 1 "Has published" 2 "Has published in a top journal" 3 "Number of general grants" 4 "Young scientist grant" ///
    5 "Full professor" 6 "Associate professor" 8 "Other institutions" 9 "Chinese academy of sciences"  10 "Other universities" 11 "Project 211 universities" ///
    12 "Project 985 universities" 14 "Medicine" 15 "Economics and management" 16 "Computer science" 17 "Engineering" ///
	18 "Earth" 19 "Life sciences" 20 "Chemistry" 21 "Math and physics"
label values n n_label

* graph

twoway (scatter n coef_est if group == 1, msymbol(Th) color(gs0)) ///
    (rcap ci_lower ci_upper n if group == 1, color(gs0) horizontal) ///
    (scatter n coef_est if group == 2, msymbol(O) color(gs10)) ///
    (rcap ci_lower ci_upper n if group == 2, color(gs10) horizontal) ///
    (scatter n coef_est if group == 3, msymbol(dh) color(gs0)) ///
    (rcap ci_lower ci_upper n if group == 3, color(gs0) horizontal), ///
    xline(0, lcolor(red%60) lpattern(solid)) ///
    xlabel(-1(0.5)1, labsize(4)) ///
    xtitle("Female cohorts [1971, 1975] vs. [1966, 1970]", size(4)) ///
    ytitle("") ///
    ylabel(1 2 3 4 5 6 8 9 10 11 12 14 15 16 17 18 19 20 21, valuelabel) ///    
    legend(off)

graph export "$figure_path/Fig_compare_char_female_66_75.eps", replace
graph export "$figure_path/Fig_compare_char_female_66_75.pdf", replace   


/* ----------------------------------------------------------- */
/*        balancing test of pre-policy characteristics         */
/*                   male cohorts [1966, 1975]                 */
/* ----------------------------------------------------------- */

use "$data_path/pre_policy_char_66_75.dta", clear

local varlist nsfc_field0_1 nsfc_field0_2 nsfc_field0_3 nsfc_field0_4 nsfc_field0_5 nsfc_field0_6 ///
	nsfc_field0_7 nsfc_field0_8 wkunit_type1 wkunit_type2 wkunit_type3 wkunit_type4 wkunit_type5  ///
    pre_assoc_prof pre_full_prof pre_youth_grant pre_gen_grant top_scholar1 top_scholar3
local cond female == 0

foreach var in `varlist' {
    
    preserve
    
    reg `var' cohorts_1971 if `cond'    
    gen outcome = "`var'"
    gen coef_est = r(table)[1,1]
    gen se_est = r(table)[2,1]
    
    sum `var' if `cond'
    gen scale = 1/r(sd)
    
    keep outcome coef_est se_est scale
    keep if _n == 1
    save "$temp_data_path/est_`var'.dta", replace
    
    restore
    
}

* append datasets

clear

local varlist nsfc_field0_1 nsfc_field0_2 nsfc_field0_3 nsfc_field0_4 nsfc_field0_5 nsfc_field0_6 ///
	nsfc_field0_7 nsfc_field0_8 wkunit_type1 wkunit_type2 wkunit_type3 wkunit_type4 wkunit_type5  ///
    pre_assoc_prof pre_full_prof pre_youth_grant pre_gen_grant top_scholar1 top_scholar3

foreach var in `varlist' {    

    append using "$temp_data_path/est_`var'.dta"
    
}

replace coef_est = coef_est * scale
replace se_est = se_est * scale
gen ci_lower = coef_est - 1.96 * se_est
gen ci_upper = coef_est + 1.96 * se_est

gen group = 1 if _n >= 14 & _n <= 19
replace group = 2 if _n >= 9 & _n <= 13
replace group = 3 if _n >= 1 & _n <= 8

gen n = _N + group - _n

label define n_label 1 "Has published" 2 "Has published in a top journal" 3 "Number of general grants" 4 "Young scientist grant" ///
    5 "Full professor" 6 "Associate professor" 8 "Other institutions" 9 "Chinese academy of sciences"  10 "Other universities" 11 "Project 211 universities" ///
    12 "Project 985 universities" 14 "Medicine" 15 "Economics and management" 16 "Computer science" 17 "Engineering" ///
	18 "Earth" 19 "Life sciences" 20 "Chemistry" 21 "Math and physics"
label values n n_label

* graph

twoway (scatter n coef_est if group == 1, msymbol(Th) color(gs0)) ///
    (rcap ci_lower ci_upper n if group == 1, color(gs0) horizontal) ///
    (scatter n coef_est if group == 2, msymbol(O) color(gs10)) ///
    (rcap ci_lower ci_upper n if group == 2, color(gs10) horizontal) ///
    (scatter n coef_est if group == 3, msymbol(dh) color(gs0)) ///
    (rcap ci_lower ci_upper n if group == 3, color(gs0) horizontal), ///
    xline(0, lcolor(red%60) lpattern(solid)) ///
    xlabel(-1(0.5)1, labsize(4)) ///
    xtitle("Male cohorts [1971, 1975] vs. [1966, 1970]", size(4)) ///
    ytitle("") ///
    ylabel(1 2 3 4 5 6 8 9 10 11 12 14 15 16 17 18 19 20 21, valuelabel) ///    
    legend(off)

graph export "$figure_path/Fig_compare_char_male_66_75.eps", replace
graph export "$figure_path/Fig_compare_char_male_66_75.pdf", replace  


/* ----------------------------------------------------------- */
/*        balancing test of pre-policy characteristics         */
/*                 female cohorts [1970, 1971]                 */
/* ----------------------------------------------------------- */

use "$data_path/pre_policy_char_66_75.dta", clear

local varlist nsfc_field0_1 nsfc_field0_2 nsfc_field0_3 nsfc_field0_4 nsfc_field0_5 nsfc_field0_6 ///
	nsfc_field0_7 nsfc_field0_8 wkunit_type1 wkunit_type2 wkunit_type3 wkunit_type4 wkunit_type5  ///
    pre_assoc_prof pre_full_prof pre_youth_grant pre_gen_grant top_scholar1 top_scholar3
local cond female == 1 & author_birthyr >= 1970 & author_birthyr <= 1971

foreach var in `varlist' {
    
    preserve
    
    reg `var' cohorts_1971 if `cond'    
    gen outcome = "`var'"
    gen coef_est = r(table)[1,1]
    gen se_est = r(table)[2,1]
    
    sum `var' if `cond'
    gen scale = 1/r(sd)
    
    keep outcome coef_est se_est scale
    keep if _n == 1
    save "$temp_data_path/est_`var'.dta", replace
    
    restore
    
}

* append datasets

clear

local varlist nsfc_field0_1 nsfc_field0_2 nsfc_field0_3 nsfc_field0_4 nsfc_field0_5 nsfc_field0_6 ///
	nsfc_field0_7 nsfc_field0_8 wkunit_type1 wkunit_type2 wkunit_type3 wkunit_type4 wkunit_type5  ///
    pre_assoc_prof pre_full_prof pre_youth_grant pre_gen_grant top_scholar1 top_scholar3

foreach var in `varlist' {    

    append using "$temp_data_path/est_`var'.dta"
    
}

replace coef_est = coef_est * scale
replace se_est = se_est * scale
gen ci_lower = coef_est - 1.96 * se_est
gen ci_upper = coef_est + 1.96 * se_est

gen group = 1 if _n >= 14 & _n <= 19
replace group = 2 if _n >= 9 & _n <= 13
replace group = 3 if _n >= 1 & _n <= 8

gen n = _N + group - _n

label define n_label 1 "Has published" 2 "Has published in a top journal" 3 "Number of general grants" 4 "Young scientist grant" ///
    5 "Full professor" 6 "Associate professor" 8 "Other institutions" 9 "Chinese academy of sciences"  10 "Other universities" 11 "Project 211 universities" ///
    12 "Project 985 universities" 14 "Medicine" 15 "Economics and management" 16 "Computer science" 17 "Engineering" ///
	18 "Earth" 19 "Life sciences" 20 "Chemistry" 21 "Math and physics"
label values n n_label

* graph

twoway (scatter n coef_est if group == 1, msymbol(Th) color(gs0)) ///
    (rcap ci_lower ci_upper n if group == 1, color(gs0) horizontal) ///
    (scatter n coef_est if group == 2, msymbol(O) color(gs10)) ///
    (rcap ci_lower ci_upper n if group == 2, color(gs10) horizontal) ///
    (scatter n coef_est if group == 3, msymbol(dh) color(gs0)) ///
    (rcap ci_lower ci_upper n if group == 3, color(gs0) horizontal), ///
    xline(0, lcolor(red%60) lpattern(solid)) ///
    xlabel(-1(0.5)1, labsize(4)) ///
    xtitle("Female cohorts 1971 vs. 1970", size(4)) ///
    ytitle("") ///
    ylabel(1 2 3 4 5 6 8 9 10 11 12 14 15 16 17 18 19 20 21, valuelabel) ///    
    legend(off)

graph export "$figure_path/Fig_compare_char_female_70_71.eps", replace
graph export "$figure_path/Fig_compare_char_female_70_71.pdf", replace  


/* -------------------------------------------------------- */
/*          Table: summary statistics: [1966, 1975]         */
/* -------------------------------------------------------- */

use "$data_path/pre_policy_char_66_75.dta", clear

gen young = 0
replace young = 1 if author_birthyr >= 1971

gen male = 1 - female  // for later loops

local varlist nsfc_field0_1 nsfc_field0_2 nsfc_field0_3 nsfc_field0_4 nsfc_field0_5 nsfc_field0_6 ///
	nsfc_field0_7 nsfc_field0_8 wkunit_type1 wkunit_type2 wkunit_type3 wkunit_type4 wkunit_type5  ///
    pre_assoc_prof pre_full_prof pre_youth_grant pre_gen_grant top_scholar1 top_scholar3
	
local varlist1 nsfc_field0_1 nsfc_field0_2 nsfc_field0_3 nsfc_field0_4 nsfc_field0_5 nsfc_field0_6 nsfc_field0_7 nsfc_field0_8 
local varlist2 wkunit_type1 wkunit_type2 wkunit_type3 wkunit_type4 wkunit_type5
local varlist3 pre_assoc_prof pre_full_prof pre_youth_grant pre_gen_grant top_scholar1 top_scholar3
	
forvalues i = 0/1 { // older vs. younger cohorts
	foreach var in `varlist' {
		
		ttest `var' if male == `i', by(young)
		
		local mean1_`var'_`i' = string(r(mu_1),"%04.3f")  // group mean: older cohorts
		local mean2_`var'_`i' = string(r(mu_2),"%04.3f")  // group mean: younger cohorts
		local diff_`var'_`i' = string(r(mu_2)-r(mu_1),"%04.3f")  // group diff
		local pval_`var'_`i' = r(p)  // p value associated with group diff
		
		* Generating stars for significance
		if `pval_`var'_`i'' <= 0.1 local st_`var'_`i' = "*"
		if `pval_`var'_`i'' <= 0.05 local st_`var'_`i' = "**"
		if `pval_`var'_`i'' <= 0.01 local st_`var'_`i' = "***"		
		
	}	
}	
	
	
* no. of obs
forvalues i = 0/1 {
	forvalues j = 0/1 {
		sum author_birthyr if female == `i' & young == `j'
		local n_`i'_`j' = r(N)
	}
}

*====== tex setting

local tex_nsfc_field0_1 "\quad Math and physics"
local tex_nsfc_field0_2 "\quad Chemistry"
local tex_nsfc_field0_3 "\quad Life sciences"
local tex_nsfc_field0_4 "\quad Earth"
local tex_nsfc_field0_5 "\quad Engineering"
local tex_nsfc_field0_6 "\quad Computer science"
local tex_nsfc_field0_7 "\quad Economics and management"
local tex_nsfc_field0_8 "\quad Medicine"
local tex_wkunit_type1 "\quad Project 985 universities"
local tex_wkunit_type2 "\quad Project 211 universities"
local tex_wkunit_type3 "\quad Other universities"
local tex_wkunit_type4 "\quad Chinese academy of sciences"
local tex_wkunit_type5 "\quad Other institutions"
local tex_pre_assoc_prof "\quad Associate professor"
local tex_pre_full_prof "\quad Full professor"
local tex_pre_youth_grant "\quad Won young scientist grant"
local tex_pre_gen_grant "\quad Number of general grants"
local tex_top_scholar1 "\quad Has published in a top journal"
local tex_top_scholar3 "\quad Has published in a journal"
local tex_obs "\textit{N}"

foreach var in `varlist' {
	forvalues i = 0/1 {
		
		local tex_`var' = "`tex_`var'' & `mean2_`var'_`i'' & `mean1_`var'_`i'' & `diff_`var'_`i''`st_`var'_`i''"			
	
	}	
	di "`tex_`var''"	
}

local tex_obs = "`tex_obs' & `n_1_1' & `n_1_0' & & `n_0_1' & `n_0_0' & "


*====== generating the table

texdoc init "$table_path/Tab_summary_statistics.tex", replace force

tex \begin{tabular}{lcccccc}
tex \hline \hline
tex & \multicolumn{3}{c}{Female} & \multicolumn{3}{c}{Male}
tex & \cmidrule(lr){2-4} \cmidrule(lr){5-7}
tex & Younger & Older & Difference & Younger & Older & Difference \\
tex & (1) & (2) & (1)-(2) & (3) & (4) & (3)-(4) \\
tex \hline
tex & & & & & & \\
tex \textbf{Field} & & & & & & \\
foreach var in `varlist1' {
	tex `tex_`var'' \\
}
tex & & & & & & \\
tex \textbf{Home institution} & & & & & & \\
foreach var in `varlist2' {
	tex `tex_`var'' \\
}
tex & & & & & & \\
tex \textbf{Pre-policy characteristics} & & & & & & \\
foreach var in `varlist3' {
	tex `tex_`var'' \\
}
tex & & & & & & \\
tex `tex_obs' \\
tex & & & & & & \\
tex \hline \hline
tex \end{tabular}

texdoc close


