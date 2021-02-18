rm(list=ls())
library(icdplus)
library(tidyverse)


# epi_abs_miss_cond <- list(back_pain=list(label="Back Pain",
#                                          icd9_codes=children(c("7201","721","722","723","724","737","739","7561","846","847")),
#                                          icd9_codes=children(c("7201","721","722","723","724","737","739","7561","846","847")) %>% 
#                                            icd9_to_icd10()),
#                           
#                           fever=list(label="Fever",
#                                      icd9_codes=c(get_icd_from_ccs(246)),
#                                      icd10_codes=c("R50",get_icd_from_ccs(246,10))),
#                           
#                           muscle_weakness = list(label="Muscle Weakness",
#                                                  icd9_codes = children("72887"),
#                                                  icd10_codes = children("72887") %>% 
#                                                    icd9_to_icd10() %>% children()),
#                           
#                           urinary_retention = list(label="Urinary Retention",
#                                                    icd9_codes = children("7882"),
#                                                    icd10_codes = children("7882") %>% 
#                                                      icd9_to_icd10() %>% children()),
#                           
#                           paralysis = list(label="Paralysis",
#                                            icd9_codes = children("3449"),
#                                            icd10_codes = children("G83")),
#                           
#                           disturbance_of_skin = list(label="Disturbance of Skin",
#                                                      icd9_codes = children("7820"),
#                                                      icd10_codes = children("R20")))
# 
# 
# write_rds(epi_abs_miss_cond,"/Volumes/Statepi_Diagnosis/params/ssd_codes/ssd_epidural_abs.RDS")

#read in Phil's SSD codes 
data <- read_csv("/Volumes/atlan/dissertation_projects/params/ssd_codes/epidural_abs/epidural_abs_phil_codes.csv")

ssds_codes <- data %>% mutate(z = map(x, ~stringr::str_split(., pattern = "[(]"))) %>%
  unnest(z) %>% 
  mutate(y = map(z, ~.[[1]])) %>% unnest(y) %>% mutate(y = str_squish(y)) %>% 
  select(dx = y, version, cat) %>% 
  distinct()

cats <- ssds_codes %>% distinct(cat) %>% mutate(name = map(cat, ~str_replace_all(., "-", "_") %>%
                                                             str_replace_all(., " ", "_") %>% 
                                                             str_replace_all(., "/", "_") )) %>% unnest(name) 

# coverts tibble of ssds to list
cond_list <- NULL
for (i in 1:nrow(cats)){
  cond_list$new <-  list(label = cats$cat[i],
                         icd9_codes = ssds_codes %>% filter(version == 9 & cat == cats$cat[i]) 
                         %>% .$dx %>% unique(),
                         icd10_codes = ssds_codes %>% filter(version == 10 & cat == cats$cat[i]) 
                         %>% .$dx %>% unique())
  names(cond_list)[i] <- cats$name[i]
}

# table of icd9 codes
icd9_table <- tibble(ssd_name=names(cond_list)) %>% 
  mutate(icd_codes=map(ssd_name,~cond_list[[.]]$icd9_codes %>% as.character)) %>%
  unnest(cols = icd_codes) %>%
  mutate(icd_version=9L)

# table of icd10 codes
icd10_table <- tibble(ssd_name=names(cond_list)) %>% 
  mutate(icd_codes=map(ssd_name,~cond_list[[.]]$icd10_codes %>% as.character)) %>%
  unnest(cols = icd_codes) %>%
  mutate(icd_version=10L)


# table of all codes
ssd_table <- rbind(icd9_table,icd10_table)

# add label
ssd_table <- ssd_table %>% 
  mutate(label=map(ssd_name,~cond_list[[.]]$label %>% as.character)) %>%
  unnest(cols = label) %>% 
  select(ssd_name, label, icd_codes, icd_version)

write_csv(ssd_table, "/Volumes/atlan/dissertation_projects/params/ssd_codes/epidural_abs/ssd_codes.csv")
