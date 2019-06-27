********************************************************************************
*** REGRESSIONS - MAIN MODELS  
********************************************************************************
clear all
cap log close
set more off

log using "$log/main_models_s4.log", text replace
use "$d/fsd_final_dataset_for_analysis_replication.dta", clear

********************************************************************************

global control0  

global control1  female age1 rep1_2 att1    
           
global control2  female age1 rep1_2 att1  ///
                 shareFemale1 meanAge1 meanAttendance1 meanRep2_1  ///
				 avg_class_size_1_1 nstudents_1_1

global control3  female age1 rep1_2 att1  ///
                  shareFemale1 meanAge1 meanAttendance1 meanRep2_1  ///
				  avg_class_size_1_1 nstudents_1_1 ///
				  FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1 
				 
foreach y in reading_sd math_sd { // subject
  
  * 1. FE estimation - linear effect
	forvalues c1 = 0(1)3 {  // set of controls  
	
		reghdfe `y' fsd_real ${control`c1'}, ///
		a(i.year1 i.RBD1) vce(cluster RBD1)
   
		estimates store fe1_`y'_c`c1'
		estfe           fe1_`y'_c`c1', labels(RBD1 "School fixed effects" year1 "Year fixed effects")
   }
   
    estout fe1_`y'_c0 fe1_`y'_c1 fe1_`y'_c2 fe1_`y'_c3 ///
	using "$tex_linear/fe_linear_`y'.tex", ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N, fmt(0) labels("N. of students")) ///
	mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
	indicate(`r(indicate_fe)' ///
			 "Grade 1 controls - students       = female age1 att1 rep1_2 ${add_stud} " ///
			 "Grade 1 controls - schools        = shareFemale1 meanAge1 meanAttendance1 meanRep2_1 ${add_school} avg_class_size_1_1 nstudents_1_1" ///
			 "Grade 1 controls - teachers       = FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1") 
	
	estimates drop _all
	
  * 2. FE-IV estimation - linear effect
  forvalues c1 = 0(1)3{  // set of controls  
		ivreghdfe `y' ${control`c1'} (fsd_real = fsd_potential), ///
		a(i.year1 i.RBD1) cluster(RBD1) first ffirst savefirst
   
		estadd scalar fstage1 = e(widstat)
		estimates store iv1_`y'_c`c1' 
		estfe           iv1_`y'_c`c1',  labels(RBD1 "School fixed effects" year1 "Year fixed effects")
   
		estimates restore _ivreg2_fsd_real
		estimates store fs1_`y'_c`c1' 
		estfe           fs1_`y'_c`c1',  labels(RBD1 "School fixed effects" year1 "Year fixed effects")
   
		estimates restore iv1_`y'_c`c1' 
		estfe             iv1_`y'_c`c1', labels(RBD1 "School fixed effects" year1 "Year fixed effects")
	}
   
    ** IV coefficients
	estout iv1_`y'_c0 iv1_`y'_c1 iv1_`y'_c2 iv1_`y'_c3 ///
	using "$tex_linear/iv_linear_`y'.tex", ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(fstage1 N, fmt(2 2) labels("Kleibergen-Paap rk Wald F statistic" "N. of students")) ///
	mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
	indicate(`r(indicate_fe)' ///
			 "Grade 1 controls - students       = female age1 att1 rep1_2 ${add_stud} " ///
			 "Grade 1 controls - schools        = shareFemale1 meanAge1 meanAttendance1 meanRep2_1 ${add_school} avg_class_size_1_1 nstudents_1_1" ///
			 "Grade 1 controls - teachers       = FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1") 
	
	** First stage coefficients
	estout fs1_`y'_c0 fs1_`y'_c1 fs1_`y'_c2 fs1_`y'_c3 ///
	using "$tex_linear/iv_fs_linear_`y'.tex", ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) ///
	mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
	indicate(`r(indicate_fe)' ///
			 "Grade 1 controls - students       = female age1 att1 rep1_2 ${add_stud} " ///
			 "Grade 1 controls - schools        = shareFemale1 meanAge1 meanAttendance1 meanRep2_1 ${add_school} avg_class_size_1_1 nstudents_1_1" ///
			 "Grade 1 controls - teachers       = FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1") 
	
	estimates drop _all
	
	
  * 3. IV estimation - cumulative effect
  forvalues c1 = 0(1)3 {  // set of controls   
		ivreghdfe `y' ${control`c1'} (fsd_real1 fsd_real2 fsd_real3 = fsd_potential1 fsd_potential2 fsd_potential3), ///
		a(i.year1 i.RBD1) cluster(RBD1) ffirst
   
		estadd scalar fstage2 = e(widstat)
		estimates store iv2_`y'_c`c1' 
		estfe           iv2_`y'_c`c1', labels(RBD1 "School fixed effects" year1 "Year fixed effects")
   }	
   
	estout iv2_`y'_c0 iv2_`y'_c1 iv2_`y'_c2 iv2_`y'_c3 ///
	using "$tex_cum/iv_cum_`y'.tex", ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(fstage2 N, fmt(2 0) labels("Kleibergen-Paap rk Wald F statistic" "N. of students")) ///
	mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
	indicate(`r(indicate_fe)' ///
			 "Grade 1 controls - students       = female age1 att1 rep1_2 ${add_stud} " ///
			 "Grade 1 controls - schools        = shareFemale1 meanAge1 meanAttendance1 meanRep2_1 ${add_school}  avg_class_size_1_1 nstudents_1_1" ///
			 "Grade 1 controls - teachers       = FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1")	
	
	estimates drop _all	
} 
  
log close
   
   
