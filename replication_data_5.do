
/* This code generates Table 6 in the paper */


use "JHR_data_5"


global spec2  "dzag dzag_dga before dga_before dzag_wanted dzag_before dzag_dga_wanted dzag_dga_before cohort dga_cohort dzag_cohort dzag_dga_cohort"
global spec2r "dzag dzag_dga before dga_before dzag_wanted dzag_before						   cohort dga_cohort dzag_cohort"  
global spec3  "dzag dzag_dga trend trend_dga dzag_wanted trend_dzag dzag_dga_wanted trend_dzag_dga cohort dga_cohort dzag_cohort dzag_dga_cohort"
global spec3r "dzag dzag_dga trend trend_dga dzag_wanted trend_dzag 					     cohort dga_cohort dzag_cohort"

global cluster "sid2"


******************
**** Table 6 *****
******************

global varlist "p_d_homework_help ch_d_homework p_tutoring"

areg agus dga if dzag~=0, robust cluster($cluster) absorb(uazY)
outreg2 dga using table6, nocons se bracket coefastr bdec(4) excel ctitle("TEST") replace

foreach var1 in $varlist {
	rdob_mod2 `var1' dzag trend dzag_wanted trend_dzag cohort dzag_cohort, c(0)
	global bw_ik_spec3r=r(h_opt)
	rdbwselect `var1' dzag, c(0) covs(wanted trend dzag_wanted trend_dzag cohort dzag_cohort)
	global bw_cct_spec3r=e(h_mserd)

	areg `var1' dga wanted dga_wanted $spec3r if (dzag>=-$bw_ik_spec3r & dzag<$bw_ik_spec3r) & dzag~=0, robust cluster($cluster) absorb(uazY)
	outreg2 dga wanted dga_wanted using table6, nocons se bracket coefastr bdec(4) excel ctitle("`var1'") append slow(1000) 
	areg `var1' dga wanted dga_wanted $spec3r if (dzag>=-$bw_cct_spec3r & dzag<$bw_cct_spec3r) & dzag~=0, robust cluster($cluster) absorb(uazY)
	outreg2 dga wanted dga_wanted using table6, nocons se bracket coefastr bdec(4) excel ctitle("`var1'") append slow(1000) 

	rdob_mod2 `var1' dzag trend dzag_wanted trend_dzag cohort dzag_cohort, c(0)
	global bw_ik_spec3=r(h_opt)
	rdbwselect `var1' dzag, c(0) covs(wanted trend dzag_wanted trend_dzag cohort dzag_cohort)
	global bw_cct_spec3=e(h_mserd)

	areg `var1' dga wanted dga_wanted $spec3 if (dzag>=-$bw_ik_spec3 & dzag<$bw_ik_spec3) & dzag~=0, robust cluster($cluster) absorb(uazY)
	outreg2 dga wanted dga_wanted using table6, nocons se bracket coefastr bdec(4) excel ctitle("`var1'") append slow(1000) 
	areg `var1' dga wanted dga_wanted $spec3 if (dzag>=-$bw_cct_spec3 & dzag<$bw_cct_spec3) & dzag~=0, robust cluster($cluster) absorb(uazY)
	outreg2 dga wanted dga_wanted using table6, nocons se bracket coefastr bdec(4) excel ctitle("`var1'") append slow(1000) 
}


erase "table6.txt"

