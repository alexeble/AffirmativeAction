/*

preparing grant-related dataset: individual-year level

* Edited by Alex 2025-06-27. Works.

*/

*############################################################################### 
*
*           grant obs expanded to researcher-year level
*
*############################################################################### 

*====== generate the framework at the researcher-yeear level
* cohort 1961-1991 & year 2001-2021

use "$temp_data_path/author_wkunit_psInfo2_temp.dta", clear

keep if author_birthyr >= 1961 & author_birthyr <= 1991

expand 21  // year 2001-2021
sort author_numid2
gen year = 2001 + mod((_n-1),21)

save "$temp_data_path/grant_framework.dta", replace

*====== youth grants at the researcher-yeear level

use "$temp_data_path/grant_framework.dta", clear

merge 1:1 author_numid2 year using "$temp_data_path/grant_young_matched.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     7,156,093
        from master                 7,154,179  (_merge==1)
        from using                      1,914  (_merge==2)

    Matched                            37,901  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2 // those grant awardees who were not born in [1961, 1991]
drop _merge

gen youth_grant_ry = 0
replace youth_grant_ry = 1 if youth_grant == 1
label var youth_grant_ry "dummy for youth grant at the research-year (ry) level"

*====== general grants at the researcher-yeear level

merge 1:1 author_numid2 year using "$temp_data_path/grant_general_matched.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     7,141,366
        from master                 7,126,801  (_merge==1)
        from using                     14,565  (_merge==2)

    Matched                            65,279  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2 // those grant awardees who were not born in [1961, 1991]
drop _merge

gen gen_grant_ry = 0
replace gen_grant_ry = 1 if gen_grant == 1
label var gen_grant_ry "dummy for general grant at the research-year (ry) level"

gen youth_gen_grant_ry = youth_grant_ry + gen_grant_ry
label var youth_gen_grant_ry "number of youth & general grants at the research-year (ry) level"

gen age = year - author_birthyr

keep if age >= 25  // to ensure that people are at least 25 years old in the application year: 2,390,813 obs dropped

*====== treatment variables

gen treated = 0
replace treated = 1 if author_birthyr >= 1971

gen post = 0
replace post = 1 if year >= 2011

gen treat_female = treated * female
label var treat_female "treated * female"

gen post_female = post * female
label var post_female "post * female"

gen treat_post = treated * post
label var treat_post "treated * post"

gen treat_female_post = treated * female * post 
label var treat_female_post "treated * female * post"

* two post-periods

gen post1 = post
replace post1 = 0 if year >= 2016
label var post1 "dummy for 2011-2015 period"

gen post2 = post
replace post2 = 0 if year < 2016
label var post2 "dummy for 2016-2021 period"

forvalues i = 1/2 {
	gen post`i'_female = post`i' * female
	gen treat_post`i' = treated * post`i'
	gen treat_female_post`i' = treated * female * post`i'
}

* dummies for years until treatment

gen yr_diff = year - 2011 

gen yearsuntil = yr_diff if treat_female == 1

forval i = 1/10 {
	gen years_n`i' = 0
	replace years_n`i' = 1 if yearsuntil == - `i'
}

forval i = 0/10 {
	gen years_p`i' = 0
	replace years_p`i' = 1 if yearsuntil == `i'
}

gen year_cutoff = 0  // for graphing the event study estimates

encode wkunit_nsfcid, gen(wkunitId)

drop author_name author_wkunit_name2 author_numid wkunit_nsfcid pj_type pj_type_g

*====== funding amount at the researcher-year level

replace pj_money = 0 if pj_money == . // for later calculation: missing values as 0
replace pj_money_g = 0 if pj_money_g == . // for later calculation: missing values as 0
gen fund_amount = (pj_money + pj_money_g) * 10 // orginal values are in 10,000 yuan
replace fund_amount = fund_amount*1.2 if year >= 2015  // after 2015, the amount of funding is the direct amount; the indirect amount is 20% of the direct amount; source: https://www.nsfc.gov.cn/publish/portal0/wd/jf/06/
label var fund_amount "funding amount of NSFC grants in 1,000 yuan"

* add CPI deflators

merge n:1 year using "$raw_data_path/CPI.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                            15
        from master                         0  (_merge==1)
        from using                         15  (_merge==2)

    Matched                         4,801,216  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2
drop _merge

gen fund_amount_deflated = fund_amount/cpi_1986 * 3.13101 // 3.13101 is the 2001 deflator
label var fund_amount_deflated "amount of funding: deflated with 1986 as the baseline year"

drop cpi_1986


*====== academic rank

merge n:1 author_numid2 using "$data_path/career_rank_year.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     1,855,047
        from master                 1,762,954  (_merge==1)
        from using                     92,093  (_merge==2)

    Matched                         3,038,262  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2

gen rank_sample = 0
replace rank_sample = 1 if _merge == 3
label var rank_sample "dummy for the sample with academic rank info"

drop _merge

gen assoc_prof = 0 if rank_sample == 1
replace assoc_prof = 1 if year == assoc_prof_year & rank_sample == 1
label var assoc_prof "dummy for associate professor"

gen full_prof = 0 if rank_sample == 1
replace full_prof = 1 if year == full_prof_year & rank_sample == 1
label var full_prof "dummy for full professor"

* full professor without the information on year of being promoted to associate professor:
* assuming full professors obtained their associate professor rank five years before becoming a full professor

gen assoc_prof_year2 = assoc_prof_year
replace assoc_prof_year2 = full_prof_year - 5 if full_prof_year < . & assoc_prof_year == .

gen assoc_prof2 = 0 if rank_sample == 1
replace assoc_prof2 = 1 if year == assoc_prof_year2 & rank_sample == 1
label var assoc_prof2 "dummy for associate professor: adding calculated promotion year (-5)"

gen assoc_prof_year3 = assoc_prof_year
replace assoc_prof_year3 = full_prof_year - 8 if full_prof_year < . & assoc_prof_year == .

gen assoc_prof3 = 0 if rank_sample == 1
replace assoc_prof3 = 1 if year == assoc_prof_year3 & rank_sample == 1
label var assoc_prof3 "dummy for associate professor: adding calculated promotion year (-8)"

gen assoc_prof_status = 0 if rank_sample == 1
replace assoc_prof_status = 1 if year >= full_prof_year & full_prof_year < .
replace assoc_prof_status = 1 if year >= assoc_prof_year3 & assoc_prof_year3 < .
label var assoc_prof_status "dummy for being an associate or full prof in that year"

gen full_prof_status = 0 if rank_sample == 1
replace full_prof_status = 1 if year >= full_prof_year & full_prof_year < .
label var full_prof_status "dummy for being a full prof in that year"

*--- time trends variable

gen treat_trend = treated * year
label var treat_trend "group-specific time trends: treated * year"


*====== migration

merge n:1 author_numid2 using "$data_path/scholar_mig.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       119,323
        from master                         0  (_merge==1)
        from using                    119,323  (_merge==2)

    Matched                         4,801,216  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2
drop _merge

merge n:1 author_numid2 year using "$data_path/scholar_mig_year.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     4,598,435
        from master                 4,454,866  (_merge==1)
        from using                    143,569  (_merge==2)

    Matched                           346,350  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2
replace mig_yr = 0 if _merge == 1
drop _merge


*====== top scholars

merge n:1 author_numid2 using "$temp_data_path/top_scholar_66_75.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     3,697,414
        from master                 3,697,414  (_merge==1)
        from using                          0  (_merge==2)

    Matched                         1,103,802  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2
drop _merge

save "$data_path/grants_researcher_year.dta", replace

* keep the sample of cohorts 1966-1975

use "$data_path/grants_researcher_year.dta", clear

keep if author_birthyr >= 1966 & author_birthyr <= 1975

save "$data_path/grants_researcher_year_66_75.dta", replace


*############################################################################### 
*
*            1966-1975 cohorts: before-policy characteristics
*
*############################################################################### 

*====== number of youth/general grants until 2010

use "$data_path/grants_researcher_year_66_75.dta", clear

keep if year <= 2010

sort author_numid2
by author_numid2: egen pre_youth_grant = sum(youth_grant_ry)
label var pre_youth_grant "number of youth grants before the policy"

by author_numid2: egen pre_gen_grant = sum(gen_grant_ry)
label var pre_gen_grant "number of general grants before the policy"

by author_numid2: gen count = _n
keep if count == 1

keep author_numid2 pre_youth_grant pre_gen_grant

save "$temp_data_path/pre_grants.dta", replace

*====== other characteristics

use "$data_path/grants_researcher_year_66_75.dta", clear

keep if year == 2010

* academic rank

gen pre_full_prof = 0 if rank_sample == 1
replace pre_full_prof = 1 if rank_sample == 1 & full_prof_year <= 2010
label var pre_full_prof "being a full professor before the policy"

gen pre_assoc_prof = 0 if rank_sample == 1
replace pre_assoc_prof = 1 if rank_sample == 1 & assoc_prof_year <= 2010
replace pre_assoc_prof = 0 if pre_full_prof == 1 // 1,491 obs changed values
label var pre_assoc_prof "being an associate professor before the policy"

* keep vars

keep author_numid2 author_birthyr female nsfc_field0 wkunit_type pre_assoc_prof pre_full_prof top_scholar1 top_scholar2 top_scholar3 rank_sample

*--- merge with number of grants

merge 1:1 author_numid2 using "$temp_data_path/pre_grants.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                             0
    Matched                            52,562  (_merge==3)
    -----------------------------------------
*/

drop _merge

* field dummies

replace nsfc_field0 = . if nsfc_field0 == 0  // 550 obs
tab nsfc_field0, gen(nsfc_field0_)

* institution type dummies

replace wkunit_type = . if wkunit_type == 3  // 2 obs: overseas institutions
tab wkunit_type, gen(wkunit_type)

gen cohorts_1971 = 0
replace cohorts_1971 = 1 if author_birthyr >= 1971 & author_birthyr <= 1975
label var cohorts_1971 "dummy for cohorts born after 1971"

save "$data_path/pre_policy_char_66_75.dta", replace


/*############### number of youth grants in 2010 at the institution level

use "$temp_data_path/grants_1986-2021_wkunit_nsfcid.dta", clear

keep if pj_type == 2 & pj_year == 2010

sort wkunit_nsfcid
by wkunit_nsfcid: gen n_ygrant_2010 = _N
label var n_ygrant_2010 "number of youth grants in 2010 at the institution level"

by wkunit_nsfcid: gen count = _n
keep if count == 1

keep wkunit_nsfcid n_ygrant_2010
drop if wkunit_nsfcid == ""

save "$data_path/ygrants_wkunit_2010.dta", replace

*/


*############################################################################### 
*
*            1966-1975 cohorts: redefine event study-related vars for DD
*
*############################################################################### 

use "$data_path/grants_researcher_year_66_75.dta", clear

*--- drop event study-related vars for DDD

drop years_n* years_p* yearsuntil

*--- redefine event study-related vars for DD

gen yearsuntil = yr_diff if treated == 1

forval i = 1/10 {
	gen years_n`i' = 0
	replace years_n`i' = 1 if yearsuntil == - `i'
}

forval i = 0/10 {
	gen years_p`i' = 0
	replace years_p`i' = 1 if yearsuntil == `i'
}

save "$data_path/grants_researcher_year_66_75_DD.dta", replace


*############################################################################### 
*
*            1961-1980 cohorts: redefine event study-related vars for DD
*
*############################################################################### 

use "$data_path/grants_researcher_year.dta", clear

keep if author_birthyr >= 1961 & author_birthyr <= 1980

*--- drop event study-related vars for DDD

drop years_n* years_p* yearsuntil

*--- redefine event study-related vars for DD

gen yearsuntil = yr_diff if treated == 1

forval i = 1/10 {
	gen years_n`i' = 0
	replace years_n`i' = 1 if yearsuntil == - `i'
}

forval i = 0/10 {
	gen years_p`i' = 0
	replace years_p`i' = 1 if yearsuntil == `i'
}

save "$data_path/grants_researcher_year_61_80_DD.dta", replace


*############################################################################### 
*
*            1961-1970 cohorts: constructed for placebo tests
*
*############################################################################### 

use "$data_path/grants_researcher_year.dta", clear

keep if author_birthyr >= 1961 & author_birthyr <= 1970

*--- drop previous treatment-related vars

drop years_n* years_p* yearsuntil treated treat_female treat_post treat_female_post treat_post1 treat_female_post1 treat_post2 treat_female_post2 post post_female post1 post2 post1_female post2_female yr_diff year_cutoff

*--- define instead "placebo" treatment-related vars

gen treated = 0
replace treated = 1 if author_birthyr >= 1966

gen post = 0
replace post = 1 if year >= 2011

gen treat_female = treated * female
label var treat_female "treated * female"

gen post_female = post * female
label var post_female "post * female"

gen treat_post = treated * post
label var treat_post "treated * post"

gen treat_female_post = treated * female * post 
label var treat_female_post "treated * female * post"

* two post-periods

gen post1 = post
replace post1 = 0 if year >= 2016
label var post1 "dummy for 2011-2015 period"

gen post2 = post
replace post2 = 0 if year < 2016
label var post2 "dummy for 2016-2021 period"

forvalues i = 1/2 {
	gen post`i'_female = post`i' * female
	gen treat_post`i' = treated * post`i'
	gen treat_female_post`i' = treated * female * post`i'
}

* dummies for years until treatment

gen yr_diff = year - 2011 

gen yearsuntil = yr_diff if treat_female == 1

forval i = 1/10 {
	gen years_n`i' = 0
	replace years_n`i' = 1 if yearsuntil == - `i'
}

forval i = 0/10 {
	gen years_p`i' = 0
	replace years_p`i' = 1 if yearsuntil == `i'
}

gen year_cutoff = 0  // for graphing the event study estimates

save "$data_path/grants_researcher_year_61_70.dta", replace

