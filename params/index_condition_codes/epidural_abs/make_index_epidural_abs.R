
rm(list=ls())
library(tidyverse)
library(icd)

# load functions and define path
source("/Volumes/Statepi_Diagnosis/params/index_condition_codes/make_codes/export_index_codes_function.R")

out_path <- "/Volumes/Statepi_Diagnosis/params/index_condition_codes/"

# define codes
codes <- list(dx_name="epidural_abs",
                     dx_name_long="Epidural Abscess",
                     icd9_codes=c("3240","3241","3249"),
                     icd10_codes=c("G060","G061","G062"))

tmp <- rbind(tibble(dx_name_long = codes$dx_name_long,
                    icd_group=codes$dx_name,
                    code=codes$icd9_codes,
                    icd_version=9L),
             tibble(dx_name_long = codes$dx_name_long,
                    icd_group=codes$dx_name,
                    code=codes$icd10_codes,
                    icd_version=10L))

write_csv(tmp,path = "/Volumes/atlan/dissertation_projects/params/index_condition_codes/epidural_abs/index_dx_codes.csv")


