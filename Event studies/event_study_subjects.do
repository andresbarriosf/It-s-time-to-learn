********************************************************************************
*** NUMBER OF SUBJECTS
********************************************************************************

*** We look at the study plans declared by each school for different grades and 
*** years and then we investigate if there is an increase in the subjects offered 
*** after the adoption of the FSD. There is a small increase in reading, foreign 
*** language, sports and total subjects.

clear all
set more off
cap log close
log using "$log/es_subjects.log", text replace

use "$d/event_study_subjects.dta"

*** Event Study
set scheme s1mono

local contador = 0
foreach var of varlist n_lenguage n_matematicas n_idioma_extranjero n_taller n_educacion_fisica n_subjects {
	
	local contador = `contador' + 1
	
	local b = 0.05
	local gap = 0.01
	
	if `contador' == 6 {
	
	local b = 0.1
	local gap = 0.02
	
	}
	*** All grades together, all schools:
	#delimit;
	reghdfe `var' yr_7 yr_8 yr_9 yr_10 yr_12 yr_13 yr_14 yr_15 yr_16,
	absorb(i.agno i.rbd i.cod_grado i.agno#i.cod_grado i.agno#i.rbd i.rbd#i.cod_grado) vce(cluster i.rbd##i.cod_grado);
	#delimit cr
	
	estimates store fe1
 	
	#delimit;
	coefplot fe1, 
	vertical keep(yr_7 yr_8 yr_9 yr_10 yr_12 yr_13 yr_14 yr_15 yr_16 ) ci(95)
	yline(0, lpattern(dash))
	ylabel(-`b'(`gap')`b', labsize(small) angle(horizontal) format(%03.2f))
	xtitle("Event time (years)") 
	xline(4.5, lpattern(dash))
	xlabel(, labsize(small)); 
	#delimit cr 
	
	graph save   "$graphs_es_subjects/ `var'_es.gph", replace
	graph export "$graphs_es_subjects/`var'_es.png", as(png) replace
	estimates drop _all	
}

log close
