
/* This code generates Appendix Table 4 in the paper */


use "JHR_data_6"


*************************************
**** regressions for wantedness *****
*************************************

global varlist "pri secondary_alt higher urban"

global spec1 "trend"
global spec2 "trend cohort"
global spec3 "bmonth? bmonth?? cohort"
global spec4 "before cohort"

global controls ""
global restrict 1
global cluster "age"

reg ch_byear wanted $spec2 $controls, robust cluster($cluster)
outreg2 wanted using apptable4, nocons se bracket coefastr bdec(3) excel ctitle("TEST") replace

foreach var1 in $varlist {
	global restrict 1
	reg `var1' wanted $spec2 $controls, robust cluster($cluster)
	outreg2 wanted using apptable4, nocons se bracket coefastr bdec(3) excel ctitle("`var1'") append slow(100)
}

global varlist "married divorced children age"

foreach var1 in $varlist {
	global restrict 1
	reg `var1' wanted $spec2 $controls, robust cluster($cluster)
	outreg2 wanted using apptable4, nocons se bracket coefastr bdec(3) excel ctitle("`var1'") append slow(100)
}


erase "apptable4.txt"

