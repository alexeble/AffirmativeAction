/*

data cleaning: CNKI scholars

input files: mostly from "D:\data\CNKI_author2\_all"
(1) authorInfo.dta
(2) data_author_id.dta
(3) data_author_name.dta
(4) data_author_wkunit.dta

output files:
(1) author_wkunit_psInfo2.dta

The code is based on "CNKI_author_grant_prep.do"

* Edited by Alex 2025-06-27. Works.

*/

*############################################################################### 
*
*                  authors' work unit information
*
*############################################################################### 

*############### link author name to institution id
* some institutions are dropped in merging (_merge==1) because they are not documented in the NSFC system
* in most cases, these institutions are companies/govt./research institutions that have a very small number of researchers

use "$raw_data_path/data_author_name.dta", clear

merge n:1 paperid author_wkunit_numid using "$raw_data_path/data_author_wkunit.dta"
keep if _merge == 3
drop _merge

/*

    Result                           # of obs.
    -----------------------------------------
    not matched                     1,233,241
        from master                 1,000,731  (_merge==1)
        from using                    232,510  (_merge==2)

    matched                         2,901,756  (_merge==3)
    -----------------------------------------

*/

drop author_wkunit_numid id

*--- keep the first one if one author has multiple affiliations in one paper

sort paperid author_cnname
by paperid author_cnname: gen count = _n
keep if count == 1  // 3,529 observations deleted; 0.1%
drop count

rename author_cnname author_name

*====== institution type

merge n:1 wkunit_id2 using "$raw_data_path/institution_type.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                           344
        from master                         0  (_merge==1)
        from using                        344  (_merge==2)

    Matched                         2,898,227  (_merge==3)
    -----------------------------------------
*/

keep if _merge == 3
drop _merge

*====== institution's NSFC id
/* count if wkunit_nsfcid == "999" // 166,440 obs have no NSFC ids  */

merge n:1 wkunit_id2 using "$raw_data_path/wkunit_numid_nsfcid.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                           344
        from master                         0  (_merge==1)
        from using                        344  (_merge==2)

    Matched                         2,898,227  (_merge==3)
    -----------------------------------------
*/

keep if _merge == 3
drop _merge

save "$temp_data_path/author_wkunit.dta", replace


*############### match authors' gender/birth year information with their work unit information
* because some institutions are dropped in previous merging, we have some unmatched obs (_merge==1)

use "$raw_data_path/authorInfo.dta", clear

merge 1:1 paperid author_name using "$temp_data_path/author_wkunit.dta"
keep if _merge == 3
drop _merge

/*
    Result                           # of obs.
    -----------------------------------------
    not matched                     2,244,647
        from master                   229,150  (_merge==1)
        from using                  2,015,497  (_merge==2)

    matched                           882,730  (_merge==3)
    -----------------------------------------
*/

gen female = 1 if author_gender == "女"
replace female = 0 if author_gender == "男"
drop author_gender

gen publish_year = substr(paperid, 5, 4)
destring publish_year, replace
label var publish_year "year of publishing"

save "$temp_data_path/author_wkunit_psInfo_tmp.dta", replace

*====== further merged with authors' field information

*--- derive authors' field information

use "$raw_data_path/data_author_id.dta", clear

drop author_numid

merge n:1 paperid using "$raw_data_path/cnki_paper_field.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                        49,556
        from master                     7,609  (_merge==1)
        from using                     41,947  (_merge==2)

    Matched                         3,836,375  (_merge==3)
    -----------------------------------------
*/

keep if _merge == 3
drop _merge

save "$temp_data_path/author_field_tmp.dta", replace

*--- merge 

use "$temp_data_path/author_wkunit_psInfo_tmp.dta", clear

merge 1:1 paperid author_name using "$temp_data_path/author_field_tmp.dta"

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     2,982,329
        from master                    14,342  (_merge==1)
        from using                  2,967,987  (_merge==2)

    Matched                           868,388  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2
drop _merge

save "$temp_data_path/author_wkunit_psInfo.dta", replace

*############### further match with author id

use "$temp_data_path/author_wkunit_psInfo.dta", clear

merge 1:1 paperid author_name using "$raw_data_path/data_author_id.dta"
keep if _merge == 3
drop _merge

/*
    Result                           # of obs.
    -----------------------------------------
    not matched                     2,986,916
        from master                    12,831  (_merge==1)
        from using                  2,974,085  (_merge==2)

    matched                           869,899  (_merge==3)
    -----------------------------------------
*/

save "$temp_data_path/author_wkunit_psInfo_id.dta", replace

*--- identify migrants: same author ids ("numid"") but different affiliation ids ("wkunit_id2")
* a small proportion of cases may not be migrants: they may study in one institution and publish as students, then work in another institution
* keep migrant authors' all affiliations, instead of dropping the other affiliations of migrants

use "$temp_data_path/author_wkunit_psInfo_id.dta", clear

sort author_numid wkunit_id2 publish_year // in order to choose the earliest migration info
by author_numid wkunit_id2: gen count = _n
keep if count == 1
drop count

sort author_numid
by author_numid: gen count = _N

gen migrant = 0
replace migrant = 1 if count >= 2
label var migrant "dummy for being a migrant: based on CNKI data"
drop count

*drop paperid publish_year
drop paperid

label var author_birthyr "year of birth"
label var author_wkunit_name2 "name of institution in Chinese"
label var wkunit_id2 "numeric id of institution"
label var author_numid "unique numeric id of author in CNKI"
label var wkunit_nsfcid "string id of institution in the NSFC system"

*- turn author string id to numeric id

replace author_numid = subinstr(author_numid,"\n","",.)  // nonnumeric string
destring author_numid, gen(author_numid2)

save "$temp_data_path/author_wkunit_psInfo_mig.dta", replace

*====== NSFC record information

*--- NSFC records
* drop obs with same names in the same institution in order to match with author information

use "$raw_data_path/perinfo_nsfc.dta", clear

sort author_name wkunit_nsfcid
by author_name wkunit_nsfcid: gen count = _n

/*

. tab count

      count |      Freq.     Percent        Cum.
------------+-----------------------------------
          1 |  1,692,629       93.52       93.52
          2 |     86,597        4.78       98.31
          3 |     18,575        1.03       99.34
          4 |      6,280        0.35       99.68
          5 |      2,769        0.15       99.84
          6 |      1,398        0.08       99.91
          7 |        723        0.04       99.95
          8 |        382        0.02       99.97
          9 |        209        0.01       99.99
         10 |        111        0.01       99.99
         11 |         75        0.00      100.00
         12 |         41        0.00      100.00
         13 |         16        0.00      100.00
         14 |          9        0.00      100.00
         15 |          5        0.00      100.00
         16 |          1        0.00      100.00
------------+-----------------------------------
      Total |  1,809,820      100.00

*/

keep if count == 1
keep author_name wkunit_nsfcid

save "$temp_data_path/author_nsfc_record.dta", replace

*--- merge with the CNKI author information

use "$temp_data_path/author_wkunit_psInfo_mig.dta", clear

merge n:1 author_name wkunit_nsfcid using "$temp_data_path/author_nsfc_record.dta" // using "n:1" instead of "1:1" because a small number of authors have different wkunit_id2 that belong to the same wkunit_nsfcid

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                     1,784,601
        from master                   288,815  (_merge==1)
        from using                  1,495,786  (_merge==2)

    Matched                           204,781  (_merge==3)
    -----------------------------------------
*/

drop if _merge == 2

gen nsfc_record = 0 if _merge == 1
replace nsfc_record = 1 if _merge == 3
label var nsfc_record "dummy for CNKI author recorded in the NSFC system"

drop _merge

save "$data_path/author_wkunit_psInfo2.dta", replace

