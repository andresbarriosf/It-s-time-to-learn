********************************************************************************
***	TEACHERS OPINION ABOUT THE FSD
********************************************************************************
clear all
set more off
use "$d/teachers_opinion.dta"

svyset _n [pw=fexp]
gen fweights = int(fexp)

tab fsdOpinion, gen(fsd_op)

svy: mean fsd_op1, over(Public1)
svy: mean fsd_op2, over(Public1)
svy: mean fsd_op3, over(Public1)

/*********************************************
						Public		Subsidized
						**********************
Very good, good			0.4498871	0.5443781
Not good, not bad		0.3299454	0.2989271
Very bad, bad			0.2201675	0.1566948
*********************************************/
