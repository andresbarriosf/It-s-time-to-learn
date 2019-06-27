clear all
cap log close
set more off

log using "$log/sum_stat.log", text replace

use "$d/fsd_final_dataset_for_analysis_replication.dta", clear

global control0A  

reghdfe reading_sd fsd_real $control0A, a(i.year1 i.RBD1) vce(cluster RBD1)
gen estimation_sample = e(sample)

reghdfe math_sd fsd_real $control0A, a(i.year1 i.RBD1) vce(cluster RBD1)
gen estimation_sample2 = e(sample)

gen ss_sample = estimation_sample == 1 | estimation_sample2 == 1

********************************************************************************
*** MASTER SAMPLE DESCRIPTIVES
********************************************************************************
gen     Less50Books = (NBooks <= 3)
replace Less50Books = . if NBooks == .

#delimit;
global covariates female age1 
                  att1 rep1_2
				  FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1
                  avg_class_size_1_1 nstudents_1_1 tuition_fees_1
				  Income_cont noU Less50Books Computer Internet 
                  reading_sd math_sd ;
#delimit cr
			
label var female                 "Gender (1=female)"
label var age1                   "Age at school entry"
label var att1                   "First-grade attendance rate"
label var rep1_2                 "End of first-grade status (1=repeat)"	
label var noU		             "Parental education (1=no college edu.)"
label var Income_cont            "Household monthly income"
label var Less50Books            "Less than 50 books at home"
label var Computer               "Computer at home (1=yes)"
label var Internet               "Internet at home (1=yes)"
label var avg_class_size_1_1     "Average class size"
label var nstudents_1_1          "Enrollment"
label var tuition_fees_1         "Tuition fees"
label var FemaleShT_1_1          "Gender (1=female)"
label var MeanTAge_1_1           "Age"
label var ShEducationDegree_1_1  "Education degree (1=yes)"		
label var reading_sd             "Reading test score"
label var math_sd                "Mathematics test score"  

eststo: estpost tabstat ${covariates}   if ss_sample == 1,                    columns(statistics) statistics(mean) 
eststo: estpost tabstat ${covariates}   if ss_sample == 1 & dependenceB == 1, columns(statistics) statistics(mean) 
eststo: estpost tabstat ${covariates}   if ss_sample == 1 & dependenceB == 2, columns(statistics) statistics(mean) 
eststo: estpost tabstat ${covariates}   if ss_sample == 1 & dependenceB == 3, columns(statistics) statistics(mean)    
   
esttab est1 est2 est3 est4 using "${tex_stat}/sum_statB.tex" , ///
cells("mean(fmt(2))") label replace

********************************************************************************
*** STATISTICS ABOUT THOSE WHO TRANSFER AND THOSE WHO DO NOT
********************************************************************************

preserve
gen cc = 1
sum   transfer if ss_sample == 1, detail
table transfer if ss_sample == 1, c(count cc mean att1 mean rep1_2 mean fsd_real mean fsd_potential) format(%9.2f) replace
rename table1 N
rename table2 att1
rename table3 rep1_2
rename table4 fsd_real
rename table5 fsd_potential
export excel using "${tex_stat}/transfers_sum_stat.xlsx", replace firstrow(variables)
restore

preserve
gen cc = 1
sum   transfer if ss_sample == 1, detail
table transfer if ss_sample == 1 & (repeats == 0 & repeats2 == 0), c(count cc mean att1 mean rep1_2 mean fsd_real mean fsd_potential) format(%9.2f) replace
rename table1 N
rename table2 att1
rename table3 rep1_2
rename table4 fsd_real
rename table5 fsd_potential
export excel using "${tex_stat}/transfers_sum_stat_norepeat.xlsx", replace firstrow(variables)
restore

********************************************************************************
*** STATISTICS ABOUT SCHOOLS FOR WHICH WE DO NOT HAVE THE FEE STATUS
********************************************************************************

preserve

keep if ss_sample == 1
duplicates drop RBD1, force
table dependence1, c(mean miss_tf1)

restore

/*
--------------------------
dependenc |
e1        | mean(miss_tf1)
----------+---------------
        1 |              0
        2 |              0
        3 |       .0238636
--------------------------*/

