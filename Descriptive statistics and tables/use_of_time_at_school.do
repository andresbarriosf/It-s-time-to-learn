*** Use of Time
clear all
set more off 
use "$d/school_use_of_time.dta"

*** II. STATISTICS FOR TABLE

*** 2.1 Definition of variables to include in columns 1, 3 and 5 of the table:
#delimit;
local variables1 gf_teachingSpanish gf_teachingMaths gf_teachingSoc gf_teachingNat 
                 gf_teachingFLang gf_teachingTech gf_teachingArt gf_teachingSports gf_teachingOri 
                 gf_teachingReligion gf_teachingClassCoun;
#delimit cr;

estpost sum `variables1' 
estimate store A

estpost sum `variables1' if cod_depe == 1
estimate store B

estpost sum `variables1' if cod_depe == 2
estimate store C

#delimit;
esttab A B C using "$tex/use_of_time_table1.tex", replace
mtitle("All" "Public" "Charter")
cells(mean sd) label booktabs nonum collabels(none) gaps f noobs;
#delimit cr;


**** 2.2 Definition of variables to include in columns 2,4 and 6 of the table:

#delimit;
local variables1 ftlenguaj ftmatemat ftsocieda ftnatural ftidioma fttecnolo ftartes 
                 ftfisica ftorienta ftreligio ftconsejo;
#delimit cr;

estpost sum `variables1'
estimate store A

estpost sum `variables1' if cod_depe == 1
estimate store B

estpost sum `variables1' if cod_depe == 2
estimate store C

#delimit;
esttab A B C using "$tex/use_of_time_table2.tex", replace
mtitle("All" "Public" "Charter")
cells(mean sd) label booktabs nonum collabels(none) gaps f noobs;
#delimit cr;

**** 2.3 T-Tests to check if differences are statistically significant:
#delimit;
local variables1 gf_teachingSpanish gf_teachingMaths gf_teachingSoc gf_teachingNat 
gf_teachingFLang gf_teachingTech gf_teachingArt gf_teachingSports gf_teachingOri 
gf_teachingReligion gf_teachingClassCoun;
#delimit cr;

#delimit;
local variables2 ftlenguaj ftmatemat ftsocieda ftnatural ftidioma fttecnolo ftartes 
                 ftfisica ftorienta ftreligio ftconsejo;
#delimit cr;

foreach var of varlist `variables1' `variables2' {

		 di "`var'"
		 ttest `var', by(cod_depe)
		 di " "
		 di " "

}
