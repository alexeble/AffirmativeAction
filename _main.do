/*

This is the do file to execute all codes for empirical analysis

The paper: Can Afrmative Action Remedy Gender Inequality in Science?

consider the robustness check by limiting the analysis to those with NSFC records

* Edited by Alex 2025-06-27.

Where we are as of that evening:
- Updated all the data with data from june 5 (used terminal to unzip, code is unzip /Users/ae2566/Library/CloudStorage/Dropbox/@\ Alex\'s\ stuff/Data/china_nsfc_aa/data/raw/raw_data20250605.zip -d /Users/ae2566/Library/CloudStorage/Dropbox/
- Worked through to descriptive analysis.do
- 
*/

/*

* Feng's preamble

* change the file path accordingly
global filepath = "D:\jianguo\NSFC_paper\NSFC_youth_fund_age_limit\work"

global code_path = "$filepath/code\replication"
global data_path = "$filepath/data\cleaned"
global figure_path = "$filepath/output\figures"
global table_path = "$filepath/output\tables"
global raw_data_path = "$filepath/data\raw"
global temp_data_path = "$filepath/data\temp"
global temp_output_path = "$filepath/output\temp_output"

*/

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

* preparing grant-related dataset: individual-year level
do "$code_path/prep_grant2.do"

* preparing pub-related dataset
do "$code_path/prep_pub.do"


*###############################################################################
*                      
*                         Descriptive Analysis
*
*###############################################################################

* sample representativeness
do "$code_path/sample_representativeness.do"

* descriptives
do "$code_path/descriptive_analysis.do"


*###############################################################################
*                      
*                       Empirical Identification
*
*###############################################################################

* balancing tests
do "$code_path/balancing_test.do"

* compare pre-trends of the outcomes of females and males: DD
do "$code_path/results_DD.do"

* compare pre-trends of the outcomes of females and males: DD; 1961-1980 cohorts
do "$code_path/results_61_80.do"


*###############################################################################
*                      
*         How the Affirmative action policy Affects Grant Outcomes
*
*###############################################################################

* youth grant outcomes
do "$code_path/youth_grants.do"

* general grant outcomes
do "$code_path/gen_grants.do"

* youth + general grant outcomes
do "$code_path/youth_gen_grants.do"


*###############################################################################
*                      
*      How the Affirmative action policy Affects Scientific Productivity
*
*###############################################################################

* overall pub outcomes
do "$code_path/pub_overall.do"

* STOPPED HERE. pub_het ready to go. 

* pub outcomes: heterogeneity
do "$code_path/pub_het.do"


*###############################################################################
*                      
*         How the Affirmative action policy Affects Career Trajectories
*
*###############################################################################

* overall career outcomes
do "$code_path/career_overall.do"

* career outcomes: heterogeneity
do "$code_path/career_het_20y.do"


*###############################################################################
*                      
*                              Discussions
*
*###############################################################################

* nssfc outcomes
do "$code_path/nssfc.do"

* STOPPED HERE. Doesn't seem to work. Come back.

* focusing on associate professors before the policy
do "$code_path/assoc_prof_sample.do"

* application behaviors of those who were associate professors before the policy
do "$code_path/discussion.do"



