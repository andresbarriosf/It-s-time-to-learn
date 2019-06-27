********************************************************************************
*** TEACHERS
********************************************************************************
clear
set more off
cap log close
log using "$log/es_teachers.log", text replace

********************************************************************************
*** CHARTS FOR EVENT STUDIES
********************************************************************************
use "$d/event_study_teachers.dta"
set scheme s1mono
global outcomes contract_hh teaching_hh contr_hh_per_class t_hh_per_class nteachers avg_contract_hh avg_teaching_hh

local counter = 0
foreach y of varlist $outcomes { 


		local counter = `counter' + 1
		
		if `counter' == 1 | `counter' == 2 {
			
			local b = 150
			local gap = 50
		}
		
		if `counter' == 3 | `counter' == 4 {
			
			local b   = 10
			local gap = 2
		}
		
		if `counter' >= 5 & `counter' <= 7 {
			
			local b   = 4
			local gap = 1
		}
	
	
		*** All sample:
		reghdfe `y' yr_6 yr_7 yr_8 yr_9 yr_11 yr_12 yr_13 yr_14 yr_15 if `y' > 0, ///
		a(i.agno i.rbd) vce(cluster i.rbd) 
		estimates store `y'
		estfe           `y', labels(rbd "School fixed effects" agno "Year fixed effects")
	
		#delimit;
		coefplot `y', 
		vertical keep(yr_6 yr_7 yr_8 yr_9 yr_11 yr_12 yr_13 yr_14 yr_15) ci(95)
		yline(0, lpattern(dash)) 
		ylabel(-`b'(`gap')`b', labsize(small) angle(horizontal) format(%03.2f))
		xtitle("Event time (years)") 
		xline(4.5, lpattern(dash))
		xlabel(, labsize(small)); 
		#delimit cr 
	
		graph save   "$graphs_es_teachers/`y'_es.gph", replace
		graph export "$graphs_es_teachers/`y'_es.png", as(png) replace
		estimates drop _all
		
		*** By school dependence:
		forvalues d = 1/2{
			
			reghdfe `y' yr_6 yr_7 yr_8 yr_9 yr_11 yr_12 yr_13 yr_14 yr_15 if `y' > 0 & dependenceB_m == `d', ///
			a(i.agno i.rbd) vce(cluster i.rbd) 
			estimates store `y'_dBm`d'
			estfe           `y'_dBm`d', labels(rbd "School fixed effects" agno "Year fixed effects")
	
		}
		
		*** Dependence:
		#delimit;
		coefplot (`y'_dBm1, label("Public"))
		         (`y'_dBm2, label("Charter with no fees")), 
		vertical keep(yr_6 yr_7 yr_8 yr_9 yr_11 yr_12 yr_13 yr_14 yr_15) ci(95)
		yline(0, lpattern(dash))
		ylabel(-`b'(`gap')`b', labsize(small) angle(horizontal) format(%03.2f))
		xtitle("Event time (years)") 
		xline(4.5, lpattern(dash))
		xlabel(, labsize(small));
		#delimit cr 
		
		graph save   "$graphs_es_teachers/`y'_es_dBm.gph", replace
		graph export "$graphs_es_teachers/`y'_es_dBm.png", as(png) replace
		estimates drop _all
	
}

log close

********************************************************************************
*** INTERACTED MODELS
********************************************************************************
cap log close
log using "$log/es_teachers_interacted models.log", text replace

global outcomes contract_hh teaching_hh contr_hh_per_class t_hh_per_class nteachers avg_contract_hh avg_teaching_hh

forvalues y = 6(1)15 {
  local z = `y' - 11
  label var yr_`y' "Event-year `z'"
  cap drop yr_`y'_int
  gen yr_`y'_int       = yr_`y' * Charter1BLF_m // interaction of event-year coeffs
  label var yr_`y'_int  "Event-year `z' $\times$ no-fee charter" 
  
 }
 
cap drop group1 group2
egen group1 = group(agno Charter1BLF_m)
egen group2 = group(rbd  Charter1BLF_m)

foreach y of global outcomes {

reghdfe `y' yr_6 yr_7 yr_8 yr_9 yr_11 yr_12 yr_13 yr_14 yr_15 ///
                    yr_6_int yr_7_int yr_8_int yr_9_int yr_11_int yr_12_int yr_13_int yr_14_int yr_15_int ///
					if `y' > 0, ///
                    a(i.group1 i.group2) vce(cluster i.rbd) 
					
est  store `y'
estfe      `y', labels(group2 "School fixed effects" group1 "Calendar year fixed effects")
}

 estout ${outcomes} ///
 using "$tex_es/es_teacher.tex", ///
 cells(b(star fmt(%9.3f)) se(par fmt(%9.3f))) stats(N, fmt(0) labels("N. of school-years")) ///
 keep(yr_*) ///
 mlabels(none) collabels(none) note(" ") style(tex) replace label starlevels(* 0.10 ** 0.05 *** 0.01) ///
 indicate(`r(indicate_fe)') 
					
log close
