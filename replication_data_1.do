
/* This code generates Table 1 Panel A, Table 2 and Figure 2 in the paper */


cd  "/Users/kiki/Dropbox/JHR replication/"

use "JHR_data_1"



/* define some variables and sample restrictions so that regression w/out controls have the same sample size as w/ controls */

gen before=0

replace before=1 if cohort==2005 & year==1989 & month>=10 &  month<=12
replace before=1 if cohort==2006 & year==1990 & month>=10 &  month<=12

gen later=0
replace later=1 if cohort==2005 & year==1991 & month>=1 &  month<=3
replace later=1 if cohort==2006 & year==1992 & month>=1 &  month<=3

gen sample2=1 if cohort==2005 & birthmonth>=-8 &  birthmonth<=9
replace sample2=1 if cohort==2006 & birthmonth>=4 &  birthmonth<=21


forvalues bmonth=1/12 {
	quietly gen byte bmonth_`bmonth'=0 if month!=.
	quietly replace bmonth_`bmonth'=1 if month==`bmonth'
}

gen month2=month*month/10

sort highschool cohort county
by  highschool cohort county: egen school_grade=mean(grade)

gen high2=(profile1=="Teoretica")
gen high=(type2=="Liceal")

#delimit;

drop before;
gen before = 0 if bmonth~=.;
replace before = 1 if bmonth>=0 & bmonth<=6;
gen unwanted = ( birthmonth<0) if birthmonth~=.;
gen wanted=!unwanted if unwanted!=.;

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



global restrict1 " bmonth!=.";
drop after;
gen after=( birthmonth>=0);



****SUMMARY STATS TABLE 1 PANEL A;

sum grade school_grade high2 bct bcg bcgr ;


*****FIGURE 5;


#delimit;

regress grade  bmonth_* if sample==1, robust;
*drop grade ;
predict grade_r if e(sample), res;
regress school_grade  bmonth_* if sample==1, robust;
*drop school_grade ;
predict school_grade_r if e(sample), res;
regress high bmonth_* if sample==1, robust;
*drop high ;
predict high_r if e(sample), res;
regress high2  bmonth_* if sample==1, robust;
*drop high2;
predict high2_r if e(sample), res;
regress bct_z  bmonth_* if sample==1, robust;
*drop high2;
predict bct_r if e(sample), res;
regress bcg_z  bmonth_* if sample==1, robust;
*drop high2;
predict bcg_r if e(sample), res;

regress bcgr_z  bmonth_* if sample==1, robust;
*drop high2;
predict bcgr_r if e(sample), res;


preserve;

#delimit;
collapse grade_r  school_grade_r high_r  high2_r bcg_r bct_r bcgr_r if  sample==1 & year==1990 , by(birthmonth);
#delimit;
rename birthmonth month;
replace month=month+1;

*quietly replace month=month+.5;




#delimit;


scatter grade_r  month,	
	msymbol(Oh p p)
	mcolor(black black black)
	msize(medium small small)
	clwidth(medthick medthick medthick)
	clcolor(black black black)
	connect(l l l)
	sort
	legend(off)
	xlabel(-5 0 6)
	xscale(range(-5 0 6))
	ylabel(-.12 0)
	title(Panel A: Transition grade, position(11) size(medthick))
	ytitle(Average grade, size(small))
	xtitle(Month of birth, size(small))
	xline(0.5)
	scheme(s1color)
	saving("grade",replace);



#delimit;
scatter school_grade_r month ,
	msymbol(Oh p p)
	mcolor(black black black)
	msize(medium small small)
	clwidth(medthick medthick medthick)
	clcolor(black black black)
	connect(l l l)
	sort
	legend(off)
	xlabel(-5 0 6)
	xscale(range(-5 0 6))
	ylabel(-.07 -.02)
	title(Panel B: School grade average, position(11) size(medthick))
	ytitle(Average grade, size(small))
	xtitle(Month of birth, size(small))
	xline(0.5)
	scheme(s1color)
	saving("school_grade",replace);



#delimit;
scatter high2_r  month ,
	msymbol(Oh p p)
	mcolor(black black black)
	msize(medium small small)
	clwidth(medthick medthick medthick)
	clcolor(black black black)
	connect(l l l)
	sort
	legend(off)
	xlabel(-5 0 6)
	xscale(range(-5 0 6))
	ylabel(-0.02 0.02)
	title(Panel C: Academic high school, position(11) size(medthick))
	ytitle(Proportion, size(small))
	xtitle(Month of birth, size(small))
	xline(0.5)
	scheme(s1color)
	saving("high2",replace);

#delimit;
scatter bct_r  month ,
	msymbol(Oh p p)
	mcolor(black black black)
	msize(medium small small)
	clwidth(medthick medthick medthick)
	clcolor(black black black)
	connect(l l l)
	sort
	legend(off)
	xlabel(-5 0 6)
	xscale(range(-5 0 6))
	ylabel(-.01 .01)
	title(Panel D: Bacc taken, position(11) size(medthick))
	ytitle(Proportion, size(small))
	xtitle(Month of birth, size(small))
	xline(0.5)
	scheme(s1color)
	saving("bct",replace);


	#delimit;
scatter bcg_r  month ,
	msymbol(Oh p p)
	mcolor(black black black)
	msize(medium small small)
	clwidth(medthick medthick medthick)
	clcolor(black black black)
	connect(l l l)
	sort
	legend(off)
	xlabel(-5 0 6)
	xscale(range(-5 0 6))
	ylabel(-.02 .02)
	title(Panel E: Bacc grade, position(11) size(medthick))
	ytitle(Bacc grade, size(small))
	xtitle(Month of birth, size(small))
	xline(0.5)
	scheme(s1color)
	saving("bcg",replace);



	#delimit;
scatter bcgr_r  month ,
	msymbol(Oh p p)
	mcolor(black black black)
	msize(medium small small)
	clwidth(medthick medthick medthick)
	clcolor(black black black)
	connect(l l l)
	sort
	legend(off)
	xlabel(-5 0 6)
	xscale(range(-5 0 6))
	ylabel(-.02 .02)
	title(Panel F: Rom Bacc grade, position(11) size(medthick))
	ytitle(Rom Bacc grade, size(small))
	xtitle(Month of birth, size(small))
	xline(0.5)
	scheme(s1color)
	saving("bcgr",replace);



#delimit;

graph combine grade.gph school_grade.gph  high2.gph bct.gph bcg.gph bcgr.gph , ysize(8) xsize(7) holes(3 6)  scheme(s1color)  saving("Fig5",replace);

erase grade.gph ;
erase school_grade.gph ;
erase high2.gph ;


restore; 


*****TABLE 2;



#delimit;
global restrict1 " bmonth!=.";



reg grade wanted cohort before if $restrict1 & sample==1, robust cluster(birthmonth);
outreg2  using Table2, se bracket   ctitle("grade") replace;
reg grade wanted cohort month  if $restrict1 & sample==1, robust cluster(birthmonth);
outreg2  using Table2, se bracket   ctitle("grade") append;


reg school_grade wanted cohort before if $restrict1 & sample==1, robust cluster(birthmonth);
outreg2  using Table2, se bracket   ctitle("shigh2") append;
reg  school_grade wanted cohort month  if $restrict1 & sample==1, robust cluster(birthmonth);
outreg2  using Table2, se bracket   ctitle("shigh2") append;



reg high2 wanted cohort before if $restrict1 & sample==1, robust cluster(birthmonth);
outreg2  using Table2, se bracket   ctitle("high2") append;
reg high2 wanted cohort month if $restrict1 & sample==1, robust cluster(birthmonth);
outreg2  using Table2, se bracket   ctitle("high2 ") append;

reg bct_z wanted cohort before if $restrict1 & sample==1, robust cluster(birthmonth);
outreg2  using Table2, se bracket   ctitle("bcg_z ") append;
reg bct_z wanted cohort month  if $restrict1 & sample==1, robust cluster(birthmonth);
outreg2  using Table2, se bracket   ctitle("bcg_z ") append;

reg bcg_z wanted cohort before if $restrict1 & sample==1, robust cluster(birthmonth);
outreg2  using Table2, se bracket   ctitle("bcg_z ") append;
reg bcg_z wanted cohort month  if $restrict1 & sample==1, robust cluster(birthmonth);
outreg2  using Table2, se bracket   ctitle("bcg_z ") append;


reg bcgr_z wanted cohort before if $restrict1 & sample==1, robust cluster(birthmonth);
outreg2  using Table2, se bracket   ctitle("bcgr_z") append;
reg bcgr_z wanted cohort month  if $restrict1 & sample==1, robust cluster(birthmonth);
outreg2  using Table2, se bracket   ctitle("bcgr_z ") append;



#delimit;


