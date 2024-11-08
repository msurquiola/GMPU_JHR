

/* This code generates parts of  Tables 3, 4, 5, 10, 13 in the paper for the school level analysis */


cd  "/Users/kiki/Dropbox/JHR replication/"

use "JHR_data_2"


set more off

#delimit;
gen a=string(ua);
gen b=string(z);
gen c=string(Y);
gen d=string(sid);
gen e="Y";
gen f="z";

*tab ua; tab z; tab Y;

gen fx=a+b+c;
gen uazY=a+f+b+e+c;
gen sid2=d+e+c;
gen dg =1 if dzg >=0; replace dg =0 if dzg <0;
gen dga=1 if dzag>=0; replace dga=0 if dzag<0;
gen dk =1 if dzk >=0; replace dk =0 if dzk <0;
gen dka=1 if dzak>=0; replace dka=0 if dzak<0;
gen dgdzg=dg*dzg;

gen dzg2 =dzg *dzg ;
gen dzag2=dzag*dzag;
gen dzag_dga=dzag*dga;



#delimit;

/* define sample restrictions so that regression w/out controls have the same sample size as w/ controls */;




gen earlier=0;
replace earlier=1 if cohort==2005 & year==1989 & month>=10 &  month<=12;
replace earlier=1 if cohort==2006 & year==1990 & month>=10 &  month<=12;
gen later=0;
replace later=1 if cohort==2005 & year==1991 & month>=1 &  month<=3;
replace later=1 if cohort==2006 & year==1992 & month>=1 &  month<=3;
gen sample2=1 if cohort==2005 & birthmonth>=-8 &  birthmonth<=9;
replace sample2=1 if cohort==2006 & birthmonth>=4 &  birthmonth<=21;



forvalues bmonth=1/12 {;
	quietly gen byte bmonth_`bmonth'=0 if month!=.;
	quietly replace bmonth_`bmonth'=1 if month==`bmonth';
};

gen month2=month*month/10;

*sort highschool cohort county;
*by  highschool cohort county: egen school_grade=mean(grade);

gen school_grade=agus;

global restrict1 " bmonth!=.";
drop after;
gen after=( birthmonth>=0);


egen bct_z05 = std(bct) if cohort==2005;
egen bct_z06 = std(bct) if cohort==2006;
gen bct_z= bct_z05;
replace bct_z= bct_z06 if bct_z==.;

egen bcg_z05 = std(bcg) if cohort==2005;
egen bcg_z06 = std(bcg) if cohort==2006;
gen bcg_z= bcg_z05;
replace bcg_z= bcg_z06 if bcg_z==.;

#delimit;
egen bcgr_z05 = std(bcgr) if cohort==2005;
egen bcgr_z06 = std(bcgr) if cohort==2006;
gen bcgr_z= bcgr_z05;
replace bcgr_z= bcgr_z06 if bcgr_z==.;


replace cohort=cohort-2005;



gen before = 0 if bmonth~=.;
replace before = 1 if bmonth>=0 & bmonth<=6;
gen unwanted = ( birthmonth<0) if birthmonth~=.;
gen wanted=!unwanted if unwanted!=.;

gen dga_before=dga*before;

gen dzag_before=dzag*before;
gen dzag_dga_before=dzag_dga*before;

#delimit;
gen dga_cohort=dga*cohort;
gen dzag_cohort=dzag*cohort;
gen dzag_dga_cohort=dzag_dga*cohort;

gen dga_month=dga*month;
gen dzag_month=dzag*month;
gen dzag_dga_month=dzag_dga*month;

gen dga_month2=dga*month2;
gen dzag_month2=dzag*month2;
gen dzag_dga_month2=dzag_dga*month2;

gen dga_wanted=dga*wanted;
gen dzag_wanted=dzag*wanted;
gen dzag_dga_wanted=dzag_dga*wanted;

forvalues bmonth=1/12 {;
	quietly gen byte dga_bmonth_`bmonth'=0 if month!=. & dga!=.;
	quietly replace dga_bmonth_`bmonth'=dga if month==`bmonth';
	
	quietly gen byte dzag_bmonth_`bmonth'=0 if month!=. & dzag!=.;
	quietly replace dzag_bmonth_`bmonth'=dzag  if month==`bmonth';
	
	quietly gen byte dzag_dga_bmonth_`bmonth'=0 if month!=. & dzag_dga!=.;
	quietly replace dzag_dga_bmonth_`bmonth'=dzag_dga if month==`bmonth';
	

};



gen nonpoor=1-poor;
gen dga_nonpoor=dga*nonpoor;
gen dzag_nonpoor=dzag*nonpoor;
gen dzag_dga_nonpoor=dzag_dga*nonpoor;



*****TABLE 3 SCHOOL LEVEL;

preserve;
keep if agus!=. & sample==1;  
rdob_mod2 agus dzag; global bw=r(h_opt); display bcgr " : " $bw; 
areg agus  dga dzag dzag_dga if sample==1 & dzag>=-$bw  & dzag<$bw   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table3_school.out, se  bracket  ctitle("IK") append;

restore;
preserve;
keep if agus!=. & sample==1;  
rdbwselect agus dzag , c(0) ; global bwCCT=e(h_mserd);
areg agus  dga dzag dzag_dga if sample==1 & dzag>=-$bwCCT  & dzag<$bwCCT   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table3_school.out, se  bracket  ctitle("CCT") append;



restore;
preserve;
keep if bct_z!=. & sample==1;  
rdob_mod2 bct_z dzag; global bw=r(h_opt); display bcgr " : " $bw; 
areg bct_z  dga dzag dzag_dga if sample==1 & dzag>=-$bw  & dzag<$bw   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table3_school.out, se  bracket  ctitle("IK") append;

restore;
preserve;
keep if bct_z!=. & sample==1;  
rdbwselect bct_z dzag , c(0) ; global bwCCT=e(h_mserd);
areg bct_z  dga dzag dzag_dga if sample==1 & dzag>=-$bwCCT  & dzag<$bwCCT   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table3_school.out, se  bracket  ctitle("CCT") append;



restore;
preserve;
keep if bcg_z!=. & sample==1;  
rdob_mod2 bcg_z dzag; global bw=r(h_opt); display bcgr " : " $bw; 
areg bcg_z  dga dzag dzag_dga if sample==1 & dzag>=-$bw  & dzag<$bw   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table3_school.out, se  bracket  ctitle("IK") append;

restore;
preserve;
keep if bcg_z!=. & sample==1;  
rdbwselect bcg_z dzag , c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga dzag dzag_dga if sample==1 & dzag>=-$bwCCT  & dzag<$bwCCT   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table3_school.out, se  bracket  ctitle("CCT") append;

restore;
preserve;
keep if bcgr_z!=. & sample==1;  
rdob_mod2 bcgr_z dzag; global bw=r(h_opt); display bcgr " : " $bw; 
areg bcgr_z  dga dzag dzag_dga if sample==1 & dzag>=-$bw  & dzag<$bw   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table3_school.out, se  bracket  ctitle("IK") append;

restore;
preserve;
keep if bcgr_z!=. & sample==1;  
rdbwselect bcgr_z dzag , c(0) ; global bwCCT=e(h_mserd);
areg bcgr_z  dga dzag dzag_dga if sample==1 & dzag>=-$bwCCT  & dzag<$bwCCT   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table3_school.out, se  bracket  ctitle("CCT") append;




*****TABLE 4 SCHOOL LEVEL;

#delimit;
restore;

#delimit;
preserve;

keep if bcg_z!=. & sample==1 & year==1990 & bmonth>=1 & bmonth<=6;  
rdob_mod2 bcg_z dzag; global bw=r(h_opt); display bcgr " : " $bw; 
areg bcg_z  dga dzag dzag_dga if sample==1 & year==1990 & bmonth>=1 & bmonth<=6    &  dzag>=-$bw  & dzag<$bw   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table4_BCG.out, se  bracket  ctitle("IK") ;


restore;
preserve;
keep if bcg_z!=. & sample==1 & year==1990 & bmonth>=1 & bmonth<=6;  
rdbwselect bcg_z dzag , c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga dzag dzag_dga if sample==1 & year==1990 & bmonth>=1 & bmonth<=6    &  dzag>=-$bwCCT  & dzag<$bwCCT   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table4_BCG.out, se  bracket  ctitle("CCT") append;

restore;
preserve;
keep if bcg_z!=. & sample==1 & year==1991 & bmonth>=1 & bmonth<=6;  
rdob_mod2 bcg_z dzag; global bw=r(h_opt); display bcgr " : " $bw; 
areg bcg_z  dga dzag dzag_dga if sample==1 & year==1991 & bmonth>=1 & bmonth<=6    &  dzag>=-$bw  & dzag<$bw   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table4_BCG.out, se  bracket  ctitle("IK") append;


restore;
preserve;
keep if bcg_z!=. & sample==1 & year==1991 & bmonth>=1 & bmonth<=6;  
rdbwselect bcg_z dzag , c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga dzag dzag_dga if sample==1 & year==1991 & bmonth>=1 & bmonth<=6    &  dzag>=-$bwCCT  & dzag<$bwCCT   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table4_BCG.out, se  bracket  ctitle("CCT") append;


restore;
preserve;
keep if bcg_z!=. & sample==1 & year==1990 & bmonth>=7 & bmonth<=12;  
rdob_mod2 bcg_z dzag; global bw=r(h_opt); display bcgr " : " $bw; 
areg bcg_z  dga dzag dzag_dga if sample==1 & year==1990 & bmonth>=7 & bmonth<=12    &  dzag>=-$bw  & dzag<$bw   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table4_BCG.out, se  bracket  ctitle("IK") append;


restore;
preserve;
keep if bcg_z!=. & sample==1 & year==1990 & bmonth>=7 & bmonth<=12;  
rdbwselect bcg_z dzag , c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga dzag dzag_dga if sample==1 & year==1990 & bmonth>=7 & bmonth<=12    &  dzag>=-$bwCCT  & dzag<$bwCCT   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table4_BCG.out, se  bracket  ctitle("CCT") append;

restore;
preserve;
keep if bcg_z!=. & sample==1 & year==1991 & bmonth>=7 & bmonth<=12;  
rdob_mod2 bcg_z dzag; global bw=r(h_opt); display bcgr " : " $bw; 
areg bcg_z  dga dzag dzag_dga if sample==1 & year==1991 & bmonth>=7 & bmonth<=12    &  dzag>=-$bw  & dzag<$bw   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table4_BCG.out, se  bracket  ctitle("IK") append;

restore;
preserve;
keep if bcg_z!=. & sample==1 & year==1991 & bmonth>=7 & bmonth<=12;  
rdbwselect bcg_z dzag , c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga dzag dzag_dga if sample==1 & year==1991 & bmonth>=7 & bmonth<=12    &  dzag>=-$bwCCT  & dzag<$bwCCT   & dzag~=0, robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table4_BCG.out, se  bracket  ctitle("CCT") append;




*****TABLE 5 AND APP TABLE 2 - SCHOOL LEVEL ;


restore;
#delimit;
preserve;
keep if bcg_z!=. & sample==1;  
rdob_mod2 bcg_z dzag; global bw=r(h_opt); display bcg_z " : " $bw; 
areg bcg_z  dga wanted dga_wanted dzag dzag_dga dzag_wanted dzag_dga_wanted cohort dga_cohort dzag_cohort dzag_dga_cohort  before dga_before dzag_before dzag_dga_before if  $restrict1 & sample==1  &  dzag>=-$bw  & dzag<$bw   &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table5_U_BCG.out, se  bracket  ctitle("IK") replace;
areg bcg_z  dga wanted dga_wanted dzag dzag_dga  month  dga_month dzag_month dzag_dga_month    dzag_wanted dzag_dga_wanted cohort dga_cohort dzag_cohort dzag_dga_cohort if  $restrict1 & sample==1  &  dzag>=-$bw  & dzag<$bw   &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table5_U_BCG.out, se  bracket  ctitle("IK") append;


restore;
preserve;
keep if bcg_z!=. & sample==1;  
rdbwselect bcg_z dzag , covs(wanted  before dzag_wanted  dzag_before cohort  dzag_cohort) c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga wanted dga_wanted dzag dzag_dga dzag_wanted dzag_dga_wanted cohort dga_cohort dzag_cohort dzag_dga_cohort  before dga_before dzag_before dzag_dga_before if  $restrict1 & sample==1  &   dzag>=-$bwCCT  & dzag<$bwCCT    &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table5_U_BCG.out, se  bracket  ctitle("CCT") append;

restore;
preserve;
keep if bcg_z!=. & sample==1;
rdbwselect bcg_z dzag , covs(wanted   month  dzag_month     dzag_wanted cohort dzag_cohort) c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga wanted dga_wanted dzag dzag_dga  month  dga_month dzag_month dzag_dga_month    dzag_wanted dzag_dga_wanted cohort dga_cohort dzag_cohort dzag_dga_cohort if  $restrict1 & sample==1  &   dzag>=-$bwCCT  & dzag<$bwCCT    &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table5_U_BCG.out, se  bracket  ctitle("CCT") append;


restore;
preserve;
keep if bcgr_z!=. & sample==1;  
rdob_mod2 bcgr_z dzag; global bw=r(h_opt); display bcgr_z " : " $bw; 
areg bcgr_z  dga wanted dga_wanted dzag dzag_dga dzag_wanted dzag_dga_wanted cohort dga_cohort dzag_cohort dzag_dga_cohort  before dga_before dzag_before dzag_dga_before if  $restrict1 & sample==1  &  dzag>=-$bw  & dzag<$bw   &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable2_U_BCGR.out, se  bracket  ctitle("IK") replace;
areg bcgr_z  dga wanted dga_wanted dzag dzag_dga  month  dga_month dzag_month dzag_dga_month    dzag_wanted dzag_dga_wanted cohort dga_cohort dzag_cohort dzag_dga_cohort if  $restrict1 & sample==1  &  dzag>=-$bw  & dzag<$bw   &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable2_U_BCGR.out, se  bracket  ctitle("IK") append;


restore;
preserve;
keep if bcgr_z!=. & sample==1;  
rdbwselect bcgr_z dzag , covs(wanted  before dzag_wanted  dzag_before cohort  dzag_cohort) c(0) ; global bwCCT=e(h_mserd);
areg bcgr_z  dga wanted dga_wanted dzag dzag_dga dzag_wanted dzag_dga_wanted cohort dga_cohort dzag_cohort dzag_dga_cohort  before dga_before dzag_before dzag_dga_before if  $restrict1 & sample==1  &   dzag>=-$bwCCT  & dzag<$bwCCT    &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable2_U_BCGR.out, se  bracket  ctitle("CCT") append;

restore;
preserve;
keep if bcgr_z!=. & sample==1;  
rdbwselect bcg_z dzag , covs(wanted   month  dzag_month     dzag_wanted cohort dzag_cohort) c(0) ; global bwCCT=e(h_mserd);
areg bcgr_z  dga wanted dga_wanted dzag dzag_dga  month  dga_month dzag_month dzag_dga_month    dzag_wanted dzag_dga_wanted cohort dga_cohort dzag_cohort dzag_dga_cohort if  $restrict1 & sample==1  &   dzag>=-$bwCCT  & dzag<$bwCCT    &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable2_U_BCGR.out, se  bracket  ctitle("CCT") append;




restore;
preserve;
keep if bcg_z!=. & sample==1;  
rdob_mod2 bcg_z dzag; global bw=r(h_opt); display bcg_z " : " $bw; 
areg bcg_z  dga wanted dga_wanted dzag dzag_dga dzag_wanted cohort dga_cohort dzag_cohort   before dga_before dzag_before  if  $restrict1 & sample==1  &  dzag>=-$bw  & dzag<$bw   &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table5_R_BCG.out, se  bracket  ctitle("IK") replace;
areg bcg_z  dga wanted dga_wanted dzag dzag_dga  month  dga_month dzag_month     dzag_wanted cohort dga_cohort dzag_cohort  if  $restrict1 & sample==1  &  dzag>=-$bw  & dzag<$bw   &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table5_R_BCG.out, se  bracket  ctitle("IK") append;

restore;
preserve;
keep if bcg_z!=. & sample==1;  
rdbwselect bcg_z dzag , covs(wanted  before dzag_wanted  dzag_before cohort  dzag_cohort) c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga wanted dga_wanted dzag dzag_dga dzag_wanted cohort dga_cohort dzag_cohort   before dga_before dzag_before  if  $restrict1 & sample==1  &   dzag>=-$bwCCT  & dzag<$bwCCT    &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table5_R_BCG.out, se  bracket  ctitle("CCT") append;

restore;
preserve;
keep if bcg_z!=. & sample==1;  
rdbwselect bcg_z dzag , covs(wanted   month  dzag_month     dzag_wanted cohort dzag_cohort) c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga wanted dga_wanted dzag dzag_dga  month  dga_month dzag_month     dzag_wanted cohort dga_cohort dzag_cohort  if  $restrict1 & sample==1  &   dzag>=-$bwCCT  & dzag<$bwCCT    &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using Table5_R_BCG.out, se  bracket  ctitle("CCT") append;



restore;
preserve;
keep if bcgr_z!=. & sample==1;  
rdob_mod2 bcgr_z dzag; global bw=r(h_opt); display bcgr_z " : " $bw; 
areg bcgr_z  dga wanted dga_wanted dzag dzag_dga dzag_wanted cohort dga_cohort dzag_cohort   before dga_before dzag_before  if  $restrict1 & sample==1  &  dzag>=-$bw  & dzag<$bw   &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable2_R_BCGR.out, se  bracket  ctitle("IK") replace;
areg bcgr_z  dga wanted dga_wanted dzag dzag_dga  month  dga_month dzag_month     dzag_wanted cohort dga_cohort dzag_cohort  if  $restrict1 & sample==1  &  dzag>=-$bw  & dzag<$bw   &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable2_R_BCGR.out, se  bracket  ctitle("IK") append;


restore;
preserve;
keep if bcgr_z!=. & sample==1;  
rdbwselect bcgr_z dzag , covs(wanted  before dzag_wanted  dzag_before cohort  dzag_cohort) c(0) ; global bwCCT=e(h_mserd);
areg bcgr_z  dga wanted dga_wanted dzag dzag_dga dzag_wanted cohort dga_cohort dzag_cohort   before dga_before dzag_before  if  $restrict1 & sample==1  &   dzag>=-$bwCCT  & dzag<$bwCCT    &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable2_R_BCGR.out, se  bracket  ctitle("CCT") append;

restore;
preserve;
keep if bcgr_z!=. & sample==1; 
rdbwselect bcg_z dzag , covs(wanted   month  dzag_month     dzag_wanted cohort dzag_cohort) c(0) ; global bwCCT=e(h_mserd);
areg bcgr_z  dga wanted dga_wanted dzag dzag_dga  month  dga_month dzag_month     dzag_wanted cohort dga_cohort dzag_cohort  if  $restrict1 & sample==1  &   dzag>=-$bwCCT  & dzag<$bwCCT    &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable2_R_BCGR.out, se  bracket  ctitle("CCT") append;
restore;





***** APP TABLE 5 PANEL B SCHOOL LEVEL ***;

preserve;
keep if bcg_z!=. & sample==1;  
rdob_mod2 bcg_z dzag; global bw=r(h_opt); display bcg_z " : " $bw; 
areg bcg_z  dga nonpoor dga_nonpoor dzag dzag_dga dzag_nonpoor dzag_dga_nonpoor cohort dga_cohort dzag_cohort dzag_dga_cohort  before dga_before dzag_before dzag_dga_before if  $restrict1 & sample==1  &  dzag>=-$bw  & dzag<$bw   &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable5_U_BCG.out, se  bracket  ctitle("IK") replace;
areg bcg_z  dga nonpoor dga_nonpoor dzag dzag_dga  month  dga_month dzag_month dzag_dga_month    dzag_nonpoor dzag_dga_nonpoor cohort dga_cohort dzag_cohort dzag_dga_cohort if  $restrict1 & sample==1  &  dzag>=-$bw  & dzag<$bw   &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable5_U_BCG.out, se  bracket  ctitle("IK") append;


restore;
preserve;
keep if bcg_z!=. & sample==1;  
rdbwselect bcg_z dzag , covs(nonpoor  before dzag_nonpoor  dzag_before cohort  dzag_cohort) c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga nonpoor dga_nonpoor dzag dzag_dga dzag_nonpoor dzag_dga_nonpoor cohort dga_cohort dzag_cohort dzag_dga_cohort  before dga_before dzag_before dzag_dga_before if  $restrict1 & sample==1  &   dzag>=-$bwCCT  & dzag<$bwCCT    &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable5_U_BCG.out, se  bracket  ctitle("CCT") append;

restore;
preserve;
keep if bcg_z!=. & sample==1;
rdbwselect bcg_z dzag , covs(nonpoor   month  dzag_month     dzag_nonpoor cohort dzag_cohort) c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga nonpoor dga_nonpoor dzag dzag_dga  month  dga_month dzag_month dzag_dga_month    dzag_nonpoor dzag_dga_nonpoor cohort dga_cohort dzag_cohort dzag_dga_cohort if  $restrict1 & sample==1  &   dzag>=-$bwCCT  & dzag<$bwCCT    &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable5_U_BCG.out, se  bracket  ctitle("CCT") append;



*****APP TABLE 5 PANEL C SCHOOL LEVEL****;

restore;
preserve;
keep if bcg_z!=. & sample==1;  
rdob_mod2 bcg_z dzag; global bw=r(h_opt); display bcg_z " : " $bw; 
areg bcg_z  dga wanted dga_wanted  nonpoor dga_nonpoor dzag_wanted dzag_dga_wanted  dzag dzag_dga dzag_nonpoor dzag_dga_nonpoor cohort dga_cohort dzag_cohort dzag_dga_cohort  before dga_before dzag_before dzag_dga_before  if  $restrict1 & sample==1  &  dzag>=-$bw  & dzag<$bw   &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable5_interU_BCG.out, se  bracket  ctitle("IK") append;
areg bcg_z  dga wanted dga_wanted  nonpoor dga_nonpoor dzag dzag_wanted dzag_dga_wanted dzag_dga  month  dga_month dzag_month dzag_dga_month    dzag_nonpoor dzag_dga_nonpoor cohort dga_cohort dzag_cohort dzag_dga_cohort  if  $restrict1 & sample==1  &  dzag>=-$bw  & dzag<$bw   &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable5_interU_BCG.out, se  bracket  ctitle("IK") append;


restore;
preserve;
keep if bcg_z!=. & sample==1;  
rdbwselect bcg_z dzag , covs(wanted dzag_wanted nonpoor  before dzag_nonpoor  dzag_before cohort  dzag_cohort) c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga wanted dga_wanted  nonpoor dga_nonpoor dzag_wanted dzag_dga_wanted  dzag dzag_dga dzag_nonpoor dzag_dga_nonpoor cohort dga_cohort dzag_cohort dzag_dga_cohort  before dga_before dzag_before dzag_dga_before  if  $restrict1 & sample==1  &   dzag>=-$bwCCT  & dzag<$bwCCT    &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable5_interU_BCG.out, se  bracket  ctitle("CCT") append;

restore;
preserve;
keep if bcg_z!=. & sample==1;
rdbwselect bcg_z dzag , covs(wanted dzag_wanted nonpoor   month  dzag_month     dzag_nonpoor cohort dzag_cohort) c(0) ; global bwCCT=e(h_mserd);
areg bcg_z  dga wanted dga_wanted  nonpoor dga_nonpoor dzag dzag_wanted dzag_dga_wanted dzag_dga  month  dga_month dzag_month dzag_dga_month    dzag_nonpoor dzag_dga_nonpoor cohort dga_cohort dzag_cohort dzag_dga_cohort  if  $restrict1 & sample==1  &   dzag>=-$bwCCT  & dzag<$bwCCT    &                       dzag~=0           , robust cluster(sid2) absorb(uazY) ; 
outreg2 using AppTable5_interU_BCG.out, se  bracket  ctitle("CCT") append;




restore;





