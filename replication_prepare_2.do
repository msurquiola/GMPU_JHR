
/* This code takes the old data mergedY567_pov.dta which is the mergedY567.dta from the AER with the poverty variable added to generate the JHR replication data JHR_data_2 */


use "adminitrative_data_Dec2018.dta"

cd  "/Users/kiki/Dropbox/JHR replication/"



replace poor=0 if poor==.

drop if Y==7

drop if ua==20304 & Y==6
drop if ua==20572 & Y==6
drop if ua==35740 & Y==6
drop if ua==100585 & Y==6
drop if ua==36015 & Y==6
drop if ua==101305 & Y==6


keep ua z Y sid dzg zga us dzag  dzk dzak after cohort year month birthmonth bmonth agus bct bcg bcgr grade sample poor


save JHR_data_2, replace
