/*

preparing the academic rank data + migration data

* Edited by Alex 2025-06-27. Works
*/

/* #################################################### */
/*                                                      */
/*          preparing the academic rank data            */
/*                                                      */
/* #################################################### */

*====== obtaining unique personal id

*--- NSFC participant data

use "$raw_data_path/nsfc_participant_title.dta", clear

merge n:1 author_name wkunit_nsfcid using "$data_path/author_wkunit_psInfo_grant_young.dta", keepusing(author_numid2 author_name wkunit_nsfcid)

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     1,167,092
        from master                   810,352  (_merge==1)
        from using                    356,740  (_merge==2)

    Matched                           206,381  (_merge==3)
    -----------------------------------------
*/

keep if _merge == 3
drop _merge author_name wkunit_nsfcid

save "$temp_data_path/nsfc_title_matched.dta", replace

*--- CNKI author data

use "$raw_data_path/cnki_author_title.dta", clear

merge n:1 paperid author_name using "$raw_data_path/data_author_id.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     2,918,132
        from master                    23,837  (_merge==1)
        from using                  2,894,295  (_merge==2)

    Matched                           950,890  (_merge==3)
    -----------------------------------------
*/

keep if _merge == 3
drop _merge paperid author_name

* turn author string id to numeric id

replace author_numid = subinstr(author_numid,"\n","",.)  // nonnumeric string
destring author_numid, gen(author_numid2)

drop author_numid

save "$temp_data_path/cnki_title_matched.dta", replace

*====== personal academic rank

use "$temp_data_path/nsfc_title_matched.dta", clear

append using "$temp_data_path/cnki_title_matched.dta"

* drop student obs

drop if title == "博士研究生" | title == "硕士研究生" // 303,938 obs dropped

* define the academic rank variable

gen asst_prof = 0
replace asst_prof = 1 if title == "主治医师" | title == "助理教授" | title == "助理研究员" | title == "工程师" | title == "讲师"
label var asst_prof "dummy for assistant professor-level rank"

gen assoc_prof = 0
replace assoc_prof = 1 if title == "副主任医师" | title == "副教授" | title == "副研究员" | title == "高级工程师" | title == "高级讲师"
label var assoc_prof "dummy for associate professor-level rank"

gen full_prof = 0
replace full_prof = 1 if title == "主任医师" | title == "教授" | title == "教授级高级工程师" | title == "研究员"
label var full_prof "dummy for full professor-level rank"

gen prof_type = 1 if asst_prof == 1
replace prof_type = 2 if assoc_prof == 1
replace prof_type = 3 if full_prof == 1

* keep obs at the individual-year level

sort author_numid2 year prof_type
by author_numid2 year: gen count = _n
by author_numid2 year: gen count2 = _N
keep if count == count2 // keep the highest rank; 198,764 obs dropped

drop count count2 title prof_type

save "$temp_data_path/career_rank.dta", replace

*====== final rank year data

*--- author level

use "$temp_data_path/career_rank.dta", clear

sort author_numid2
by author_numid2: gen count = _n
keep if count == 1
keep author_numid2

save "$temp_data_path/career_rank_author.dta", replace

*--- year of becoming full professor

use "$temp_data_path/career_rank.dta", clear

keep if full_prof == 1

sort author_numid2 year
by author_numid2: gen count = _n
keep if count == 1

keep author_numid2 year full_prof

rename year full_prof_year

save "$temp_data_path/full_prof_year.dta", replace

*--- year of becoming associate professor

use "$temp_data_path/career_rank.dta", clear

keep if assoc_prof == 1

sort author_numid2 year
by author_numid2: gen count = _n
keep if count == 1

keep author_numid2 year assoc_prof

rename year assoc_prof_year

save "$temp_data_path/assoc_prof_year.dta", replace

*--- merge the above datasets

use "$temp_data_path/career_rank_author.dta", clear

* merge full professor data

merge 1:1 author_numid2 using "$temp_data_path/full_prof_year.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       187,752
        from master                   187,752  (_merge==1)
        from using                          0  (_merge==2)

    Matched                            80,390  (_merge==3)
    -----------------------------------------
*/

replace full_prof = 0 if _merge == 1
drop _merge

* merge associate professor data

merge 1:1 author_numid2 using "$temp_data_path/assoc_prof_year.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       143,347
        from master                   143,347  (_merge==1)
        from using                          0  (_merge==2)

    Matched                           124,795  (_merge==3)
    -----------------------------------------
*/

replace assoc_prof = 0 if _merge == 1
drop _merge

* drop those obs with year of promotion to associate professor being later than year of promotion to full professor
* 1,082 obs dropped: 0.4% of the total

drop if (assoc_prof == 1 & full_prof == 1) & (assoc_prof_year > full_prof_year & assoc_prof_year < . & full_prof_year < .)
drop assoc_prof full_prof

save "$data_path/career_rank_year.dta", replace


/* #################################################### */
/*                                                      */
/*            preparing the migration data              */
/*                                                      */
/* #################################################### */

*====== NSFC grant PIs and participants

use "$raw_data_path/nsfc_participant_title.dta", clear

merge n:1 author_name wkunit_nsfcid using "$data_path/author_wkunit_psInfo_grant_young.dta", keepusing(author_numid2 author_name wkunit_nsfcid)

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     1,167,092
        from master                   810,352  (_merge==1)
        from using                    356,740  (_merge==2)

    Matched                           206,381  (_merge==3)
    -----------------------------------------
*/

keep if _merge == 3
drop _merge author_name title

save "$temp_data_path/nsfc_mobility_matched.dta", replace

*====== CNKI scholars

use "$temp_data_path/author_wkunit_psInfo_mig.dta", clear

* merge the affiliation NSFC id

merge n:1 wkunit_id2 using "$raw_data_path/wkunit_numid_nsfcid.dta"
keep if _merge == 3
drop _merge

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                           475
        from master                         0  (_merge==1)
        from using                        475  (_merge==2)

    Matched                           493,595  (_merge==3)
    -----------------------------------------
*/

* turn author string id to numeric id

*replace author_numid = subinstr(author_numid,"\n","",.)  // nonnumeric string
*destring author_numid, gen(author_numid2)

* keep the data for appending

rename publish_year year
keep author_numid2 wkunit_nsfcid year

*====== appending the two datasets

append using "$temp_data_path/nsfc_mobility_matched.dta"

* drop repeated obs at the individual-institution level

sort author_numid2 wkunit_nsfcid year // in order to choose the earliest migration info
by author_numid2 wkunit_nsfcid: gen count = _n
keep if count == 1
drop count

sort author_numid2
by author_numid2: gen count = _N

gen migrant2 = 0
replace migrant2 = 1 if count >= 2
label var migrant2 "dummy for being a migrant: based on CNKI + NSFC data"
drop count

* identify migrant-year information

sort author_numid2 year
by author_numid2: gen count = _n

gen mig_yr = 0 if count == 1
replace mig_yr = 1 if count > 1
label var mig_yr "dummy for migrating in a given year"

drop count

save "$temp_data_path/scholar_mig_tmp.dta", replace

* generate migrant-year data

use "$temp_data_path/scholar_mig_tmp.dta", clear

keep author_numid2 year mig_yr

sort author_numid2 year
by author_numid2 year: gen count = _n
keep if count == 1
drop count

save "$data_path/scholar_mig_year.dta", replace

* generate individual-level migrant data

use "$temp_data_path/scholar_mig_tmp.dta", clear

sort author_numid2
by author_numid2: gen count = _n
keep if count == 1
drop count

keep author_numid2 migrant2

save "$data_path/scholar_mig.dta", replace
