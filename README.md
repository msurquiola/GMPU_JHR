# GMPU_JHR
Replication data and code for Goff, Malamud, Pop-Eleches and Urquiola, Journal of Human Resources 2025: "Interactions Between Family and School Environments: Access to Abortion and Selective Schools"

**Data files**

For the administrative data there are three datafiles:
- JHR_data_1.dta
- JHR_data_2.dta
- JHR_data_3.dta

For the survey data there is one datafile:
- JHR_data_5.dta

For the Census data there is one datafile:
- JHR_data_6.dta

**Do files**
	
For the administrative data there are three Do files:
- replication_data_1.do (Table 1 Panel A, Table 2 and Figure 2 in the paper)
- replication_data_2.do (Tables 3, 4, 5, App. Table 2, App. Table 5 in the paper for the school level analysis)
- replication_data_3.do (Tables 3, 4, 7, App. Table 3 in the paper for the track level analysis)
- replication_prepare_2.do (this Do file loads in JHR_data_2.dta, and produces ready_to_reweight.dta, which is used by replication_data_4.do)
- replication_data_4.do (Table 8, results of the reweighting estimator)

For the survey data there is one dofile:
- replication_data_5.do (Table 6, results using the survey data)

For the Census data there is one dofile:
- replication_data_6.do (Appendix Table 4, results using the Census data)

Also, the following two Stata ADO program files are used by replication_data_4.do:
- reweight_est_impute.ado
- parfor.ado
- rdob_mod2.ado

