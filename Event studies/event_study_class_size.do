********************************************************************************
*** CLASS SIZE
********************************************************************************
clear all
set more off
cap log close
log using "$log/es_class_size.log", text replace

use "$d/event_study_class_size.dta"
*** Event studies:
set scheme s1mono
foreach y in class_size2 {

  local a = 1.5
  local gap_a = 0.5
 
	*** All grades together, all schools:
	#delimit;
	reghdfe `y' yr_7 yr_8 yr_9 yr_10 yr_12 yr_13 yr_14 yr_15 yr_16,
	absorb(i.rbd i.agno) vce(cluster rbd);
	#delimit cr
	
	estimates store fe1
  	
	#delimit;
	coefplot fe1, 
	vertical keep(yr_7 yr_8 yr_9 yr_10 yr_12 yr_13 yr_14 yr_15 yr_16) ci(95)
	yline(0, lpattern(dash)) 
	ylabel(-`a'(`gap_a')`a', labsize(small) angle(horizontal) format(%03.2f))
	xtitle("Event time (years)") 
	xline(4.5, lpattern(dash))
	xlabel(, labsize(small)); 
	#delimit cr 
	
	graph save   "$graphs_es_csize/`y'_es.gph", replace
	graph export "$graphs_es_csize/`y'_es.png", as(png) replace
	estimates drop _all
	
}

log close
