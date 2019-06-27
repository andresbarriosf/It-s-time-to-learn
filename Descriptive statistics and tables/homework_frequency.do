********************************************************************************
*** Homework Frequency
********************************************************************************

clear all
set more off
cap log close

log using "$log/homework_frequency.log", text replace

use "$d/homework_frequency.dta"

tab hw fsd if cod_depe <= 3, col
tab hw fsd if public == 1,   col
tab hw fsd if public == 0,   col
tab hw fsd if public2 == 1,  col
tab hw fsd if public2 == 0,  col

gen temp = (agno == 2011)
bys rbd: egen pres2011 = max(temp)
drop temp
gen temp = (fsd == 1 & agno == 2011)
bys rbd: egen fsd2011 = max(temp) // fsd status of the school in 2011
drop temp
gen temp = (agno == 2013)
bys rbd: egen pres2013 = max(temp)
drop temp
gen temp = (fsd == 1 & agno == 2013)
bys rbd: egen fsd2013 = max(temp) // fsd status of the school in 2013
drop temp

** situation in 2011 for schools with no fsd in 2011
tab hw if agno == 2011 & fsd2011 == 0 & pres2011 == 1 & pres2013 == 1                & cod_depe <= 3
tab hw if agno == 2013 & fsd2011 == 0 & pres2011 == 1 & pres2013 == 1 & fsd2013 == 0 & cod_depe <= 3
tab hw if agno == 2013 & fsd2011 == 0 & pres2011 == 1 & pres2013 == 1 & fsd2013 == 1 & cod_depe <= 3

log close
