###cleaning master data###
#load packages
library(tidyverse)
library(openxlsx)

#load data
semdata <- readr::read_csv("semdata.csv")
outcomedata <- readr::read_csv("outcomedata.csv")
covdata_wide <- readr::read_csv("covdata_wide.csv")

##make master data##
#choice variables
semdata <- semdata%>%
  dplyr::select(unitid,year,semester,quarter,instnm,int_year,after)#add dummy variable and year valuable

outcomedata <- outcomedata[,-1]

covdata_wide <- covdata_wide%>%
  dplyr::select(unitid,year,instatetuition,white_cohortsize)

#unite each data
s_o_data <- dplyr::left_join(semdata,outcomedata,by = c("unitid","year"))

masterdata <- dplyr::left_join(s_o_data,covdata_wide,by = c("unitid","year"))

#export data
write.csv(masterdata,"masterdata.csv",fileEncoding = "CP932")
