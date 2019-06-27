********************************************************************************
*** REGRESSION ANALYSIS - HETEROGENEOUS MODELS
*** REPLICATION FILE
********************************************************************************
clear all
cap log close
set more off

use "$d/fsd_final_dataset_for_analysis_replication.dta", clear
     
********************************************************************************
*** SINGLE FULLY INTERACTED MODELS
********************************************************************************
cap log close
log using  "$log/heteroegenous_models_single_interactions_s4_new.log", text replace

global outcomes Charter1BLF_m ///
                noU  ///
				FewBooks ///
				NoICT
				
foreach j of global outcomes {
  
   if "`j'" == "Charter1BLF_m"  global cd school 
   if "`j'" == "noU"            global cd edu
   if "`j'" == "FewBooks"       global cd books
   if "`j'" == "NoICT"          global cd ITC
   
   if "`j'" == "Charter1BLF_m" global add  if inconsistent_1 == 0
   if "`j'" == "noU"           global add 
   if "`j'" == "FewBooks"      global add
   if "`j'" == "NoICT"         global add

   *** Controls
   global control0  
   
   global control1  female age1 rep1_2 att1 ///
                    i.female#i.`j' c.age1#i.`j' i.rep1_2#i.`j' c.att1#i.`j'              
   
   global control2  female age1 rep1_2 att1 ///
                    i.female#i.`j' c.age1#i.`j' i.rep1_2#i.`j' c.att1#i.`j'  ///
				    shareFemale1 meanAge1 meanAttendance1 meanRep2_1  ///
					c.shareFemale1#i.`j' c.meanAge1#i.`j' c.meanAttendance1#i.`j' c.meanRep2_1#i.`j' ///
			        avg_class_size_1_1 nstudents_1_1 ///
					c.avg_class_size_1_1#i.`j' c.nstudents_1_1#i.`j'
   
   global control3  female age1 rep1_2 att1 ///
                    i.female#i.`j' c.age1#i.`j' i.rep1_2#i.`j' c.att1#i.`j'  ///
				    shareFemale1 meanAge1 meanAttendance1 meanRep2_1  ///
					c.shareFemale1#i.`j' c.meanAge1#i.`j' c.meanAttendance1#i.`j' c.meanRep2_1#i.`j' ///
					avg_class_size_1_1 nstudents_1_1 ///
					c.avg_class_size_1_1#i.`j' c.nstudents_1_1#i.`j' ///
				    FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1 ///
					c.FemaleShT_1_1#i.`j' c.MeanTAge_1_1#i.`j' c.ShEducationDegree_1_1#i.`j'

	*** Estimation
	foreach y in reading_sd math_sd { // subject
		forvalues c1 = 0(1)3 {  // set of controls  
    	
		*** IV
		ivreghdfe `y' ${control`c1'} (fsd_real c.fsd_real#ib0.`j' = fsd_potential c.fsd_potential#ib0.`j') ${add}, ///
		a(i.`j'##i.year1  i.`j'##i.RBD1) cluster(RBD1) ffirst partial(${control`c1'})
		estadd scalar fstage1 = e(widstat)
		estimates store iv1_`y'_c`c1'A 
		estfe           iv1_`y'_c`c1'A, labels(i.`j'##i.RBD1 "School-`j' fixed effects" i.`j'##i.year1 "Year-`j' fixed effects")
 	
		}
		
	estout iv1_`y'_c0A iv1_`y'_c1A iv1_`y'_c2A iv1_`y'_c3A ///
	using "${tex_${cd}}/iv_linear_interactions_`y'_`j'.tex", ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N fstage1, fmt(0 2) labels("N. of students" "Kleibergen-Paap rk Wald F statistic" )) ///
	mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
	noomitted ///
	indicate(`r(indicate_fe)') 
			
	estimates drop _all		
			
	}
}	 

log close

********************************************************************************
*** MULTIPLE INTERACTIONS MODELS
********************************************************************************
cap log close
log using "$log/heterogeneous_models_multiple_interactions.log", text replace

*** Estimation with multiple interactions **************************************
global outcomes Charter1BLF_m 

foreach j of global outcomes  {

   if "`j'" == "Charter1BLF_m"  global cd multiple      
   if "`j'" == "Charter1BLF_m"  global add if inconsistent_1 == 0     
   
   foreach var of varlist FewBooks noU NoICT {

   *** Controls
   global control0  
   global control1  female age1 rep1_2 att1 ///
                    i.female#i.`j'   c.age1#i.`j'   i.rep1_2#i.`j'   c.att1#i.`j' ///
					i.female#i.`var' c.age1#i.`var' i.rep1_2#i.`var' c.att1#i.`var'
   
   global control2  female age1 rep1_2 att1 ///
                    i.female#i.`j'   c.age1#i.`j'   i.rep1_2#i.`j'   c.att1#i.`j'  ///
					i.female#i.`var' c.age1#i.`var' i.rep1_2#i.`var' c.att1#i.`var' ///
				    shareFemale1 meanAge1 meanAttendance1 meanRep2_1  ///
					c.shareFemale1#i.`j'   c.meanAge1#i.`j'   c.meanAttendance1#i.`j'   c.meanRep2_1#i.`j' ///
					c.shareFemale1#i.`var' c.meanAge1#i.`var' c.meanAttendance1#i.`var' c.meanRep2_1#i.`var' ///
			        avg_class_size_1_1 nstudents_1_1 /// 
					c.avg_class_size_1_1#i.`j'   c.nstudents_1_1#i.`j' ///
					c.avg_class_size_1_1#i.`var' c.nstudents_1_1#i.`var'
					
   global control3  female age1 rep1_2 att1 ///
                    i.female#ib0.`j' c.age1#i.`j'   i.rep1_2#i.`j'   c.att1#i.`j'  ///
					i.female#i.`var' c.age1#i.`var' i.rep1_2#i.`var' c.att1#i.`var' ///
				    shareFemale1 meanAge1 meanAttendance1 meanRep2_1  ///
					c.shareFemale1#i.`j'   c.meanAge1#i.`j'   c.meanAttendance1#i.`j'   c.meanRep2_1#i.`j' ///
					c.shareFemale1#i.`var' c.meanAge1#i.`var' c.meanAttendance1#i.`var' c.meanRep2_1#i.`var' ///
			        avg_class_size_1_1 nstudents_1_1 /// 
					c.avg_class_size_1_1#i.`j'   c.nstudents_1_1#i.`j' ///
					c.avg_class_size_1_1#i.`var' c.nstudents_1_1#i.`var' /// 
				    FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1 ///
					c.FemaleShT_1_1#i.`j'   c.MeanTAge_1_1#i.`j'   c.ShEducationDegree_1_1#i.`j' ///
					c.FemaleShT_1_1#i.`var' c.MeanTAge_1_1#i.`var' c.ShEducationDegree_1_1#i.`var'
	
	*** Estimation
	foreach y in reading_sd math_sd { // subject
		forvalues c1 = 0(1)3 {  // set of controls  
    	
		*** IV
		ivreghdfe `y' ${control`c1'} `var' (fsd_real c.fsd_real#ib0.`j' c.fsd_real#i.`var' = fsd_potential c.fsd_potential#ib0.`j' c.fsd_potential#i.`var') ${add}, ///
		a(i.`j'##i.year1 i.`var'##i.year1 i.`j'##i.RBD1 i.`var'##i.RBD1) cluster(RBD1) ffirst partial(${control`c1'} `var')
    
		estadd scalar fstage1 = e(widstat)
		estimates store iv1_`y'_c`c1'A 
		estfe           iv1_`y'_c`c1'A, labels(i.`j'##i.RBD1 "School type fixed effects" i.`j'##i.year1 "Year-school type fixed effects" i.`var'##i.RBD1 "School-`var' fixed effects" i.`var'##i.year1 "Year-`var' fixed effects")
		
		}
		
	estout iv1_`y'_c0A iv1_`y'_c1A iv1_`y'_c2A iv1_`y'_c3A ///
	using "${tex_${cd}}/iv_linear_double_interactions_`y'_`j'_`var'.tex", ///
	noomitted ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N fstage1, fmt(0 2) labels("N. of students" "Kleibergen-Paap rk Wald F statistic" )) ///
	mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
	indicate(`r(indicate_fe)') 
			
	estimates drop _all		
			
	}
  }
}	

log close

*** Estimation with multiple interactions **************************************
*** Fixing sample size
cap log close
log using "$log/heterogeneous_models_multiple_interactions_fixed_sample.log", text replace
gen complete_info = (noU !=. & NoICT != . & FewBooks !=.)


foreach j in Charter1BLF_m {

   if "`j'" == "Charter1BLF_m"  global cd  multiple      
   if "`j'" == "Charter1BLF_m"  global add if inconsistent_1 == 0 & complete_info == 1  
   
   foreach var of varlist noU FewBooks NoICT {

   *** Controls
   global control0  
   global control1  female age1 rep1_2 att1 ///
                    i.female#i.`j'   c.age1#i.`j'   i.rep1_2#i.`j'   c.att1#i.`j' ///
					i.female#i.`var' c.age1#i.`var' i.rep1_2#i.`var' c.att1#i.`var'
   
   global control2  female age1 rep1_2 att1 ///
                    i.female#i.`j'   c.age1#i.`j'   i.rep1_2#i.`j'   c.att1#i.`j'  ///
					i.female#i.`var' c.age1#i.`var' i.rep1_2#i.`var' c.att1#i.`var' ///
				    shareFemale1 meanAge1 meanAttendance1 meanRep2_1  ///
					c.shareFemale1#i.`j'   c.meanAge1#i.`j'   c.meanAttendance1#i.`j'   c.meanRep2_1#i.`j' ///
					c.shareFemale1#i.`var' c.meanAge1#i.`var' c.meanAttendance1#i.`var' c.meanRep2_1#i.`var' ///
			        avg_class_size_1_1 nstudents_1_1 /// 
					c.avg_class_size_1_1#i.`j'   c.nstudents_1_1#i.`j' ///
					c.avg_class_size_1_1#i.`var' c.nstudents_1_1#i.`var'
					
   global control3  female age1 rep1_2 att1 ///
                    i.female#ib0.`j' c.age1#i.`j'   i.rep1_2#i.`j'   c.att1#i.`j'  ///
					i.female#i.`var' c.age1#i.`var' i.rep1_2#i.`var' c.att1#i.`var' ///
				    shareFemale1 meanAge1 meanAttendance1 meanRep2_1  ///
					c.shareFemale1#i.`j'   c.meanAge1#i.`j'   c.meanAttendance1#i.`j'   c.meanRep2_1#i.`j' ///
					c.shareFemale1#i.`var' c.meanAge1#i.`var' c.meanAttendance1#i.`var' c.meanRep2_1#i.`var' ///
			        avg_class_size_1_1 nstudents_1_1 /// 
					c.avg_class_size_1_1#i.`j'   c.nstudents_1_1#i.`j' ///
					c.avg_class_size_1_1#i.`var' c.nstudents_1_1#i.`var' /// 
				    FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1 ///
					c.FemaleShT_1_1#i.`j'   c.MeanTAge_1_1#i.`j'   c.ShEducationDegree_1_1#i.`j' ///
					c.FemaleShT_1_1#i.`var' c.MeanTAge_1_1#i.`var' c.ShEducationDegree_1_1#i.`var'


	*** Estimation
	foreach y in reading_sd math_sd { // subject
		forvalues c1 = 0(1)3 {  // set of controls  
		
		*** IV
		ivreghdfe `y' ${control`c1'} `var' (fsd_real c.fsd_real#ib0.`j' c.fsd_real#i.`var' = fsd_potential c.fsd_potential#ib0.`j' c.fsd_potential#i.`var') ${add}, ///
		a(i.`j'##i.year1 i.`var'##i.year1 i.`j'##i.RBD1 i.`var'##i.RBD1) cluster(RBD1) ffirst partial(${control`c1'} `var')
		estadd scalar fstage1 = e(widstat)
		estimates store iv1_`y'_c`c1'A 
		estfe           iv1_`y'_c`c1'A, labels(i.`j'##i.RBD1 "School type fixed effects" i.`j'##i.year1 "Year-school type fixed effects" i.`var'##i.RBD1 "School-`var' fixed effects" i.`var'##i.year1 "Year-`var' fixed effects")
		}
					
		estout iv1_`y'_c0A iv1_`y'_c1A iv1_`y'_c2A iv1_`y'_c3A ///
		using "${tex_${cd}}/iv_linear_double_interactions_`var'_`y'_`j'_fixed_sample.tex", ///
		cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N fstage1, fmt(0 2) labels("N. of students" "Kleibergen-Paap rk Wald F statistic" )) ///
		mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
		indicate(`r(indicate_fe)') 
			
		estimates drop _all				
	}
	}
}	

log close
