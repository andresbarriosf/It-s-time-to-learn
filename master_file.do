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
*** Data for replication can be downloaded from https://andresbarriosf.github.io
***
********************************************************************************

*** 1. DATASETS AND CODE 
*** Paths to the data and to the code
global d  "" 
global code ""

*** 2. DIRECTORIES FOR STORING RESULTS:

***** 2.1 Path to .tex files saved by the program:  
global tex "" 

***** 2.2 Paths to save tables of main effects
global tex_linear "" 
global tex_cum 	  "" 

***** 2.3 Paths to sabe tables of heterogeneity by school type
global tex_school   ""
global tex_multiple ""

***** 2.4 Paths to sabe tables of heterogeneity by resources at home:
global tex_edu   ""
global tex_books ""
global tex_ITC   ""

***** 2.5 Paths to save tables of robustness checks
global tex_infra ""
global tex_sep   ""

***** 2.5 Paths to save summary statistics and event studies
global tex_stat ""
global tex_pisa ""
global tex_es   ""
  
***** 2.6 Paths to save Charts  
global graphs              ""
global graphs_es_simce     ""
global graphs_es_teachers  ""
global graphs_es_transfers ""
global graphs_es_csize     ""
global graphs_es_subjects  ""

*** 3. LOG FILES
*** Path to save log files:
global log ""

********************************************************************************
*** II. PREPROCESSING RAW DATA  *************************************************
********************************************************************************

*** The raw data used in this project is subject to some restrictions that prevent 
*** us from making it publicly available.

*** Some datasets however are public and can be found on the Ministry of Education
*** website: http://datosabiertos.mineduc.cl/. 

*** The datasets containing individual test scores (SIMCE), as well as the ones 
*** containing the answers to surveys applied to parents and teachers at the same 
*** time as the SIMCE are managed by the Education Quality Agency. In order to gain 
*** access to this data it is necessary to present a research  proposal completing 
*** the following form:
*** https://s3.amazonaws.com/archivos.agenciaeducacion.cl/documentos-web/Formulario_de_Solicitud_Bases_de_Datos.pdf
*** This data cannot be shared with third parties.

*** We also use other datasets:
*** - Longitudinal Teachers Survey (2005): to gain access to it, one has to contact
***   the Research Center of the Ministry of Education (estadisticas@mineduc.cl). 
***   They have a form that researchers need to fill before getting access to the data. 

*** - DESUC Survey use of Time: we gain access to this dataset directly from the 
***   former director of the DESUC. This institution does not exist anymore, but 
***   we made this dataset available.

*** - Use of Time Survey (2015): the original dataset can be download from the following
***   link: https://www.ine.cl/estadisticas/menu-sociales/enut

*** - PISA datasets can be download from the following link:
***   https://www.oecd.org/pisa/data/

*** In order to implement the analysis presented in the paper we combine many of 
*** these files. Since some of them cannot be made public, to facilitate the 
*** replication of our results we created a set of datasets in which we hide the 
*** identity of schools and individuals and kept only key variables to satisfy 
*** the information protection policies of the agencies that provided us with the 
*** data. 

*** The individual and school identifiers used in these files are unique to each 
*** one of them. Therefore, these variables cannot be used to merge them. 

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

*** The preprocessing code used to clean the raw data is available upon request. 

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

