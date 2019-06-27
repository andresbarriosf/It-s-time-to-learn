********************************************************************************
*** STANDARDIZED TESTS
********************************************************************************
clear all
set more off
cap log close
log using "$log/es_SIMCE.log", text replace
 
use "$d/event_study_simce_scores.dta", clear

set scheme s1mono
foreach y of varlist reading_sd math_sd {

	*** All sample:
	reghdfe `y' yr_1 yr_2 yr_3 yr_4  yr_6 yr_7 yr_8 yr_9 yr_10, ///
    a(i.agno i.rbd) vce(cluster rbd) 
    estimates store fe1_`y'
    estfe           fe1_`y', labels(rbd "School fixed effects" agno "Year fixed effects")
	
	#delimit;
	coefplot fe1_`y', 
	vertical keep(yr_1 yr_2 yr_3 yr_4 yr_6 yr_7 yr_8 yr_9 yr_10) ci(95)
	ylabel(-0.1(0.05)0.1, labsize(small) angle(horizontal) format(%03.2f))
	yline(0, lpattern(dash)) 
	xtitle("Event time (years)")  
	xline(4.5, lpattern(dash))
	xlabel(, labsize(small)); 
	#delimit cr 
	
	graph save   "$graphs_es_simce/`y'_es.gph", replace
	graph export "$graphs_es_simce/`y'_es.png", as(png) replace		
}

log close
