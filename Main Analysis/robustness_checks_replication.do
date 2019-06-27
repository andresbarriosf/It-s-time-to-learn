********************************************************************************
*** ROBUSTNESS CHECKS
********************************************************************************
clear all
cap log close
set more off

log using "$log/robustness_models.log", text replace
use "$d/fsd_final_dataset_for_analysis_replication.dta", clear
       
global control0  
global control1  female age1 rep1_2 att1                
global control2  female age1 rep1_2 att1  ///
                  shareFemale1 meanAge1 meanAttendance1 meanRep2_1  ///
				  avg_class_size_1_1 nstudents_1_1
global control3  female age1 rep1_2 att1  ///
                  shareFemale1 meanAge1 meanAttendance1 meanRep2_1  ///
				  avg_class_size_1_1 nstudents_1_1 ///
				  FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1	   
	   
********************************************************************************
*** INFRASTRUCTURE:
*** Restrict sample to schools that did not receive funds for infrastructure
********************************************************************************
foreach y in reading_sd math_sd { // subject
	forvalues c = 0(1)3 {  // controls
 
	** 1. FE estimation - linear effect
	reghdfe `y' fsd_real ${control`c'} if Infrastructure_1_1 == 0, ///
	a(i.year1 i.RBD1) vce(cluster RBD1)
	estimates store fe1_`y'_c`c'
	estfe           fe1_`y'_c`c', labels(RBD1 "School fixed effects" year1 "Year fixed effects")
    
	}
	
    estout fe1_`y'_c0 fe1_`y'_c1 fe1_`y'_c2 fe1_`y'_c3 ///
	using "$tex_infra/fe_linear_`y'_no_infra.tex", ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N, fmt(0) labels("N. of students")) ///
	mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
	indicate(`r(indicate_fe)' ///
			 "Grade 1 controls - students       = female age1 att1 rep1_2 ${add_stud} " ///
			 "Grade 1 controls - schools        = shareFemale1 meanAge1 meanAttendance1 meanRep2_1 ${add_school} avg_class_size_1_1 nstudents_1_1" ///
			 "Grade 1 controls - teachers       = FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1") 
	
	forvalues c = 0(1)3 { // controls  
  
    ** 2. FE-IV estimarion - linear effect
	ivreghdfe `y' ${control`c'} (fsd_real = fsd_potential) if Infrastructure_1_1 == 0, ///
	a(i.year1 i.RBD1) cluster(RBD1) ffirst
	estadd scalar fstage1 = e(widstat)
	estimates store iv1_`y'_c`c' 
	estfe           iv1_`y'_c`c', labels(RBD1 "School fixed effects" year1 "Year fixed effects")
   
   }
  
	estout iv1_`y'_c0 iv1_`y'_c1 iv1_`y'_c2 iv1_`y'_c3 ///
	using "$tex_infra/iv_linear_`y'_no_infra.tex", ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N fstage1, fmt(0 2) labels("N. of students" "Kleibergen-Paap rk Wald F statistic" )) ///
	mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
	indicate(`r(indicate_fe)' ///
			 "Grade 1 controls - students       = female age1 att1 rep1_2 ${add_stud} " ///
			 "Grade 1 controls - schools        = shareFemale1 meanAge1 meanAttendance1 meanRep2_1 ${add_school} avg_class_size_1_1 nstudents_1_1" ///
			 "Grade 1 controls - teachers       = FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1") 	
    
}
   
********************************************************************************
*** SEP-1:
*** Restrict the sample to cohorts never exposed to SEP 
********************************************************************************
foreach y in reading_sd math_sd { // subject
	forvalues c = 0(1)3 {  // controls
   
	** 1. FE estimation - linear effect
	reghdfe `y' fsd_real ${control`c'} if year1<=2004, ///
	a(i.year1 i.RBD1) vce(cluster RBD1)
	estimates store fe1_`y'_c`c'
	estfe           fe1_`y'_c`c', labels(RBD1 "School fixed effects" year1 "Year fixed effects")
    
	}
   
    estout fe1_`y'_c0 fe1_`y'_c1  fe1_`y'_c2 fe1_`y'_c3 ///
	using "$tex_sep/fe_linear_`y'_SEP1.tex", ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N, fmt(0) labels("N. of students")) ///
	mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
	keep(fsd_real ${control`c'}) ///
	indicate(`r(indicate_fe)' ///
			 "Grade 1 controls - students       = female age1 att1 rep1_2 ${add_stud} " ///
			 "Grade 1 controls - schools        = shareFemale1 meanAge1 meanAttendance1 meanRep2_1 ${add_school} avg_class_size_1_1 nstudents_1_1" ///
			 "Grade 1 controls - teachers       = FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1") 
	
	forvalues c = 0(1)3 {  // set of controls  
  
	
   ** 2. FE-IV estimarion - linear effect
   ivreghdfe `y' ${control`c'} (fsd_real = fsd_potential) if year1<=2004, ///
   a(i.year1 i.RBD1) cluster(RBD1) ffirst
   estadd scalar fstage1 = e(widstat)
   estimates store iv1_`y'_c`c' 
   estfe           iv1_`y'_c`c', labels(RBD1 "School fixed effects" year1 "Year fixed effects")
   
   }

	estout iv1_`y'_c0 iv1_`y'_c1 iv1_`y'_c2 iv1_`y'_c3 ///
	using "$tex_sep/iv_linear_`y'_SEP1.tex", ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N fstage1, fmt(0 2) labels("N. of students" "Kleibergen-Paap rk Wald F statistic" )) ///
	mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
	keep(fsd_real ${control`c'}) ///
	indicate(`r(indicate_fe)' ///
			 "Grade 1 controls - students       = female age1 att1 rep1_2 ${add_stud} " ///
			 "Grade 1 controls - schools        = shareFemale1 meanAge1 meanAttendance1 meanRep2_1 ${add_school} avg_class_size_1_1 nstudents_1_1" ///
			 "Grade 1 controls - teachers       = FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1") 
} 

******************************************************************************** 
*** SEP-2: 
*** Include all cohorts, add controls for individual exposure by grade 4 and average 
*** share exposed at the school level
********************************************************************************
foreach y in reading_sd math_sd { // subject
  
   forvalues c = 0(1)3 {  // controls
   
	** 1. FE estimation - linear effect 
	reghdfe `y' fsd_real ${control`c'} sep_student shareSEP, ///
	a(i.year1 i.RBD1) vce(cluster RBD1)
	estimates store fe1_`y'_c`c'
	estfe           fe1_`y'_c`c', labels(RBD1 "School fixed effects" year1 "Year fixed effects")
   
   }
   
   estout fe1_`y'_c0 fe1_`y'_c1 fe1_`y'_c2 fe1_`y'_c3 ///
   using "$tex_sep/fe_linear_`y'_SEP2.tex", ///
   cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N, fmt(0) labels("N. of students")) ///
   mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
   keep(fsd_real ${control`c'}) ///
   indicate(`r(indicate_fe)' ///
			 "Grade 1 controls - students       = female age1 att1 rep1_2 ${add_stud} " ///
			 "Grade 1 controls - schools        = shareFemale1 meanAge1 meanAttendance1 meanRep2_1 ${add_school} avg_class_size_1_1 nstudents_1_1" ///
			 "Grade 1 controls - teachers       = FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1") 
	
   forvalues c = 0(1)3 {  // controls  
  
	** 2. FE-IV estimarion - linear effect
	ivreghdfe `y' ${control`c'} sep_student shareSEP (fsd_real = fsd_potential), ///
	a(i.year1 i.RBD1) cluster(RBD1) ffirst
	estadd scalar fstage1 = e(widstat)
	estimates store iv1_`y'_c`c' 
	estfe           iv1_`y'_c`c', labels(RBD1 "School fixed effects" year1 "Year fixed effects")
   }
   
	estout iv1_`y'_c0 iv1_`y'_c1 iv1_`y'_c2 iv1_`y'_c3 ///
	using "$tex_sep/iv_linear_`y'_SEP2.tex", ///
	cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N fstage1, fmt(0 2) labels("N. of students" "Kleibergen-Paap rk Wald F statistic" )) ///
	mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
	keep(fsd_real ${control`c'}) ///
	indicate(`r(indicate_fe)' ///
			 "Grade 1 controls - students       = female age1 att1 rep1_2 ${add_stud} " ///
			 "Grade 1 controls - schools        = shareFemale1 meanAge1 meanAttendance1 meanRep2_1 ${add_school} avg_class_size_1_1 nstudents_1_1" ///
			 "Grade 1 controls - teachers       = FemaleShT_1_1 MeanTAge_1_1 ShEducationDegree_1_1") 	
}
 
log close
