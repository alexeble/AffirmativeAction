/*

sample representativeness: analysis sample vs. NSFC admin data

* Edited by Alex 2025-06-27. Works.

*/


/* --------------------------------------------------------------- */
/*           the CNKI scholar sample vs. analysis sample           */
/* --------------------------------------------------------------- */

*====== institution types: the CNKI scholar sample

use "$temp_data_path/author_wkunit_psInfo2_temp.dta", clear // source: "prep_grant.do"

keep if wkunit_type == 1 | wkunit_type == 2 | wkunit_type == 4 | wkunit_type == 5 | wkunit_type == 6

tab wkunit_type, gen(wkunit_type_)

collapse (mean) wkunit_type_1 wkunit_type_2 wkunit_type_3 wkunit_type_4 wkunit_type_5

gen analysis_sample = 0

save "$temp_data_path/wkunit_full_sample.dta", replace


*====== institution types: final analysis sample

use "$temp_data_path/author_wkunit_psInfo2_temp.dta", clear // source: "prep_grant.do"

keep if wkunit_type == 1 | wkunit_type == 2 | wkunit_type == 4 | wkunit_type == 5 | wkunit_type == 6
keep if author_birthyr >= 1966 & author_birthyr <= 1975

tab wkunit_type, gen(wkunit_type_)

collapse (mean) wkunit_type_1 wkunit_type_2 wkunit_type_3 wkunit_type_4 wkunit_type_5

gen analysis_sample = 1

save "$temp_data_path/wkunit_sample_6675.dta", replace


*====== fields: the CNKI scholar sample

use "$temp_data_path/author_wkunit_psInfo2_temp.dta", clear // source: "prep_grant.do"

gen nsfc_dep = nsfc_field0 if nsfc_field0 >= 1  // new var for consistence
gen one = 1 // for calculating no. of obs.
tab nsfc_dep, gen(nsfc_dep_)

collapse (mean) nsfc_dep_1 nsfc_dep_2 nsfc_dep_3 nsfc_dep_4 nsfc_dep_5 nsfc_dep_6 nsfc_dep_7 nsfc_dep_8 (sum) one

rename one n_obs
gen analysis_sample = 0

save "$temp_data_path/field_full_sample.dta", replace


*====== fields: final analysis sample

use "$temp_data_path/author_wkunit_psInfo2_temp.dta", clear // source: "prep_grant.do"

keep if author_birthyr >= 1966 & author_birthyr <= 1975

gen nsfc_dep = nsfc_field0 if nsfc_field0 >= 1  // new var for consistence
gen one = 1 // for calculating no. of obs.
tab nsfc_dep, gen(nsfc_dep_)

collapse (mean) nsfc_dep_1 nsfc_dep_2 nsfc_dep_3 nsfc_dep_4 nsfc_dep_5 nsfc_dep_6 nsfc_dep_7 nsfc_dep_8 (sum) one

rename one n_obs
gen analysis_sample = 1

save "$temp_data_path/field_sample_6675.dta", replace


*====== female share: the CNKI scholar sample

use "$temp_data_path/author_wkunit_psInfo2_temp.dta", clear // source: "prep_grant.do"

collapse (mean) female

gen analysis_sample = 0

save "$temp_data_path/gender_full_sample.dta", replace


*====== female share: final analysis sample

use "$temp_data_path/author_wkunit_psInfo2_temp.dta", clear // source: "prep_grant.do"

keep if author_birthyr >= 1966 & author_birthyr <= 1975

collapse (mean) female

gen analysis_sample = 1

save "$temp_data_path/gender_sample_6675.dta", replace


*====== combine these datasets

*--- the CNKI scholar sample

use "$temp_data_path/wkunit_full_sample.dta", clear

merge 1:1 analysis_sample using "$temp_data_path/field_full_sample.dta"
drop _merge

merge 1:1 analysis_sample using "$temp_data_path/gender_full_sample.dta"
drop _merge

save "$temp_data_path/char_full_sample.dta", replace

*--- final analysis sample

use "$temp_data_path/wkunit_sample_6675.dta", clear

merge 1:1 analysis_sample using "$temp_data_path/field_sample_6675.dta"
drop _merge

merge 1:1 analysis_sample using "$temp_data_path/gender_sample_6675.dta"
drop _merge

save "$temp_data_path/char_sample_6675.dta", replace


/* --------------------------------------------------------------- */
/*     youth grant awardees: analysis sample vs. NSFC admin data   */
/* --------------------------------------------------------------- */

*====== institution types: all youth grant awardees

use "$temp_data_path/youth_grants_1986-2021_wkunit_nsfcid.dta", clear // source: "prep_grant.do"

merge n:1 wkunit_nsfcid using "$raw_data_path/wkunit_strid_type.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                         1,438
        from master                     1,229  (_merge==1)
        from using                        209  (_merge==2)

    Matched                           206,842  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2
drop _merge

keep if wkunit_type == 1 | wkunit_type == 2 | wkunit_type == 4 | wkunit_type == 5 | wkunit_type == 6

tab wkunit_type, gen(wkunit_type_)

collapse (mean) wkunit_type_1 wkunit_type_2 wkunit_type_3 wkunit_type_4 wkunit_type_5

gen analysis_sample = 2

save "$temp_data_path/wkunit_all_awardees.dta", replace


*====== institution types: youth grant awardees in the CNKI scholar sample

use "$data_path/author_wkunit_psInfo_grant_young.dta", clear

keep if (wkunit_type == 1 | wkunit_type == 2 | wkunit_type == 4 | wkunit_type == 5 | wkunit_type == 6) & youth_grant == 1

tab wkunit_type, gen(wkunit_type_)

collapse (mean) wkunit_type_1 wkunit_type_2 wkunit_type_3 wkunit_type_4 wkunit_type_5

gen analysis_sample = 3

save "$temp_data_path/wkunit_CNKIsample_awardees.dta", replace


*====== institution types: youth grant awardees in the final analysis sample

use "$data_path/author_wkunit_psInfo_grant_young.dta", clear

keep if (wkunit_type == 1 | wkunit_type == 2 | wkunit_type == 4 | wkunit_type == 5 | wkunit_type == 6) & (author_birthyr >= 1966 & author_birthyr <= 1975) & youth_grant == 1

tab wkunit_type, gen(wkunit_type_)

collapse (mean) wkunit_type_1 wkunit_type_2 wkunit_type_3 wkunit_type_4 wkunit_type_5

gen analysis_sample = 4

save "$temp_data_path/wkunit_sample6675_awardees.dta", replace


*====== fields: all youth grant awardees

use "$temp_data_path/youth_grants_1986-2021_wkunit_nsfcid.dta", clear // source: "prep_grant.do"

gen one = 1 // for calculating no. of obs.
tab nsfc_dep, gen(nsfc_dep_)

collapse (mean) nsfc_dep_1 nsfc_dep_2 nsfc_dep_3 nsfc_dep_4 nsfc_dep_5 nsfc_dep_6 nsfc_dep_7 nsfc_dep_8 (sum) one

rename one n_obs
gen analysis_sample = 2

save "$temp_data_path/field_all_awardees.dta", replace


*====== fields: youth grant awardees in the CNKI scholar sample

use "$data_path/author_wkunit_psInfo_grant_young.dta", clear

keep if youth_grant == 1

gen one = 1 // for calculating no. of obs.
tab nsfc_dep, gen(nsfc_dep_)

collapse (mean) nsfc_dep_1 nsfc_dep_2 nsfc_dep_3 nsfc_dep_4 nsfc_dep_5 nsfc_dep_6 nsfc_dep_7 nsfc_dep_8 (sum) one

rename one n_obs
gen analysis_sample = 3

save "$temp_data_path/field_CNKIsample_awardees.dta", replace


*====== fields: youth grant awardees in the final analysis sample

use "$data_path/author_wkunit_psInfo_grant_young.dta", clear

keep if youth_grant == 1 & (author_birthyr >= 1966 & author_birthyr <= 1975)

gen one = 1 // for calculating no. of obs.
tab nsfc_dep, gen(nsfc_dep_)

collapse (mean) nsfc_dep_1 nsfc_dep_2 nsfc_dep_3 nsfc_dep_4 nsfc_dep_5 nsfc_dep_6 nsfc_dep_7 nsfc_dep_8 (sum) one

rename one n_obs
gen analysis_sample = 4

save "$temp_data_path/field_sample6675_awardees.dta", replace


*====== female share: all youth grant awardees

use "$temp_data_path/youth_grants_1986-2021_wkunit_nsfcid.dta", clear // source: "prep_grant.do"

merge 1:1 pj_id using "$raw_data_path/gender_youth_grants.dta", keepusing(pj_id male)

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                         2,465
        from master                     1,350  (_merge==1)
        from using                      1,115  (_merge==2)

    Matched                           206,721  (_merge==3)
    -----------------------------------------
*/

drop _merge

gen female = 1 - male

collapse (mean) female

gen analysis_sample = 2

save "$temp_data_path/gender_all_awardees.dta", replace


*====== female share: youth grant awardees in the CNKI scholar sample

use "$data_path/author_wkunit_psInfo_grant_young.dta", clear

keep if youth_grant == 1

collapse (mean) female

gen analysis_sample = 3

save "$temp_data_path/gender_CNKIsample_awardees.dta", replace


*====== female share: youth grant awardees in the final analysis sample

use "$data_path/author_wkunit_psInfo_grant_young.dta", clear

keep if youth_grant == 1 & (author_birthyr >= 1966 & author_birthyr <= 1975)

collapse (mean) female

gen analysis_sample = 4

save "$temp_data_path/gender_sample6675_awardees.dta", replace


*====== combine these datasets

*--- all youth grant awardees

use "$temp_data_path/wkunit_all_awardees.dta", clear

merge 1:1 analysis_sample using "$temp_data_path/field_all_awardees.dta"
drop _merge

merge 1:1 analysis_sample using "$temp_data_path/gender_all_awardees.dta"
drop _merge

save "$temp_data_path/char_all_awardees.dta", replace

*--- youth grant awardees in the CNKI scholar sample

use "$temp_data_path/wkunit_CNKIsample_awardees.dta", clear

merge 1:1 analysis_sample using "$temp_data_path/field_CNKIsample_awardees.dta"
drop _merge

merge 1:1 analysis_sample using "$temp_data_path/gender_CNKIsample_awardees.dta"
drop _merge

save "$temp_data_path/char_CNKIsample_awardees.dta", replace

*--- youth grant awardees in the final analysis sample

use "$temp_data_path/wkunit_sample6675_awardees.dta", clear

merge 1:1 analysis_sample using "$temp_data_path/field_sample6675_awardees.dta"
drop _merge

merge 1:1 analysis_sample using "$temp_data_path/gender_sample6675_awardees.dta"
drop _merge

save "$temp_data_path/char_sample6675_awardees.dta", replace


/* --------------------------------------------------------------- */
/*          Table: comparing characteristics across samples        */
/* --------------------------------------------------------------- */

*====== append to obtain the final dataset

use "$temp_data_path/char_full_sample.dta", clear

local datasets char_sample_6675 char_all_awardees char_CNKIsample_awardees char_sample6675_awardees
foreach dataset in `datasets' {
	append using "$temp_data_path/`dataset'.dta"
}

* label vars

label var nsfc_dep_1 "Math/Physics"
label var nsfc_dep_2 "Chemistry"
label var nsfc_dep_3 "Life science"
label var nsfc_dep_4 "Earth"
label var nsfc_dep_5 "Engineering"
label var nsfc_dep_6 "Computer science"
label var nsfc_dep_7 "Economics/Management"
label var nsfc_dep_8 "Medical science"

label var female "Female"

label var wkunit_type_1 "Project 985 universities"  // 985-project univ.
label var wkunit_type_2 "Project 211 universities"  // 211-project univ.
label var wkunit_type_3 "Other universities"
label var wkunit_type_4 "Chinese academy of sciences"
label var wkunit_type_5 "Other research institutions"

*====== table

local varlist wkunit_type_1 wkunit_type_2 wkunit_type_3 wkunit_type_4 wkunit_type_5 ///
	nsfc_dep_1 nsfc_dep_2 nsfc_dep_3 nsfc_dep_4 nsfc_dep_5 nsfc_dep_6 nsfc_dep_7 nsfc_dep_8 female 
	
foreach var in `varlist' {
	
	local lab: variable label `var'
	local `var'_name "`lab'"
	
	forvalues i = 0/4 {		
		
		local `var'_`i' = string(`var'[`i'+1],"%04.3f")
		
	}
}

forvalues i = 0/4 {		
		
	local n_obs_`i' = string(n_obs[`i'+1],"%9.0fc")
		
}

local varlist1 wkunit_type_1 wkunit_type_2 wkunit_type_3 wkunit_type_4 wkunit_type_5
local varlist2 nsfc_dep_1 nsfc_dep_2 nsfc_dep_3 nsfc_dep_4 nsfc_dep_5 nsfc_dep_6 nsfc_dep_7 nsfc_dep_8

*--- texdoc: write into LaTex

texdoc init "$table_path/Tab_sample_compare.tex", replace force
tex \begin{tabular}{lccccc} 
tex \hline \hline
tex & \multicolumn{2}{c}{Sample} & \multicolumn{3}{c}{Young scientist grant awardees}
tex & \cmidrule(lr){2-3} \cmidrule(lr){4-6}
tex & (1) & (2) & (3) & (4) & (5) \\
tex & CNKI scholars & Analysis sample & All & CNKI scholars & Analysis sample \\
tex \hline
tex & & & & &  \\
tex \textbf{Female} & `female_0' & `female_1' & `female_2' & `female_3' & `female_4' \\
tex & & & & & \\
tex \textbf{Institutions} & & & & & \\
foreach var in `varlist1' {
    tex \quad ``var'_name' & ``var'_0' & ``var'_1' & ``var'_2' & ``var'_3' & ``var'_4' \\
}
tex & & & & & \\
tex \textbf{Fields} & & & & & \\
foreach var in `varlist2' {
    tex \quad ``var'_name' & ``var'_0' & ``var'_1' & ``var'_2' & ``var'_3' & ``var'_4' \\
}
tex & & & & & \\
tex Observations & `n_obs_0' & `n_obs_1' & `n_obs_2' & `n_obs_3' & `n_obs_4' \\ 
tex \hline \hline
tex \end{tabular}
texdoc close


/* --------------------------------------------------------------- */
/*     Table: comparing journals: with vs. without author info     */
/* --------------------------------------------------------------- */
* limit to Chinese journals because English journals have no author information

use "$raw_data_path/journals.dta", clear

keep if eng_journal == 0 // keep only Chinese-language journals

tab nsfc_field, gen(nsfc_field0_)  // for t tests

gen monthly_pub = 0
replace monthly_pub = 1 if n_issues == 12
label var monthly_pub "dummy for monthly publication"

local varlist if_zh start_year monthly_pub affil_univ affil_cas affil_assoc ///
	nsfc_field0_1 nsfc_field0_2 nsfc_field0_3 nsfc_field0_4 nsfc_field0_5  ///
    nsfc_field0_6 nsfc_field0_7 nsfc_field0_8 nsfc_field0_9

local varlist1 if_zh start_year monthly_pub
local varlist2 affil_univ affil_cas affil_assoc
local varlist3 nsfc_field0_1 nsfc_field0_2 nsfc_field0_3 nsfc_field0_4 nsfc_field0_5 nsfc_field0_6 nsfc_field0_7 nsfc_field0_8 nsfc_field0_9

foreach var in `varlist' {
	
	ttest `var', by(author_info)
	
	local mean1_`var' = string(r(mu_1),"%04.3f")  // group mean: journals without author info
	local mean2_`var' = string(r(mu_2),"%04.3f")  // group mean: journals with author info
	local diff_`var' = string(r(mu_2)-r(mu_1),"%04.3f")  // group diff
	local pval_`var' = r(p)  // p value associated with group diff
	
	* Generating stars for significance
	if `pval_`var'' <= 0.1 local st_`var' = "*"
	if `pval_`var'' <= 0.05 local st_`var' = "**"
	if `pval_`var'' <= 0.01 local st_`var' = "***"        
	
}    
    
* no. of obs
forvalues j = 0/1 {
	sum id if author_info == `j'
	local n_`j' = r(N)
}


*====== tex setting
* based on Excel's merging

local tex_if_zh "Impact factor"
local tex_start_year "Year of journal's founding"
local tex_monthly_pub "Publishes issues monthly"
local tex_affil_univ "\quad Universities"
local tex_affil_cas "\quad Chinese academy of sciences"
local tex_affil_assoc "\quad Academic association"
local tex_nsfc_field0_1 "\quad Math/Physics"
local tex_nsfc_field0_2 "\quad Chemistry"
local tex_nsfc_field0_3 "\quad Life Science"
local tex_nsfc_field0_4 "\quad Earth"
local tex_nsfc_field0_5 "\quad Engineering"
local tex_nsfc_field0_6 "\quad Computer Science"
local tex_nsfc_field0_7 "\quad Economics/Management"
local tex_nsfc_field0_8 "\quad Medical science"
local tex_nsfc_field0_9 "\quad Multiple fields"
local tex_obs "\textit{N}"

foreach var in `varlist' {
        
    local tex_`var' = "`tex_`var'' & `mean2_`var'' & `mean1_`var'' & `diff_`var''`st_`var''"            
    
    di "`tex_`var''"    
}

local tex_obs = "`tex_obs' & `n_1' & `n_0' & "


*====== generating the table

texdoc init "$table_path/Tab_journals.tex", replace force

tex \begin{tabular}{lccc}
tex \hline \hline
tex & (1) & (2) & (3)  \\
tex & Has author information & No author information & Difference \\
tex \hline
tex & & & \\
foreach var in `varlist1' {
    tex `tex_`var'' \\
}
tex & & & \\
tex \textbf{Affiliation} & & & \\
foreach var in `varlist2' {
    tex `tex_`var'' \\
}
tex & & & \\
tex \textbf{Field} & & & \\
foreach var in `varlist3' {
    tex `tex_`var'' \\
}
tex & & & \\
tex `tex_obs' \\
tex \hline \hline
tex \end{tabular}

texdoc close

