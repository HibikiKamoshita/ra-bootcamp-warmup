###cleaning covariates data###
#load packages
library(tidyverse)
library(openxlsx)

#c1
#road data
covdata <- read.xlsx("covariates.xlsx")

#c2
#rename 'university_id' as 'unitid'
covdata <- covdata%>%
  rename("unitid" = university_id)

#c3
#separate 'aaaa'
covdata <- covdata%>%
  separate(unitid,"unitid",sep = "[abc]")
#c4
#pivot data from long to wide 
covdata_wide <- covdata%>%
  pivot_wider(names_from = "category",
              values_from = "value")

#c5
#limit data period(1991 - 2010)
covdata_wide <- covdata_wide%>%
  dplyr::filter(year >= 1991 & year <= 2010)

#export data
write.csv(covdata_wide,"covdata_wide.csv",fileEncoding = "CP932")