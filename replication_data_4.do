*Update this folder depending on where Stata is installed on your machine
global statapath "C:\Program Files\Stata17\StataMP-64.exe"

*Note: reweight_est_impute.ado makes use of the "akdensity" command. This must be installed before running (via ssc install akdensity)

*reweight_est_impute.ado also makes use of the command rdbwselect, which you must install before running (via net install rdrobust, from(https://raw.githubusercontent.com/rdpackages/rdrobust/master/stata) replace)

*Get point estimates
cap log using "ptestimates.log", replace

	do "reweight_est_impute.ado"
	use "ready_to_reweight.dta", clear
		
		
		reweight_est bcg_z, reweight ptestimaterun
			scalar effect_ikrw = r(effect)
			scalar effect_ikrw_a = r(effect_a)
			scalar effect_ikrw_b = r(effect_b)
			scalar effect_ikrw_res = r(effect_res)
			scalar effect_ikrw_a_res = r(effect_a_res)
			scalar effect_ikrw_b_res = r(effect_b_res)
			scalar samplesize_ikrw = r(samplesize)
			scalar samplesize_ikrw_res = r(samplesize_res)
			scalar numclusters_ikrw = r(numclusters)
			scalar numclusters_ikrw_res = r(numclusters_res)
			
			scalar effect_cctrw = r(effect_cct)
			scalar effect_cctrw_a = r(effect_a_cct)
			scalar effect_cctrw_b = r(effect_b_cct)
			scalar effect_cctrw_res = r(effect_res_cct)
			scalar effect_cctrw_a_res = r(effect_a_res_cct)
			scalar effect_cctrw_b_res = r(effect_b_res_cct)
			scalar samplesize_cctrw = r(samplesize_cct)
			scalar samplesize_cctrw_res = r(samplesize_res_cct)
			scalar numclusters_cctrw = r(numclusters_cct)
			scalar numclusters_cctrw_res = r(numclusters_res_cct)
		
		reweight_est bcg_z, ptestimaterun
			scalar effect_ik= r(effect)
			scalar effect_ik_a = r(effect_a)
			scalar effect_ik_b = r(effect_b)
			scalar effect_ik_res = r(effect_res)
			scalar effect_ik_a_res = r(effect_a_res)
			scalar effect_ik_b_res = r(effect_b_res)
			scalar samplesize_ik = r(samplesize)
			scalar samplesize_ik_res = r(samplesize_res)
			scalar numclusters_ik = r(numclusters)
			scalar numclusters_ik_res = r(numclusters_res)
			
			scalar effect_cct = r(effect_cct)
			scalar effect_cct_a = r(effect_a_cct)
			scalar effect_cct_b = r(effect_b_cct)
			scalar effect_cct_res = r(effect_res_cct)
			scalar effect_cct_a_res = r(effect_a_res_cct)
			scalar effect_cct_b_res = r(effect_b_res_cct)
			scalar samplesize_ik_cct = r(samplesize_cct)
			scalar samplesize_ik_res_cct = r(samplesize_res_cct)
			scalar numclusters_cct = r(numclusters_cct)
			scalar numclusters_cct_res = r(numclusters_res_cct)
			
*Get bootstrap estimates. Open 20 copies of Stata, each of which will implement 10 bootstrap replications
*Note, this requires more than 20 cores on your processor. To make it work with less, cores you'll need to
*decrease the number of instances below, and increase the `numbs' local in parfor.do
	set rng mt64s

	forvalues instance = 1(1)20 {
		clear
		set obs 1
		gen stream = `instance'
		save "curstream.dta", replace
		winexec "${statapath}" do "${adofolder}parfor.ado"
		sleep 5000
	}
	
STOP AND WAIT HERE FOR BOOTSTRAPS TO COMPLETE		
			
*Report bootstrap inference results
	use "bootstrap_estimates.dta", clear
	
	foreach suff in "ikrw" "ik" "cctrw" "cct" {
		summ effect_`suff'
		scalar effect_sd_`suff'= r(sd)
		summ effect_`suff'_a
		scalar effect_sd_`suff'_a= r(sd)
		summ effect_`suff'_b
		scalar effect_sd_`suff'_b= r(sd)
		summ effect_`suff'_res
		scalar effect_sd_`suff'_res= r(sd)
		summ effect_`suff'_a_res
		scalar effect_sd_`suff'_a_res= r(sd)
		summ effect_`suff'_b_res
		scalar effect_sd_`suff'_b_res= r(sd)		
	}
	
	destring stream, replace
	local nplusone = _N+1
	set obs `nplusone'
	replace b=-1 if _n==`nplusone'
	
	foreach suff in "ikrw" "ik" "cctrw" "cct" {
		replace effect_`suff' = scalar(effect_`suff') if _n==`nplusone'
		replace effect_`suff'_a = scalar(effect_`suff'_a) if _n==`nplusone'
		replace effect_`suff'_b = scalar(effect_`suff'_b) if _n==`nplusone'
		replace effect_`suff'_res = scalar(effect_`suff'_res) if _n==`nplusone'
		replace effect_`suff'_a_res = scalar(effect_`suff'_a_res) if _n==`nplusone'
		replace effect_`suff'_b_res = scalar(effect_`suff'_b_res) if _n==`nplusone'
	}
	
	sort b stream
	save "bootstrap_estimates_updated.dta", replace

*Display number of clusters for table (these will be passed to bootstrap as well)
	di "Number of clusters IK unweighted:"
	di scalar(numclusters_ik)
	di "Number of clusters IK reweighted:"
	di scalar(numclusters_ikrw)
	di "Number of clusters CCT unweighted:"
	di scalar(numclusters_cct)
	di "Number of clusters CCT reweighted:"
	di scalar(numclusters_cctrw)
	
*Report point estimates and confidence intervals
foreach suffix in "ikrw" "ik" "cctrw" "cct" {
	di "___`suffix'___"
	di "Point estimate: "
	di scalar(effect_`suffix')
	di "Bootstrap standard deviation: "
	di scalar(effect_sd_`suffix')
  	local tstat = scalar(effect_`suffix')/scalar(effect_sd_`suffix')
	di "T-statistic: `tstat'"
	local pval = 2*(abs(-normal(`tstat')))
	di "p-value: `pval'"
	local CIl = scalar(effect_`suffix') - 1.96*scalar(effect_sd_`suffix')
	local CIu = scalar(effect_`suffix') + 1.96*scalar(effect_sd_`suffix')
	di "95% confidence interval: [`CIl',`CIu']"
}

cap log close
	
