********************************************************************************
***  CREATE TABLES WITH LEVELS OF AUTONOMY - PISA
********************************************************************************
clear all
set more off 

use "$d/pisa_autonomy.dta"

global vars_stat teacher_hire teacher_fire starting_salaries increase_salaries formulate_budget allocate_budget textbook_use course_content course_offered
 
tab school_type
tab school_type if primary_education == 1 // use this info for the n.obs. in the following tables
 
 preserve
 collapse (mean) $vars_stat [pw=w_fschwt], by(school_type)
 
 label var teacher_hire      "Hire teachers"
 label var teacher_fire      "Fire teachers"
 label var starting_salaries "Set starting salaries"
 label var increase_salaries "Set salaries' increases"
 label var formulate_budget  "Formulate budget"
 label var allocate_budget   "Allocate budget"
 label var textbook_use      "Choose textbooks"
 label var course_content    "Choose course content" 
 label var course_offered    "Choose course offer" 
 
 bys school_type: eststo: estpost tabstat $vars_stat, columns(statistics) statistics(mean)
 esttab est1 est2 using "$tex_pisa/stats_all.tex", cells("mean(fmt(2))") label replace
 restore
 
 preserve
 keep if primary_education == 1
 collapse (mean) $vars_stat [pw=w_fschwt], by(school_type) 
 
 label var teacher_hire      "Hire teachers"
 label var teacher_fire      "Fire teachers"
 label var starting_salaries "Set starting salaries"
 label var increase_salaries "Set salaries' increases"
 label var formulate_budget  "Formulate budget"
 label var allocate_budget   "Allocate budget"
 label var textbook_use      "Choose textbooks"
 label var course_content    "Choose course content" 
 label var course_offered    "Choose course offer" 
 
 bys school_type: eststo: estpost tabstat $vars_stat, columns(statistics) statistics(mean)
 esttab est3 est4 using "$tex_pisa/stats_primary_school.tex", cells("mean(fmt(2))") label replace
 restore

