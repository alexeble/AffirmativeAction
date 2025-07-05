/*

To link CNKI authors to NSFC grants/Scopus publications/NSFC individual information: individual level

input files: mostly from "D:\data\CNKI_author2\_all"
(1) grants_1986-2021.dta
(2) wkunit_numid.dta
(3) wkunit_numid_nsfcid.dta
(4) wkunit_numid_nsfcid2_2.dta
(5) wkunit_strid_numid.dta
(6) author_wkunit_psInfo2.dta
(7) scholar_mig.dta
(8) scholar_mig_year.dta

output files:
(1) author_wkunit_psInfo_grant.dta


The code is based on "CNKI_author_grant_prep.do"

* Edited by Alex 2025-06-27. Works.

*/


*############################################################################### 
*
*           match author information with NSFC grant information
*
*############################################################################### 

*############### grant information

*--- match affiliation names (including repeated affiliations) with their NSFC string id
* keep only NSFC string id

use "$raw_data_path/wkunit_numid.dta", clear  // include repeated institutions that changed names

merge n:1 wkunit_id2 using "$raw_data_path/wkunit_numid_nsfcid.dta"
keep if _merge == 3  // all matched
drop _merge

drop wkunit_id2

save "$temp_data_path/wkunit_numid_nsfcid2.dta", replace 


*--- append the affiliation string id from NSFC grants: updating both institution names and ids

use "$raw_data_path/wkunit_strid_numid.dta", clear

drop wkunit_id

append using "$temp_data_path/wkunit_numid_nsfcid2.dta"

*- "wkunit_numid_nsfcid2_2.dta": manually added information, see "D:\data\CNKI_author2\wkunits_TOT2.xlsx\sheet-readme"
* mainly repeated institutions that changed names or new research institutions/Honghong or Macau universities: 78 obs

append using "$raw_data_path/wkunit_numid_nsfcid2_2.dta"

* drop repeated obs, keeping repeated institutions that changed names
sort wkunit
by wkunit: gen count = _n
by wkunit: gen count2 = _N
keep if count == count2 // 1996 obs dropped
drop count count2

save "$temp_data_path/wkunit_numid_nsfcid3.dta", replace


*--- match affiliations' NSFC string id with NSFC grants

use "$raw_data_path/grants_1986-2021.dta", clear

merge n:1 wkunit using "$temp_data_path/wkunit_numid_nsfcid3.dta"
drop if _merge == 2
drop _merge

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                         1,321
        from master                       516  (_merge==1)
        from using                        805  (_merge==2)

    matched                           598,273  (_merge==3)
    -----------------------------------------

*/

replace wkunit_nsfcid = "" if wkunit_nsfcid == "999" // 1556 obs changed values

save "$temp_data_path/grants_1986-2021_wkunit_nsfcid.dta", replace

*--- limiting to the youth grant

use "$temp_data_path/grants_1986-2021_wkunit_nsfcid.dta", clear

keep if pj_type == 2

* drop obs with same names in the same institution in order to match with author information

rename pi_name author_name

sort author_name wkunit_nsfcid
by author_name wkunit_nsfcid: gen count = _n
keep if count == 1
drop count

/*

. tab count

      count |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |    208,071       98.86       98.86
          2 |      2,138        1.02       99.88
          3 |        212        0.10       99.98
          4 |         37        0.02      100.00
          5 |          5        0.00      100.00
          6 |          1        0.00      100.00
------------+-----------------------------------
      Total |    210,464      100.00

*/

save "$temp_data_path/youth_grants_1986-2021_wkunit_nsfcid.dta", replace


*--- limiting to the general grant

use "$temp_data_path/grants_1986-2021_wkunit_nsfcid.dta", clear

keep if pj_type == 1

* drop obs with same names in order to match with author information

rename pi_name author_name

sort author_name wkunit_nsfcid pj_year
by author_name wkunit_nsfcid pj_year: gen count = _n
keep if count == 1
drop count

/*

. tab count

      count |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |    278,562       99.78       99.78
          2 |        605        0.22      100.00
          3 |          3        0.00      100.00
------------+-----------------------------------
      Total |    279,170      100.00

*/

save "$temp_data_path/general_grants_1986-2021_wkunit_nsfcid.dta", replace

* keep the first general grant information and number of general grants?
* keep all general grants instead

use "$temp_data_path/general_grants_1986-2021_wkunit_nsfcid.dta", clear

sort author_name wkunit_nsfcid pj_year
by author_name wkunit_nsfcid: gen count = _N
/*
by author_name wkunit_nsfcid: gen count2 = _n
keep if count2 == 1
drop count2
*/
rename count n_gengrants
label var n_gengrants "number of general grants"

local varlist pj_id pj_type pj_year pj_money nsfc_dep
foreach var in `varlist' {
	rename `var' `var'_g
}

save "$temp_data_path/general_grants_1986-2021_wkunit_nsfcid2.dta", replace


*############### match author information with NSFC grants

use "$data_path/author_wkunit_psInfo2.dta", clear

*--- drop obs with same names of the same institution in order to match with NSFC grant information

sort author_name wkunit_nsfcid
by author_name wkunit_nsfcid: gen count = _n
keep if count == 1
drop count

/*

. tab count

      count |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |    480,975       97.44       97.44
          2 |      9,921        2.01       99.45
          3 |      1,652        0.33       99.79
          4 |        509        0.10       99.89
          5 |        217        0.04       99.93
          6 |        119        0.02       99.96
          7 |         73        0.01       99.97
          8 |         45        0.01       99.98
          9 |         28        0.01       99.99
         10 |         19        0.00       99.99
         11 |         12        0.00       99.99
         12 |         10        0.00      100.00
         13 |          7        0.00      100.00
         14 |          4        0.00      100.00
         15 |          2        0.00      100.00
         16 |          2        0.00      100.00
------------+-----------------------------------
      Total |    493,595      100.00
*/

* keep only one obs for each migrant

sort author_numid2
by author_numid2: gen count = _n
keep if count == 1
drop count

save "$temp_data_path/author_wkunit_psInfo2_temp.dta", replace

*--- individual-level dataset with the info on youth grants

use "$temp_data_path/author_wkunit_psInfo2_temp.dta", clear

merge 1:1 author_name wkunit_nsfcid using "$temp_data_path/youth_grants_1986-2021_wkunit_nsfcid.dta"

/* successful matching rate: 0.2017 = 41964/(41964 + 166107)  */
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       575,175
        from master                   409,068  (_merge==1)
        from using                    166,107  (_merge==2)

    Matched                            41,964  (_merge==3)
    -----------------------------------------
*/

gen youth_grant = 0 if _merge == 1
replace youth_grant = 1 if _merge == 3
label var youth_grant "dummy for acquiring a youth grant"

drop if _merge == 2
drop _merge

gen age_grant = pj_year - author_birthyr
label var age_grant "age when being awarded the youth grant"

* revise the dummy for the youth grant awardee based on the age information
* attention: we have 3% missing values on gender

drop if youth_grant == 1 & (age_grant < 25 | (age_grant > 40 & age_grant < .))  // dropping 1,686 obs
drop if youth_grant == 1 & female == 0 & (age_grant > 35 & age_grant <= 40)  // dropping 358 obs
drop if youth_grant == 1 & female == 1 & author_birthyr <= 1970 & (age_grant > 35 & age_grant < .)  // dropping 7 obs

save "$data_path/author_wkunit_psInfo_grant_young.dta", replace

* keep only young grants

use "$data_path/author_wkunit_psInfo_grant_young.dta", clear

rename pj_year year // for later merging

keep if year != .
keep author_numid2 pj_id pj_type year pj_money nsfc_dep youth_grant age_grant

save "$temp_data_path/grant_young_matched.dta", replace

*--- individual-level dataset with the info on general grants

use "$temp_data_path/author_wkunit_psInfo2_temp.dta", clear

merge 1:n author_name wkunit_nsfcid using "$temp_data_path/general_grants_1986-2021_wkunit_nsfcid2.dta"

/* successful matching rate: 0.2920 = 81352/(81352 + 197210)  */
/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                       604,330
        from master                   407,120  (_merge==1)
        from using                    197,210  (_merge==2)

    Matched                            81,352  (_merge==3)
    -----------------------------------------
*/

gen gen_grant = 0 if _merge == 1
replace gen_grant = 1 if _merge == 3
label var gen_grant "dummy for acquiring a general grant"

replace n_gengrants = 0 if n_gengrants == .

drop if _merge == 2
drop _merge

gen age_gengrant = pj_year_g - author_birthyr
label var age_gengrant "age when being awarded a general grant"

* revise the dummy for the youth grant awardee based on the age information

drop if age_gengrant < 25 | (age_gengrant > 70 & age_gengrant < .)  // dropping 1,381 obs
*drop if age_gengrant < age_grant & age_grant < .  // impossible to have general grants before youth grants; dropping 223 obs

save "$data_path/author_wkunit_psInfo_grant_general.dta", replace

* keep only general grants

use "$data_path/author_wkunit_psInfo_grant_general.dta", clear

rename pj_year_g year // for later merging

keep if year != .
keep author_numid2 pj_id_g pj_type_g year pj_money_g nsfc_dep_g n_gengrants gen_grant

save "$temp_data_path/grant_general_matched.dta", replace


/*--- export the 1966-1975 cohort sample

use "$data_path/author_wkunit_psInfo_grant.dta", clear

export excel author_name female author_wkunit_name2 wkunit_nsfcid wkunit_id2 author_numid2 using "D:\cohorts66_75.xlsx" if author_birthyr >= 1966 & author_birthyr <= 1975, firstrow(variables)

*/

/* something wrong when matching?

. tab pj_year_g if author_birthyr == 1971 & female == 1 & pj_year >= 2011

  pj_year_g |      Freq.     Percent        Cum.
------------+-----------------------------------
       2001 |          1        0.33        0.33
       2004 |          1        0.33        0.66
       2006 |          4        1.32        1.99
       2007 |         10        3.31        5.30
       2008 |          9        2.98        8.28
       2009 |         14        4.64       12.91
       2010 |         39       12.91       25.83
       2011 |         15        4.97       30.79
       2012 |         33       10.93       41.72
       2013 |         38       12.58       54.30
       2014 |         34       11.26       65.56
       2015 |         28        9.27       74.83
       2016 |         15        4.97       79.80
       2017 |         16        5.30       85.10
       2018 |         16        5.30       90.40
       2019 |         13        4.30       94.70
       2020 |          8        2.65       97.35
       2021 |          8        2.65      100.00
------------+-----------------------------------
      Total |        302      100.00

 */


