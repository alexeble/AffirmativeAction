/*

This is the do file to execute all codes for empirical analysis

The paper: Can Afrmative Action Remedy Gender Inequality in Science?

consider the robustness check by limiting the analysis to those with NSFC records

*/

* change the file path accordingly
*global filepath = "D:\jianguo\NSFC_paper\NSFC_youth_fund_age_limit\work"

* Laptop
*global filepath = "/Users/alexeble/Dropbox/@ Alex's stuff/Data/china_nsfc_aa/"

* Desktop
global filepath = "/Users/ae2566/Library/CloudStorage/Dropbox/@ Alex's stuff/Data/china_nsfc_aa/"

global code_path = "$filepath/code/"
global data_path = "$filepath/data"
global figure_path = "$filepath/output/figures"
global table_path = "$filepath/output/tables"
global temp_data_path = "$filepath/data/temp"
global temp_output_path = "$filepath/output/temp_output"
global raw_data_path = "$filepath/data/raw"

*###############################################################################
*                      
*                         Preparing the datasets
*
*###############################################################################

* preparing CNKI scholar dataset
do "$code_path/prep_CNKI.do"

* preparing grant-related dataset: individual level
do "$code_path/prep_grant.do"

* preparing career-related dataset
do "$code_path/prep_career.do"

* preparing condensed scientist dataset
do "$code_path/prep_grant1point5.do"

* preparing career-related publication dataset 
do "$code_path/prep_pub1.do"

* preparing grant-related dataset: individual-year level
do "$code_path/prep_grant2.do"

* preparing pub-related dataset
do "$code_path/prep_pub2.do"


*###############################################################################
*                      
*                         Descriptive Analysis
*
*###############################################################################

* sample representativeness
do "$code_path/sample_representativeness 2.do"

* descriptives
do "$code_path/descriptive_analysis2.do"
* Error: "variable if_fh not found" - lines 38-40
* Error: "author_wkunit_psInfo_grant.dta not found". Line 112
	* prep_grant.do generates author_wkunit_psInfo_grant_young and 
	* author_wkunit_psInfo_grant_general, but not author_wkunit_psInfo_grant. 



*###############################################################################
*                      
*                       Empirical Identification
*
*###############################################################################

* balancing tests
do "$code_path/balancing_test.do"
* Works fine

* compare pre-trends of the outcomes of females and males: DD
do "$code_path/results_DD.do"
* Works fine

*###############################################################################
*                      
*         How the Affirmative action policy Affects Grant Outcomes
*
*###############################################################################

* youth grant outcomes
do "$code_path/youth_grants.do"
* Works fine

* general grant outcomes
do "$code_path/gen_grants 2.do"
* Works fine

* youth + general grant outcomes
do "$code_path/youth_gen_grants.do"
* Works fine

*###############################################################################
*                      
*      How the Affirmative action policy Affects Scientific Productivity
*
*###############################################################################

* overall pub outcomes
do "$code_path/pub_overall 2.do"
* Works fine

* pub outcomes: heterogeneity
do "$code_path/pub_het 2.do"


*###############################################################################
*                      
*         How the Affirmative action policy Affects Career Trajectories
*
*###############################################################################

* overall career outcomes
do "$code_path/career_overall 3.do"

* career outcomes: heterogeneity
do "$code_path/career_het_20y.do"


*###############################################################################
*                      
*                              Discussions
*
*###############################################################################

* nssfc outcomes
do "$code_path/nssfc.do"

* focusing on associate professors before the policy
do "$code_path/assoc_prof_sample.do"

* application behaviors of those who were associate professors before the policy
do "$code_path/discussion.do"



