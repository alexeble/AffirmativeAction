/*

 Descriptive analysis

* Edited by Alex 2025-06-27.

*/

/* ------------------------------------- */
/*                key facts              */
/* ------------------------------------- */

* number of scholars from the CNKI

use "$data_path/author_wkunit_psInfo2.dta", clear

unique author_numid2  // 461803 obs
unique wkunit_id2  // 2285 obs

* number of grants and awardees

use "$raw_data_path/grants_1986-2021.dta", clear

tab pj_type // general grants: 279,170; youth grants: 210,464

* number of obs for cohorts

use "$data_path/grants_researcher_year.dta", clear

unique author_numid2 if author_birthyr >= 1966 & author_birthyr <= 1975  // [1966, 1975]: 52,562 obs

unique author_numid2 if author_birthyr >= 1961 & author_birthyr <= 1981 & female != .  // [1961, 1981]: 135,667 obs
unique author_numid2 if author_birthyr >= 1966 & author_birthyr <= 1975 & female == 1  // female [1966, 1975]: 16,029 obs
unique author_numid2 if author_birthyr >= 1970 & author_birthyr <= 1971 & female == 1  // female [1970, 1971]: 3,136 obs

* selection of journals with detailed author info

use "$raw_data_path/journals.dta", clear

local varlist if_fh if_zh core_journal start_year n_issues
foreach var in `varlist' {
	ttest `var', by(author_info)
}

* number of obs from admin data on NSFC grant awardees and participants

use "$raw_data_path/perinfo_nsfc.dta", clear

unique personid if title <= 9  // 644,180 obs
unique wkunit_nsfcid if title <= 9  // 2415 obs

* rate of scientists recorded in the Scopus

use "$raw_data_path/scopus_pub_66_75.dta", clear

unique prof_id // 37657 --> 0.716 = 37657/52562

* Female scientists in our main analysis sample received 26.6% of all NSFC young scientist grants in the first year of policy implementation
* "2011年共有5676位女性科研人员获得青年科学基金项目资助，其中36—40周岁女性获批1829项"
* source:于璇, 高瑞平. 科学基金助力女性科研人员成长：政策、成效与展望. 中国科学院院刊, 2023, 38(2): 265-276

use "$data_path/author_wkunit_psInfo_grant_young.dta", clear

count if author_birthyr >= 1971 & author_birthyr <= 1975 & pj_year == 2011  // 486 -- 0.266 = 486/1829

* shares of associate/full professors among the 1970-1975 cohorts during the 2001-2005 period

use "$data_path/grants_researcher_year_66_75.dta", clear

sum assoc_prof_status if author_birthyr >= 1970 & author_birthyr <= 1975 & female == 1 & yr_diff < -5 // 0.038
sum full_prof_status if author_birthyr >= 1970 & author_birthyr <= 1975 & female == 1 & yr_diff < -5 // 0.001

* age of promotion to full professorship

use "$data_path/grants_researcher_year_66_75.dta", clear

gen age_fullprof = full_prof_year - author_birthyr

drop if age_fullprof < 25 // 273 obs: 0.06%

sum age_fullprof // mean: 43.89

tab age_fullprof

/*

age_fullpro |
          f |      Freq.     Percent        Cum.
------------+-----------------------------------
         25 |        126        0.03        0.03
         26 |         84        0.02        0.05
         27 |        252        0.05        0.10
         28 |        399        0.09        0.19
         29 |        504        0.11        0.30
         30 |        357        0.08        0.37
         31 |        714        0.16        0.53
         32 |        504        0.11        0.64
         33 |      1,260        0.27        0.91
         34 |      2,394        0.52        1.43
         35 |      3,885        0.84        2.28
         36 |      6,237        1.35        3.63
         37 |     11,025        2.39        6.03
         38 |     15,960        3.47        9.49
         39 |     22,638        4.92       14.41
         40 |     29,421        6.39       20.80
         41 |     33,936        7.37       28.17
         42 |     41,328        8.98       37.15
         43 |     41,433        9.00       46.15
         44 |     42,357        9.20       55.35
         45 |     43,302        9.41       64.76
         46 |     40,257        8.75       73.50
         47 |     33,201        7.21       80.72
         48 |     25,641        5.57       86.29
         49 |     20,034        4.35       90.64
         50 |     15,120        3.28       93.92
         51 |     11,025        2.39       96.32
         52 |      7,203        1.56       97.88
         53 |      5,250        1.14       99.02
         54 |      3,024        0.66       99.68
         55 |      1,470        0.32      100.00
------------+-----------------------------------
      Total |    460,341      100.00

*/

* proportion of becoming associate or full professor in 2021, the final year of our sample period

use "$data_path/grants_researcher_year_66_75.dta", clear

tab1 assoc_prof_status full_prof_status if year == 2021 // associate professor: 89.69%; full professor: 46.50%

*--- proportion of of the older cohorts (1966–1970) who received general grants before age 35 but never held young scientist grant

use "$data_path/author_wkunit_psInfo_grant_general.dta", clear

keep if gen_grant == 1  // keep general grant awardees

* keep the first general grant record if an individual received > 1 general grant

sort author_numid2 pj_year_g
by author_numid2: gen count = _n
keep if count == 1

* merge young scientist grant information

merge 1:1 author_numid2 using "$data_path/author_wkunit_psInfo_grant_young.dta"
keep if _merge == 3
drop _merge 

* the proportions

tab youth_grant if age_gengrant <= 35 & author_birthyr >= 1966 & author_birthyr <= 1970 & female == 1  // 38.24%
tab youth_grant if age_gengrant <= 35 & author_birthyr >= 1966 & author_birthyr <= 1970 & female == 0  // 60.85%


/* ----------------------------------------------------------- */
/*              NSFC's amount of funding over time             */
/* ----------------------------------------------------------- */

*--- before 2000: calculated from individual grants due to lack of statistics

use "$raw_data_path/grants_1986-2021.dta", clear

sort pj_year
by pj_year: egen tot_fund = sum(pj_money)
replace tot_fund = tot_fund/100000
label var tot_fund "annual amount of funding (in billions)"

by pj_year: gen count = _n
keep if count == 1
rename pj_year year
keep year tot_fund
keep if year < 2000

*--- after 2000: statistics from NSFC annual reports

append using "$raw_data_path/tot_fund_2000_2021.dta"

*--- figure

twoway (connected tot_fund year, color(gs0) msymbol(O) lpattern(solid)),  ///
    legend(off) ///
    xlabel(1986(5)2021,labsize(4)) ///
	ylabel(0(10)40,labsize(4)) ///
    xline(2010.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Year", margin(small) size(4)) ///
	ytitle("Total amount of NSFC funding", size(4))	

graph export "$figure_path/Fig_tot_fund_amount_over_time.eps", replace
graph export "$figure_path/Fig_tot_fund_amount_over_time.pdf", replace   


/* ---------------------------------------------------------------- */
/*    prop. of youth grant awarddes among general grant awardees    */
/* ---------------------------------------------------------------- */
* low bound because we have no information on youth grant application behaviors of general grant awardees
* those general grant awardees who also obtained youth grants have certainly applied for youth grants before
* those general grant awardees who did not obtain youth grants may have applied for youth grants before

use "$data_path/author_wkunit_psInfo_grant.dta", clear

local cond1 (((age_gengrant <= 35 & pj_year_g >= 2006 & pj_year_g < 2011) | (age_gengrant <= 40 & pj_year_g >= 2011)) & female == 1) // female
local cond2 (age_gengrant <= 35 & pj_year_g >= 2006 & female == 0) // male

tab youth_grant if `cond1' // female: 73.53%
tab youth_grant if `cond2' // male: 74.35%
tab youth_grant if `cond1' | `cond2' // female + male: 74.06%

collapse (mean) youth_grant if `cond1' | `cond2', by(pj_year_g female)

twoway (connected youth_grant pj_year_g if female == 1, color(gs0) msymbol(O) lpattern(solid))  ///
    (connected youth_grant pj_year_g if female == 0, color(gs10) msymbol(Th) lpattern(dash)), ///
    legend(order(1 "Female" 2 "Male") pos(6) cols(2) region(lw(0)) size(4)) ///
    xlabel(2006(5)2021,labsize(4)) ///
	ylabel(0(0.5)1,labsize(4)) ///
    xline(2010.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Year", margin(small) size(4)) ///
	ytitle("Proportion of youth grant awardees", size(4))	

graph export "$figure_path/Fig_prop_youth_grant_awardee_among_gen_awardees.eps", replace
graph export "$figure_path/Fig_prop_youth_grant_awardee_among_gen_awardees.pdf", replace  


/* ----------------------------------------------------------- */
/*            youth grants: female share over time             */
/* ----------------------------------------------------------- */

use "$raw_data_path/female_prop_nsfc_grants_1986_2021.dta", clear

twoway (connected female_youth year if year >= 2001, color(gs0) msymbol(O) lpattern(solid)),  ///
    legend(off) ///
    xlabel(2001(5)2021,labsize(4)) ///
	ylabel(0.2(0.1)0.5,labsize(4)) ///
    xline(2010.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Year", margin(small)) ///
	ytitle("Proportion of awardees who are female")	

graph export "$figure_path/Fig_female_share_youth_grant_awardee.eps", replace
graph export "$figure_path/Fig_female_share_youth_grant_awardee.pdf", replace   


/* ----------------------------------------------------------- */
/*            general grants: female share over time           */
/* ----------------------------------------------------------- */

use "$raw_data_path/female_prop_nsfc_grants_1986_2021.dta", clear

twoway (connected female_general year if year >= 2001, color(gs0) msymbol(O) lpattern(solid)),  ///
    legend(off) ///
    xlabel(2001(5)2021,labsize(4)) ///
	ylabel(0.1(0.1)0.3,labsize(4)) ///
    xline(2010.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Year", margin(small)) ///
	ytitle("Proportion of awardees who are female")	

graph export "$figure_path/Fig_female_share_gen_grant_awardee.eps", replace
graph export "$figure_path/Fig_female_share_gen_grant_awardee.pdf", replace   


/* ----------------------------------------------------------- */
/*      youth + general grants: female share over time         */
/* ----------------------------------------------------------- */

use "$raw_data_path/female_prop_nsfc_grants_1986_2021.dta", clear

twoway (connected female_youth year, color(gs0) msymbol(O) lpattern(solid)) ///
	(connected female_general year, color(gs10) msymbol(Th) lpattern(dash)),  ///
    legend(order(1 "Young scientist grant" 2 "General grant") pos(6) cols(2) size(4)) ///
    xlabel(1986(5)2021,labsize(4)) ///
	ylabel(0.1(0.1)0.4,labsize(4)) ///
    xline(2010.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Year", margin(small) size(4)) ///
	ytitle("Proportion of awardees who are female", size(4))

graph export "$figure_path/Fig_female_share_youth_gen_grant_awardee.eps", replace
graph export "$figure_path/Fig_female_share_youth_gen_grant_awardee.pdf", replace  


/* ----------------------------------------------------------- */
/*            youth grants: by cohorts and by gender           */
/* ----------------------------------------------------------- */

use "$data_path/author_wkunit_psInfo_grant_young.dta", clear

collapse (mean) youth_grant if author_birthyr >= 1961 & author_birthyr <= 1981 & female != ., by(author_birthyr female)

twoway (connected youth_grant author_birthyr if female == 1, color(gs0) msymbol(O) lpattern(solid))  ///
    (connected youth_grant author_birthyr if female == 0, color(gs10) msymbol(Th) lpattern(dash)), ///
    legend(order(1 "Female" 2 "Male") pos(6) cols(2) region(lw(0)) size(4)) ///
    xlabel(1961(5)1981,labsize(4)) ///
	ylabel(0(0.1)0.3,labsize(4)) ///
    xline(1970.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Birth cohort", margin(small) size(4)) ///
	ytitle("Proportion who win" "the young scientist grant", size(4))	

graph export "$figure_path/Fig_prop_youth_grant_awardee_by_gender.eps", replace
graph export "$figure_path/Fig_prop_youth_grant_awardee_by_gender.pdf", replace   


/* ----------------------------------------------------------- */
/*          general grants: by cohorts and by gender           */
/* ----------------------------------------------------------- */

*====== proportion of general grant awardees

use "$data_path/author_wkunit_psInfo_grant_general.dta", clear

collapse (mean) gen_grant if author_birthyr >= 1961 & author_birthyr <= 1981 & female != ., by(author_birthyr female)

twoway (connected gen_grant author_birthyr if female == 1, color(gs0) msymbol(O) lpattern(solid))  ///
    (connected gen_grant author_birthyr if female == 0, color(gs10) msymbol(Th) lpattern(dash)), ///
    legend(order(1 "Female" 2 "Male") pos(6) cols(2) region(lw(0)) size(small)) ///
    xlabel(1961(5)1981,labsize(4)) ///
	ylabel(0(0.2)0.6,labsize(4)) ///
    xline(1970.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Birth cohort", margin(small) size(4)) ///
	ytitle("Proportion of general grant awardees", size(4))	

graph export "$figure_path/Fig_prop_gen_grant_awardee_by_gender.eps", replace
graph export "$figure_path/Fig_prop_gen_grant_awardee_by_gender.pdf", replace   

*====== number of general grant awardees

use "$data_path/author_wkunit_psInfo_grant_general.dta", clear

collapse (mean) n_gengrants if author_birthyr >= 1961 & author_birthyr <= 1981 & female != ., by(author_birthyr female)

twoway (connected n_gengrants author_birthyr if female == 1, color(gs0) msymbol(O) lpattern(solid))  ///
    (connected n_gengrants author_birthyr if female == 0, color(gs10) msymbol(Th) lpattern(dash)), ///
    legend(order(1 "Female" 2 "Male") pos(6) cols(2) region(lw(0)) size(4)) ///
    xlabel(1961(5)1981,labsize(4)) ///
	ylabel(0(0.5)2,labsize(4)) ///
    xline(1970.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Birth cohort", margin(small) size(4)) ///
	ytitle("Number of general grants", size(4))	

graph export "$figure_path/Fig_num_gen_grants_by_gender.eps", replace
graph export "$figure_path/Fig_num_gen_grants_by_gender.pdf", replace   


/* ----------------------------------------------------------- */
/*         general grants: age group shares over time          */
/* ----------------------------------------------------------- */

*###### all awardees: preferred

use "$raw_data_path/age_general_grant_awardees.dta", clear

twoway (connected age_35_share year, color(gs6) msymbol(Th) lpattern(dash))  ///
    (connected age_36_40_share year, color(gs0) msymbol(O) lpattern(solid)) ///
    (connected age_41_share year, color(gs10) msymbol(Dh) lpattern(dash)), ///
    legend(order(1 "Age <= 35" 2 "Age [36,40]" 3 "Age > 40") pos(6) cols(3) region(lw(0)) size(4)) ///
    xlabel(2005(2)2021,labsize(4)) ///
	ylabel(0(0.2)0.8,labsize(4)) ///
    xline(2010.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Year", margin(small) size(4)) ///
	ytitle("Share of awardees in age range", size(4))	

graph export "$figure_path/Fig_age_general_awardee.eps", replace
graph export "$figure_path/Fig_age_general_awardee.pdf", replace   


*###### awardees [31,45]

use "$raw_data_path/age_general_grant_awardees2.dta", clear

twoway (connected age_31_35_share year, color(gs6) msymbol(Th) lpattern(dash))  ///
    (connected age_36_40_share year, color(gs0) msymbol(O) lpattern(solid)) ///
    (connected age_41_45_share year, color(gs10) msymbol(Dh) lpattern(dash)), ///
    legend(order(1 "Age [31,35]" 2 "Age [36,40]" 3 "Age [41,45]") pos(6) cols(3) region(lw(0)) size(4)) ///
    xlabel(2005(2)2021,labsize(4)) ///
	ylabel(0(0.1)0.4,labsize(4)) ///
    xline(2010.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Year", margin(small) size(4)) ///
	ytitle("Share", size(4))	

graph export "$figure_path/Fig_age_general_awardee2.eps", replace
graph export "$figure_path/Fig_age_general_awardee2.pdf", replace   


