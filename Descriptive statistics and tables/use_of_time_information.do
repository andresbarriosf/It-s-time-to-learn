clear all
set more off
cap log close

log using "$log/use_of_time_information.log", text replace

use "$d/BASE_USUARIO_corregida.dta", clear
svyset VarUnit [pw=wgt2], strata(VarStrat) singleunit(certainty)

generate edu_categories = 0 if d12_1_1 >= 1  & d12_1_1 <= 12
replace  edu_categories = 1 if d12_1_1 >= 13 & d12_1_1 <= 15

bys id_hogar: gen id = _n

*** Identify the number of children per household between 5-14:
generate children518 = c14_1_1 >= 5 & c14_1_1 <= 18 
bys id_hogar: egen children_school518 = total(children518)

*** Lets compute time spent on homework support:

gen d_n38_1_1 = (n38_1_1 == 1) if n38_1_1 != 96
gen d_n38_2_1 = (n38_2_1 == 1) if n38_2_1 != 96
gen d_n45_1_1 = (n45_1_1 == 1) if n45_1_1 != 96
gen d_n45_2_1 = (n45_2_1 == 1) if n45_2_1 != 96

egen total_hw_support = rowmax(d_n38_1_1 d_n38_2_1 d_n45_1_1 d_n45_2_1)
drop d_n38_1_1 d_n38_2_1 d_n45_1_1 d_n45_2_1

replace n38_1_2 = 0 if n38_1_1 == 2
replace n38_2_2 = 0 if n38_2_1 == 2
replace n38_1_2 = . if n38_1_2 == . | n38_1_2 == 96
replace n38_2_2 = . if n38_2_2 == . | n38_2_2 == 96

replace n45_1_2 = 0 if n45_1_1 == 2
replace n45_2_2 = 0 if n45_2_1 == 2
replace n45_1_2 = . if n45_1_2 == . | n45_1_2 == 96
replace n45_2_2 = . if n45_2_2 == . | n45_2_2 == 96

gen total_thw_support         = n38_1_2 + n38_2_2 + n45_1_2 + n45_2_2
gen total_thw_support_week    = n38_1_2 + n45_1_2
gen total_thw_support_weekend = n38_2_2 + n45_2_2

*** Lets compute time spent on tutoring

gen d_r21_1_1 = (r21_1_1 == 1) if r21_1_1 != 96
gen d_r21_2_1 = (r21_2_1 == 1) if r21_2_1 != 96
egen total_tutoring = rowmax(d_r21_1_1 d_r21_2_1)
drop d_r21_1_1 d_r21_2_1

replace r21_1_2 = 0 if r21_1_1 == 2
replace r21_2_2 = 0 if r21_2_1 == 2
replace r21_1_2 = . if r21_1_2 == .  | r21_1_2 == 96
replace r21_2_2 = . if r21_2_2 == .  | r21_2_2 == 96

gen total_tutoring_t         =  r21_1_2 + r21_2_2
gen total_tutoring_t_week    =  r21_1_2
gen total_tutoring_t_weekend =  r21_2_2

*** Identify household head and spouse:
gen household_head = (c12_1_1 == 1)   if c12_1_1 != 96
gen spouse		   = (c12_1_1 == 2)   if c12_1_1 != 96
gen female		   = (c13_1_1 == 2)   if c13_1_1 != 96

generate edu = edu_categories if household_head == 1 | spouse == 1
bys id_hogar: egen edu_categories2 = max(edu)

*** II. Parental Support and Tutoring by HH. Education
svy: reg total_hw_support i.edu_categories2  if  children_school518 > 0 & (household_head == 1 | spouse == 1)
estimate store support_1

svy: mean total_hw_support if  children_school518 > 0 & (household_head == 1 | spouse == 1) & edu_categories2 == 0
svy: mean total_hw_support if  children_school518 > 0 & (household_head == 1 | spouse == 1) & edu_categories2 == 1

svy: reg total_thw_support i.edu_categories2 if  children_school518 > 0 & (household_head == 1 | spouse == 1)
estimate store support_2

svy: mean total_thw_support if  children_school518 > 0 & (household_head == 1 | spouse == 1) & edu_categories2 == 0
svy: mean total_thw_support if  children_school518 > 0 & (household_head == 1 | spouse == 1) & edu_categories2 == 1

** Tutoring
svy: reg total_tutoring i.edu_categories2 if  c14_1_1 >= 12 & c14_1_1 <= 18
estimate store tutoring_1

svy: mean total_tutoring if  c14_1_1 >= 12 & c14_1_1 <= 18 & edu_categories2 == 0
svy: mean total_tutoring if  c14_1_1 >= 12 & c14_1_1 <= 18 & edu_categories2 == 1

svy: reg total_tutoring_t i.edu_categories2 if c14_1_1 >= 12 & c14_1_1 <= 18
estimate store tutoring_2

svy: mean total_tutoring_t if  c14_1_1 >= 12 & c14_1_1 <= 18 & edu_categories2 == 0
svy: mean total_tutoring_t if  c14_1_1 >= 12 & c14_1_1 <= 18 & edu_categories2 == 1


*** III. Homework by FSD
*** Lets compute time spent on homework

gen d_r22_1_1 = (r22_1_1 == 1) if r22_1_1 != 96
gen d_r22_2_1 = (r22_2_1 == 1) if r22_2_1 != 96

egen total_hw = rowmax(d_r22_1_1 d_r22_2_1)
drop d_r22_1_1 d_r22_2_1


replace r22_1_2 = 0 if r22_1_1 == 2
replace r22_2_2 = 0 if r22_2_1 == 2
replace r22_1_2 = 0 if r22_1_2 == .  | r22_1_2 == 96
replace r22_2_2 = 0 if r22_2_2 == .  | r22_2_2 == 96
gen total_hw_t = r22_1_2 + r22_2_2

*** Homework by FSD: 
gen fsd = d15_1_1 == 3 & d14_1_1 == 1
replace fsd = . if d15_1_1  > 3
replace fsd = . if d14_1_1  > 1

svy: reg r22_1_2 i.fsd if c14_1_1 >= 12 & c14_1_1 <= 18
svy: reg r22_2_2 i.fsd if c14_1_1 >= 12 & c14_1_1 <= 18

svy: mean r22_1_2 if  c14_1_1 >= 12 & c14_1_1 <= 18 & fsd == 0
svy: mean r22_1_2 if  c14_1_1 >= 12 & c14_1_1 <= 18 & fsd == 1

svy: mean r22_2_2 if  c14_1_1 >= 12 & c14_1_1 <= 18 & fsd == 0
svy: mean r22_2_2 if  c14_1_1 >= 12 & c14_1_1 <= 18 & fsd == 1


log close
