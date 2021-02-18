
rm(list=ls())
library(tidyverse)
library(icd)

# load functions and define path
source("/Volumes/Statepi_Diagnosis/params/index_condition_codes/make_codes/export_index_codes_function.R")

# define codes
codes <- list(dx_name="overdose",
              dx_name_long="Overdose",
              icd9_codes=as.character(children("")),
              icd10_codes=as.character(children("")))

tmp <- rbind(tibble(dx_name_long = codes$dx_name_long,
                    icd_group=codes$dx_name,
                    code=codes$icd9_codes,
                    icd_version=9L),
             tibble(dx_name_long = codes$dx_name_long,
                    icd_group=codes$dx_name,
                    code=codes$icd10_codes,
                    icd_version=10L))

write_csv(tmp,path = "/Volumes/atlan/dissertation_projects/params/index_condition_codes/overdose/index_dx_codes.csv")
