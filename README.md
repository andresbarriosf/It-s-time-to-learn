# It's time to learn: School Institutions and Returns to Instruction Time
**Andrés Barrios-Fernández and Giulia Bovini**
- This code allows to replicate the latest version of the paper (June, 2019). 
- The first version of the paper was published on March, 2017 (https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2932359). 
- There is also an older version of the paper published as a CEP Discussion Paper (http://cep.lse.ac.uk/pubs/download/dp1521.pdf)
- The current version corresponds to a revised version of the previous ones. 

This repository contains all the files required to replicate the results of **"It's Time to learn: School institutions and Returns to instruction time"**.  

## CODE 

All the do-files can be executed from the "master_file.do" and each one of them contains detailed explanations. 
1.  **"Descriptive Statistics and Tables"**: this folder contains the code used to create the summary statistics table and other descriptive statistics and figures that we present in the paper. 
2.  **"Main Analysis"**: this  folder contains the do-files needed to replicate the mean and heterogeneous effects analyses. 
3.  **"Event Studies"**: this folder contains the do-files that allow to replicate the event studies. 


## DATASETS 
The raw data is subject to some restrictions that prevent us from making it  publicly available.

1.  **Ministry of Education**: some datasets, including the students directory, the school directory, the teachers census and the date of adoption of the FSD in each school-grade can be found at the Ministry of Education website: http://datosabiertos.mineduc.cl/. 

2. **Education Quality Agency**: the datasets containing individual test scores, as well as the ones containing the answers to parents and teachers surveys applied at the same time as the SIMCE are managed by the Education Quality Agency. In order to gain access to this data it is necessary to present a research  proposal completing the following form:
https://s3.amazonaws.com/archivos.agenciaeducacion.cl/documentos-web/Formulario_de_Solicitud_Bases_de_Datos.pdf
This data cannot be shared with third parties.

3. **Other datasets**:
- Longitudinal Teachers Survey (2005): to gain access to it, one has to contact the Research Center of the Ministry of Education (estadisticas@mineduc.cl). They have a form that researchers need to fill in order to gain access to the dataset. 

- DESUC Survey use of Time: we gained access to this dataset directly from the former director of the DESUC. This institution does not exist any longer, but we made this dataset available in this repository.

- Use of Time Survey (2015): the original dataset can be download from the following link: https://www.ine.cl/estadisticas/menu-sociales/enut

- PISA datasets can be download from the following link: https://www.oecd.org/pisa/data/

## REPLICATION
In order to implement our main analysis we combine many of these files. Since some of them cannot be made public, to facilitate the replication of our results we created a set of datasets in which we use a fake identifier of schools and individuals and keep variables to a minimum. This is necessary in order to satisfy the data protection policies of the public agencies that gave us access to the data. The school and individual identifiers are unique to each dataset; therefore, they cannot be used to combine them.

- fsd_final_dataset_for_analysis_replication.dta: to replicate main effects, heterogeneous effects and robustness checks analysis.
- event_study_xxxx.dta: to replicate event studies.
- fsd_adoption.dta: to replicate figure with adoption shares.
- pisa_autonomy.dta: to replicate table describing differences in school autonomy.
- teachers_opinion.dta: to replicate table showing differences in teachers opinion about the FSD.
- homework_frequency.dta: to replicate table about homework frequency.
- school_choice.dta: to replicate ranking of main reasons to choose a school.
- school_use_of_time.dta: to replicate table with schools use of time after adopting FSD.
- BASE_USUARIO_corregida: to replicate tables about additional support at home (https://www.ine.cl/estadisticas/menu-sociales/enut)

### These datasets can be downloaded from https://andresbarriosf.github.io

(C) All right reserved to Andrés Barrios-Fernández and Giulia Bovini.
