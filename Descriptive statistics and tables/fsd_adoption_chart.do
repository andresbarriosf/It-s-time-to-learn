clear all 
set more off

use "$d/fsd_adoption.dta"

set scheme s1mono

#delimit;
twoway (bar PEAdopted Year, sort) 
(connected SharePublicPE Year, sort yaxis(2) mcolor(black) msymbol(square) lcolor(black)) 
(connected SharePrivatePE Year, sort yaxis(2) mcolor(gs14) msymbol(triangle) lcolor(gs14)), 
ytitle(Number of adopters) 
ytitle(, size(medsmall) orientation(vertical)) 
ylabel(0(1000)7000, labsize(small) angle(horizontal)) 
ytitle(Shares, axis(2))
ytitle(, size(small) orientation(rvertical) axis(2)) 
ylabel(0(0.1)1, labsize(small) angle(horizontal) axis(2)) 
xtitle(Year) 
xtitle(, size(small)) 
xlabel(1997(1)2013, labsize(small) angle(forty_five)) 
legend(on order(1 "Total number of adopters" 2 "Share of public schools" 3 "Share of charter schools"));
#delimit cr

graph save   "${graphs}/adopters.gph", replace
graph export "${graphs}/adopters.png", as(png) replace














