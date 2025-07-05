/*

To link CNKI authors to Scopus publications

input files: mostly from "D:\scopus\nsfc_policy\cohorts66_75"
(1) prof_author_id_66_75
(2) scopus_pub_66_75
(3) source_sjr.dta

output files:
(1) scopus_pubs_yr_66_75.dta
(2) psInfo_scopus_pubs_yr_66_75.dta

* Edited by Alex 2025-06-27. Works.

*/


*############################################################################### 
*
*                         scopus publications
*
*############################################################################### 

*====== link scopus id to author id

*--- generate the dummy for researchers having no Scopus publication record

use "$raw_data_path/scopus_pub_66_75.dta", clear

merge n:1 prof_id using "$raw_data_path/prof_author_id_66_75.dta"

/*
    Result                           # of obs.
    -----------------------------------------
    not matched                        13,643
        from master                         0  (_merge==1)
        from using                     13,643  (_merge==2)

    matched                         1,704,824  (_merge==3)
    -----------------------------------------
*/

gen nopaper = 1 if _merge == 2
replace nopaper = 0 if _merge == 3
label var nopaper "dummy for having no Scopus pub record"

keep prof_id author_numid2 nopaper

sort prof_id
by prof_id: gen count = _n
keep if count == 1
drop count

save "$temp_data_path/nopaper.dta", replace

*--- keep the researchers who have Scopus publication records

use "$raw_data_path/scopus_pub_66_75.dta", clear

merge n:1 prof_id using "$raw_data_path/prof_author_id_66_75.dta"

/*
    Result                           # of obs.
    -----------------------------------------
    not matched                        13,643
        from master                         0  (_merge==1)
        from using                     13,643  (_merge==2)

    matched                         1,704,824  (_merge==3)
    -----------------------------------------
*/

keep if _merge == 3
drop _merge

*- journal quality indicators

merge n:1 source_id publish_yr using "$raw_data_path/source_sjr.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       850,185
        from master                   476,665  (_merge==1)
        from using                    373,520  (_merge==2)

    Matched                         1,228,159  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2  
drop _merge

replace top10 = 0 if top10 == .
replace top25 = 0 if top25 == .

label var source_id "pub source id"

save "$temp_data_path/person_id_paper.dta", replace


*====== generate the pub data at the author-year level

*--- both journal/conference paper data at the author-year level

use "$temp_data_path/person_id_paper.dta", clear

keep if publish_yr >= 2001 & publish_yr <= 2021  // in order to be consistent with the main grant dataset: the youngest age of publishing is 26 years old (1966 - 1975); drop 8% of the total pubs, mostly year-2022 papers
keep if pub_type == 1 | pub_type == 2  // keep journal/conference papers, drop book pubs: 4.8% of the total pubs

sort author_numid2 publish_yr

by author_numid2 publish_yr: gen n_papers_yr = _N
label var n_papers_yr "annual number of papers"

by author_numid2 publish_yr: egen n_papers1_yr = sum(author_1st)
label var n_papers1_yr "annual number of first-authored papers"

by author_numid2 publish_yr: egen n_papers9_yr = sum(author_last)
label var n_papers9_yr "annual number of last-authored papers"

by author_numid2 publish_yr: egen n_papers10_yr = sum(top10)
label var n_papers10_yr "annual number of top 10% SJR papers"

by author_numid2 publish_yr: egen n_papers25_yr = sum(top25)
label var n_papers25_yr "annual number of top 25% SJR papers"

by author_numid2 publish_yr: egen n_cite_yr = sum(num_citations)
label var n_cite_yr "annual number of citations"

gen n_cite_yr2 = n_cite_yr/(2023 - publish_yr)
label var n_cite_yr2 "annual no. of citations divided by diff. between publishing year and 2022"

by author_numid2 publish_yr: egen avg_author_count_yr = mean(author_count)
label var avg_author_count_yr "annual average number of authors per paper"

by author_numid2 publish_yr: gen count1 = _n
keep if count1 == n_papers_yr

drop paper_id author_count num_citations pub_type author_1st author_last top10 top25 publish_mon fund_nsfc count1 source_id

label var prof_id "researcher numeric id"
label var author_id "Scopus author id"
label var author_numid2 "CNKI author id"
label var publish_yr "year of publishing"

save "$temp_data_path/scopus_papers_yr.dta", replace


*--- journal paper data at the author-year level

use "$temp_data_path/person_id_paper.dta", clear

keep if publish_yr >= 2001 & publish_yr <= 2021  // in order to be consistent with the main grant dataset: the youngest age of publishing is 26 years old (1966 - 1975); drop 8% of the total pubs, mostly year-2022 papers
keep if pub_type == 1  // keep journal papers, drop conference papers/book pubs

sort author_numid2 publish_yr

by author_numid2 publish_yr: gen n_jpapers_yr = _N
label var n_jpapers_yr "annual number of journal papers"

by author_numid2 publish_yr: egen n_jpapers1_yr = sum(author_1st)
label var n_jpapers1_yr "annual number of first-authored journal papers"

by author_numid2 publish_yr: egen n_jpapers9_yr = sum(author_last)
label var n_jpapers9_yr "annual number of last-authored journal papers"

by author_numid2 publish_yr: egen n_jpapers10_yr = sum(top10)
label var n_jpapers10_yr "annual number of top 10% SJR journal papers"

by author_numid2 publish_yr: egen n_jpapers25_yr = sum(top25)
label var n_jpapers25_yr "annual number of top 25% SJR journal papers"

by author_numid2 publish_yr: egen n_jcite_yr = sum(num_citations)
label var n_jcite_yr "annual number of citations: journal papers"

gen n_jcite_yr2 = n_jcite_yr/(2023 - publish_yr)
label var n_jcite_yr2 "annual no. of citations divided by diff. between publishing year and 2022: journal papers"

by author_numid2 publish_yr: egen avg_author_jcount_yr = mean(author_count)
label var avg_author_jcount_yr "annual average number of authors per journal paper"

by author_numid2 publish_yr: gen count1 = _n
keep if count1 == n_jpapers_yr

keep author_numid2 publish_yr n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jpapers10_yr n_jpapers25_yr n_jcite_yr n_jcite_yr2 avg_author_jcount_yr

save "$temp_data_path/scopus_jpapers_yr.dta", replace


*--- conference paper data at the author-year level

use "$temp_data_path/person_id_paper.dta", clear

keep if publish_yr >= 2001 & publish_yr <= 2021  // in order to be consistent with the main grant dataset: the youngest age of publishing is 26 years old (1966 - 1975); drop 8% of the total pubs, mostly year-2022 papers
keep if pub_type == 2  // keep conference papers, drop journal papers/book pubs

sort author_numid2 publish_yr

by author_numid2 publish_yr: gen n_cpapers_yr = _N
label var n_cpapers_yr "annual number of conference papers"

by author_numid2 publish_yr: egen n_cpapers1_yr = sum(author_1st)
label var n_cpapers1_yr "annual number of first-authored conference papers"

by author_numid2 publish_yr: egen n_cpapers9_yr = sum(author_last)
label var n_cpapers9_yr "annual number of last-authored conference papers"

by author_numid2 publish_yr: egen n_cpapers10_yr = sum(top10)
label var n_cpapers10_yr "annual number of top 10% SJR conference papers"

by author_numid2 publish_yr: egen n_cpapers25_yr = sum(top25)
label var n_cpapers25_yr "annual number of top 25% SJR conference papers"

by author_numid2 publish_yr: egen n_ccite_yr = sum(num_citations)
label var n_ccite_yr "annual number of citations: conference papers"

gen n_ccite_yr2 = n_ccite_yr/(2023 - publish_yr)
label var n_ccite_yr2 "annual no. of citations divided by diff. between publishing year and 2022: conference papers"

by author_numid2 publish_yr: egen avg_author_ccount_yr = mean(author_count)
label var avg_author_ccount_yr "annual average number of authors per conference paper"

by author_numid2 publish_yr: gen count1 = _n
keep if count1 == n_cpapers_yr

keep author_numid2 publish_yr n_cpapers_yr n_cpapers1_yr n_cpapers9_yr n_cpapers10_yr n_cpapers25_yr n_ccite_yr n_ccite_yr2 avg_author_ccount_yr

save "$temp_data_path/scopus_cpapers_yr.dta", replace


*--- merge journal/conference papers into the main pub dataset

use "$temp_data_path/scopus_papers_yr.dta", clear

* journal papers

merge 1:1 author_numid2 publish_yr using "$temp_data_path/scopus_jpapers_yr.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                        26,399
        from master                    26,399  (_merge==1)
        from using                          0  (_merge==2)

    Matched                           320,776  (_merge==3)
    -----------------------------------------
*/

foreach var in n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jpapers10_yr n_jpapers25_yr n_jcite_yr n_jcite_yr2 avg_author_jcount_yr {	
	replace `var' = 0 if _merge == 1	
}

drop _merge

* conference papers

merge 1:1 author_numid2 publish_yr using "$temp_data_path/scopus_cpapers_yr.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       252,277
        from master                   252,277  (_merge==1)
        from using                          0  (_merge==2)

    Matched                            94,898  (_merge==3)
    -----------------------------------------
*/

foreach var in n_cpapers_yr n_cpapers1_yr n_cpapers9_yr n_cpapers10_yr n_cpapers25_yr n_ccite_yr n_ccite_yr2 avg_author_ccount_yr {	
	replace `var' = 0 if _merge == 1	
}

drop _merge

rename publish_yr year // for later merging

drop prof_id author_id

*--- merge the field data

merge n:1 author_numid2 using "$temp_data_path/author_wkunit_psInfo2_temp.dta", keepusing(author_numid2 field_code nsfc_field0 field_fund field_lab)

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       415,167
        from master                       380  (_merge==1)
        from using                    414,787  (_merge==2)

    Matched                           346,795  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2
drop _merge


save "$data_path/scopus_pubs_yr_66_75.dta", replace


*====== generate the pub data at the author-year level in 2010: baseline level

use "$data_path/scopus_pubs_yr_66_75.dta", clear

keep if year == 2010

keep author_numid2 n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jpapers25_yr n_jpapers10_yr n_jcite_yr n_jcite_yr2

local varlist n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jpapers25_yr n_jpapers10_yr n_jcite_yr n_jcite_yr2

foreach var in `varlist' {
	rename `var' `var'_2010
}

save "$temp_data_path/scopus_pubs_yr_66_75_2010.dta", replace


*====== generate the pre-policy pub data at the author-year level: average during 2008-2010

* pubs for cohorts 1966-1975 in 2008-2010 period

use "$data_path/scopus_pubs_yr_66_75.dta", clear

keep if year >= 2008 & year <= 2010

save "$temp_data_path/scopus_pubs_yr_66_75_2008_2010.dta", replace

* merge with the framework for cohorts 1966-1975 in 2008-2010 period

use "$temp_data_path/grant_framework.dta", clear

keep if author_birthyr >= 1966 & author_birthyr <= 1975
keep if year >= 2008 & year <= 2010

keep author_numid2 year

merge 1:1 author_numid2 year using "$temp_data_path/scopus_pubs_yr_66_75_2008_2010.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       105,955
        from master                   105,502  (_merge==1)
        from using                        453  (_merge==2)

    Matched                            52,184  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2

local varlist n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jpapers25_yr n_jpapers10_yr n_jcite_yr n_jcite_yr2

foreach var in `varlist' {
	replace `var' = 0 if _merge == 1
}

* average number of pubs/top pubs

sort author_numid2
by author_numid2: egen n_jpapers_avg = mean(n_jpapers_yr)
by author_numid2: egen n_jpapers25_avg = mean(n_jpapers25_yr)

* keep only one obs for each individual

sort author_numid2
by author_numid2: gen count1 = _n
by author_numid2: gen count2 = _N
keep if count1 == count2
drop count1 count2

* field-level median and p75

sort field_code
by field_code: egen n_jpapers_avg50 = median(n_jpapers_avg)
by field_code: egen n_jpapers_avg75 = pctile(n_jpapers_avg), p(75)
*by field_code: egen n_jpapers25_avg50 = median(n_jpapers25_avg) // the majority of people have no top publications; not using this metrics
*by field_code: egen n_jpapers25_avg75 = pctile(n_jpapers25_avg), p(75) // the majority of people have no top publications; not using this metrics

* define top scholars

gen top_scholar1 = 0
replace top_scholar1 = 1 if n_jpapers25_avg > 0
label var top_scholar1 "dummy for scholar having at least 1 top 25% journal pub in 2008-2010"

gen top_scholar2 = 0
replace top_scholar2 = 1 if n_jpapers_avg >= n_jpapers_avg75
replace top_scholar2 = 0 if n_jpapers_avg == 0
label var top_scholar2 "dummy for scholar whose num of pubs in 2008-2010 is top 25%"

gen top_scholar3 = 0
replace top_scholar3 = 1 if n_jpapers_avg > 0
label var top_scholar3 "dummy for scholar whose num of pubs in 2008-2010 is non-zero"

keep author_numid2 top_scholar1 top_scholar2 top_scholar3

save "$temp_data_path/top_scholar_66_75.dta", replace


*############################################################################### 
*
*     link CNKI authors to their scopus publications: 1966-1975 cohorts
*
*############################################################################### 

*--- keep the 1966-1975 cohorts

use "$data_path/grants_researcher_year.dta", clear

keep if author_birthyr >= 1966 & author_birthyr <= 1975

*--- link personal information to scopus publications

merge 1:1 author_numid2 year using "$data_path/scopus_pubs_yr_66_75.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       762,425
        from master                   759,526  (_merge==1)
        from using                      2,899  (_merge==2)

    Matched                           344,276  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2

local varlist n_papers_yr n_papers1_yr n_papers9_yr n_papers10_yr n_papers25_yr n_cite_yr n_cite_yr2 avg_author_count_yr ///
	n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jpapers10_yr n_jpapers25_yr n_jcite_yr n_jcite_yr2 avg_author_jcount_yr ///
	n_cpapers_yr n_cpapers1_yr n_cpapers9_yr n_cpapers10_yr n_cpapers25_yr n_ccite_yr n_ccite_yr2 avg_author_ccount_yr 

foreach var in `varlist' {
	replace `var' = 0 if _merge == 1
}

drop _merge

/*--- time trends variable

merge n:1 author_numid2 using "$temp_data_path/scopus_pubs_yr_66_75_2010.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       708,385
        from master                   708,330  (_merge==1)
        from using                         55  (_merge==2)

    Matched                           395,367  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2

local varlist n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jpapers25_yr n_jpapers10_yr n_jcite_yr n_jcite_yr2

foreach var in `varlist' {
	replace `var'_2010 = 0 if _merge == 1
}

drop _merge

tab yr_diff, gen(yr_diff_)

local varlist n_jpapers_yr n_jpapers1_yr n_jpapers9_yr n_jpapers25_yr n_jpapers10_yr n_jcite_yr n_jcite_yr2

foreach var in `varlist' {
	forvalues i = 1/21 {		
		gen `var'_2010_yr`i' = `var'_2010 * yr_diff_`i'
		label var `var'_2010_yr`i' "`var'_2010 * yr_diff_`i'"
	}	
}
*/

save "$data_path/psInfo_scopus_pubs_yr_66_75.dta", replace


*############################################################################### 
*
*            1966-1975 cohorts: redefine event study-related vars for DD
*
*############################################################################### 

use "$data_path/psInfo_scopus_pubs_yr_66_75.dta", clear

*--- dropped event study-related vars for DDD

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


save "$data_path/psInfo_scopus_pubs_yr_66_75_DD.dta", replace

