********************************************************************************
*** PARENTS REASON TO CHOOSE PARTICULAR SCHOOL
********************************************************************************
clear all
set more off

use "$d/school_choice.dta"
tab cpad_p18 if cod_depe <= 3

/* cpad_p18 |      Freq.     Percent        Cum.
------------+-----------------------------------
          0 |     27,246       29.84       29.84 (distance)
          1 |     16,992       18.61       48.44 (family)
          2 |     16,874       18.48       66.92 (prestige)
          3 |      1,206        1.32       68.24
          4 |        284        0.31       68.55
          5 |        588        0.64       69.20
          6 |      8,175        8.95       78.15
          7 |      1,799        1.97       80.12
          8 |      8,539        9.35       89.47
          9 |        402        0.44       89.91
         10 |        773        0.85       90.76
         11 |        384        0.42       91.18
         12 |      4,741        5.19       96.37
         13 |        595        0.65       97.02
         14 |      2,721        2.98      100.00
------------+-----------------------------------*/