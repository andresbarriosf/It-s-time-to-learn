********************************************************************************
*** TRANSFERS
********************************************************************************
clear all
cap log close
set more off
log using "$log/es_transfer_repetition.log", text replace

use "$d/event_study_transfers.dta"
set scheme s1mono

*** Event studies
foreach var of varlist transfer_out transfer_in diff_transfer {
				
	local b = 6
	local gap = 2

	*** All grades together, all schools:
	#delimit;
	reghdfe `var' yr_7 yr_8 yr_9 yr_10 yr_12 yr_13 yr_14 yr_15 yr_16 ,
	absorb(i.agno i.rbd) vce(cluster rbd);
	#delimit cr
	
	estimates store fe1
    estfe           fe1, labels(rbd "School fixed effects" agno "Year fixed effects")
	
	#delimit;
	coefplot fe1, 
	vertical keep(yr_7 yr_8 yr_9 yr_10 yr_12 yr_13 yr_14 yr_15 yr_16) ci(95)
	yline(0, lpattern(dash))
	ylabel(-`b'(`gap')`b', labsize(small) angle(horizontal) format(%03.2f))
	xtitle("Event time (years)") 
	xline(4.5, lpattern(dash))
	xlabel(, labsize(small)); 
	#delimit cr 
	
	graph save   "$graphs_es_transfers/`var'_es.gph", replace
	graph export "$graphs_es_transfers/`var'_es.png", as(png) replace
	estimates drop _all
}

log close

 
 
