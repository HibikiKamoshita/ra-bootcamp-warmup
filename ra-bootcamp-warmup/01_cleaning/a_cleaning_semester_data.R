###cleaning semester data###
#load packages
library(tidyverse)

#a1
#load data
semdata1 <- readr::read_csv("semester_data_1.csv")
semdata2 <- readr::read_csv("semester_data_2.csv")

#a2
#change colnames of semdata1
colnames(semdata1) <- semdata1[1,]
semdata1 <- semdata1[-1,]

#change colnames of semdata2
colnames(semdata2) <- c("unitid","instnm","semester",
                        "quarter","year","Y")
#a3
#prepare for uniting data(change class)
semdata1$unitid <- as.numeric(semdata1$unitid)
semdata1$year <- as.numeric(semdata1$year)
semdata1$Y <- as.numeric(semdata1$Y)
semdata2$semester <- as.factor(semdata2$semester)
semdata2$quarter <- as.factor(semdata2$quarter)

#unite data
semdata <- dplyr::bind_rows(semdata1,semdata2)
class(quarter)

#a4
#delete "Y"
semdata <- semdata[,-6]

#a5,a6
#create column of the year introduced semester system
semdata <- semdata%>%
  mutate(
    sem_year = if_else(semester == 1,year,9999)
  )
semdata <- semdata%>%
  group_by(unitid)%>%
  mutate(
    int_year = rep(min(sem_year),19),
    int_year = car::recode(int_year,"1991 = NA"),
    after = if_else(year >= int_year,1,0)
  )

#export data
write.csv(semdata,"semdata.csv",fileEncoding = "CP932")