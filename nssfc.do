/*

document the NSSFC policy effect

*/


/* ----------------------------------------------------------- */
/*       youth/general grants: female share over time          */
/* ----------------------------------------------------------- */

use "$raw_data_path/nssfc_pj.dta", clear

collapse (mean) female, by(youth_grant year)

twoway (connected female year if youth_grant == 1 & year >= 2004, color(gs0) msymbol(O) lpattern(solid))  ///
    (connected female year if youth_grant == 0 & year >= 2004, color(gs10) msymbol(Th) lpattern(dash)), ///
    legend(order(1 "Young scientist grant" 2 "General grant") pos(6) cols(2) region(lstyle(solid)) size(small)) ///
    xlabel(2004(5)2024,labsize(small)) ///
	ylabel(0.1(0.1)0.5,labsize(small)) ///
    xline(2023.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Year", margin(small)) ///
	ytitle("Female share")	

graph export "$figure_path/Fig_female_share_grant_awardee_nssfc.eps", replace
graph export "$figure_path/Fig_female_share_grant_awardee_nssfc.pdf", replace   


/* ----------------------------------------------------------- */
/*   youth + general grants combined: female share over time   */
/* ----------------------------------------------------------- */

use "$raw_data_path/nssfc_pj.dta", clear

collapse (mean) female, by(year)

twoway (connected female year if year >= 2004, color(gs0) msymbol(O) lpattern(solid)),  ///
    legend(off) ///
    xlabel(2004(5)2024,labsize(small)) ///
	ylabel(0.1(0.1)0.4,labsize(small)) ///
    xline(2023.5, lcolor(red%60) lpattern(solid)) ///
    xtitle("Year", margin(small)) ///
	ytitle("Female share")	

graph export "$figure_path/Fig_female_share_grant_awardee_nssfc_total.eps", replace
graph export "$figure_path/Fig_female_share_grant_awardee_nssfc_total.pdf", replace   



