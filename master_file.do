/*******************************************************************************

							MASTER FILE FOR REPLICATION
								    25.06.2019
							
*******************************************************************************/
clear all
set more off
cap log close

********************************************************************************
*** I. SET PATHS TO DIRECTORIES ************************************************
***
*** These paths are used in the replication files. It is important to define them
*** before running the code. 
***
*** Data for replication can be download from https://andresbarriosf.github.io
***
********************************************************************************

*** 1. DATASETS AND CODE 
global d  "/Users/andresbarriosfernandez/Google Drive/Data FSD Replication" 
global code "/Users/andresbarriosfernandez/Documents/GitHub/FSD"

*** 2. DIRECTORIES FOR STORING RESULTS:

***** 2.1 General Tables:  
global tex "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION" 

***** 2.2 Tables of Main effects
global tex_linear "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION" 
global tex_cum 	  "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION" 

***** 2.3 Tables of Heterogeneity by School Type
global tex_school   "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"
global tex_multiple "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"

***** 2.4 Tables of Heterogeneity by Resources at Home:
global tex_edu   "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"
global tex_books "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"  
global tex_ITC   "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"  

***** 2.5 Tables of Robustness checks
global tex_infra "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"  
global tex_sep   "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION" 

***** 2.5 Summary statistics and event studies
global tex_stat "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"
global tex_pisa "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"
global tex_es   "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"
  
***** 2.6 Charts  
global graphs              "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"
global graphs_es_simce     "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"
global graphs_es_teachers  "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"
global graphs_es_transfers "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"
global graphs_es_csize     "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"
global graphs_es_subjects  "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"

*** 3. LOG FILES
global log "/Users/andresbarriosfernandez/Dropbox/FSD REPLICATION"

********************************************************************************
*** II. PREPROCESSIN RAW DATA  *************************************************
********************************************************************************

*** The raw data is subject to some restrictions that prevent us from making it 
*** publicly available.

*** There are some datasets that are public and can be found on the Ministry of 
*** Education website: http://datosabiertos.mineduc.cl/. 

*** The datasets containing individual test scores, as well as the ones containing 
*** the answers to parental and teachers surveys applied at the same time as the 
*** SIMCE are managed by the Education Quality Agency. In order to gain access to
*** this data it is necessary to present a research  proposal completing the 
*** following form:
*** https://s3.amazonaws.com/archivos.agenciaeducacion.cl/documentos-web/Formulario_de_Solicitud_Bases_de_Datos.pdf
*** This data cannot be shared with third parties.

*** We also use other datasets:
*** - Longitudinal Teachers Survey (2005): to gain access to it, one has to contact
***   the Research Center of the Ministry of Education (estadisticas@mineduc.cl). 
***   They have a form that researchers need to fill before submission. 

*** - DESUC Survey use of Time: we gain access to this dataset directly from the 
***   former director of the DESUC. This institution does not exist anylonger, but 
***   we made this dataset available in our repository.

*** - Use of Time Survey (2015): the original dataset can be download from the following
***   link: https://www.ine.cl/estadisticas/menu-sociales/enut

*** - PISA datasets can be download from the following dataset:
***   https://www.oecd.org/pisa/data/

*** In order to implement our main analysis we combine many of these files. Since 
*** some of them cannot be made public, to facilitate the replication of our results 
*** we created a set of datasets in which we hide the identity of schools and individuals:

*** - fsd_final_dataset_for_analysis_replication.dta: to replicate main effects, 
***   heterogeneous effects and robustness checks analysis.
*** - event_study_xxxx.dta: to replicate event studies.
*** - fsd_adoption.dta: to replicate figure with adoption shares.
*** - pisa_autonomy.dta: to replicate table describing differences in school autonomy.
*** - teachers_opinion.dta: to replicate table showing differences in teachers opinion 
***   about the FSD.
*** - homework_frequency.dta: to replicate table about homework frequency.
*** - school_choice.dta: to replicate ranking of main reasons to choose a school.
*** - school_use_of_time.dta: to replicate table with schools use of time after adopting FSD.
*** - BASE_USUARIO_corregida: to replicate tables about additional support at home 
***   (https://www.ine.cl/estadisticas/menu-sociales/enut)

*** Preprocessing code is available upon request. 

********************************************************************************
*** III. DESCRIPTIVE STATISTICS ************************************************
********************************************************************************
do "${code}/Descriptive statistics and tables/summary_statistics_replication.do" // sum. stat. of the master sample
do "${code}/Descriptive statistics and tables/fsd_adoption_chart.do"             // FSD adoption pattern
do "${code}/Descriptive statistics and tables/fsd_opinion.do"                    // teacher opinion about the FSD
do "${code}/Descriptive statistics and tables/use_of_time_at_school.do"          // DESUC 2005 survey about use of time
do "${code}/Descriptive statistics and tables/use_of_time_information.do"        // support received by students outside school and homework frequency - time use survey
do "${code}/Descriptive statistics and tables/homework_frequency.do"             // homework frequency - teacher survey
do "${code}/Descriptive statistics and tables/PISAstatistics.do"                 // sum. stat. from PISA
do "${code}/Descriptive statistics and tables/school_choice_table.do"           // main determinants of school choices

********************************************************************************
*** IV. REGRESSION - MAIN MODELS ***********************************************
********************************************************************************
do "${code}/Main Analysis/regression_main_models_replication.do"

********************************************************************************
*** V. REGRESSION - HETEROGENEOUS MODELS ***************************************
********************************************************************************
do "${code}/Main Analysis/regression_heterogeneous_models_replication.do"

********************************************************************************
*** VI. ROBUSTNESS CHECKS ******************************************************
********************************************************************************
do "${code}/Main Analysis/robustness_checks_replication.do"

********************************************************************************
*** VII. EVENT STUDIES *********************************************************
********************************************************************************
do "${code}/Event studies/event_study_simce_scores.do"
do "${code}/Event studies/event_study_teachers.do"
do "${code}/Event studies/event_study_transfers.do"
do "${code}/Event studies/event_study_class_size.do"
do "${code}/Event studies/event_study_subjects.do"

