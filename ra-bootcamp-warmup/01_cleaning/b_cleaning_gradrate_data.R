###cleaning gradrate data###
#load packages
library(tidyverse)
library(openxlsx)

#b1
#load data & unite data
years = c(1991,1992,1993,1995,1996,1997,1998,1999,
          2000,2001,2002,2003,2004,2005,2006,2007,
          2008,2009,2010)

outcomedata = data.frame()
for(y in years){
  filename = paste(y,".xlsx",sep="")
  dataname = paste("data",y,sep="")
  dataname <- read.xlsx(filename)
  
  outcomedata = outcomedata%>%
    bind_rows(dataname)
}

#b2
#multiply 0.01 to 'women_gradrate_4yr'
outcomedata = outcomedata%>%
  mutate(
    women_gradrate_4yr = 0.01*women_gradrate_4yr,
    women_gradrate_4yr = as.numeric(women_gradrate_4yr)
  )

#b3
#create 'total_gradrate_4yr' and 'men_gradrate_4yr'
outcomedata = outcomedata%>%
  mutate(
    totcohortsize = as.numeric(totcohortsize),
    m_4yrgrads = as.numeric(m_4yrgrads),
    total_gradrate_4yr = tot4yrgrads/totcohortsize,
    total_gradrate_4yr = as.numeric(total_gradrate_4yr),
    men_gradrate_4yr = m_4yrgrads/m_cohortsize,
    men_gradrate_4yr = as.numeric(men_gradrate_4yr)
  )

#b4
#set significant digits as 3
outcomedata <- outcomedata%>%
  mutate(
    total_gradrate_4yr = format(round(outcomedata$total_gradrate_4yr,3),nsmall = 3),
    women_gradrate_4yr = format(round(outcomedata$women_gradrate_4yr,3),nsmall = 3),
    men_gradrate_4yr = format(round(outcomedata$men_gradrate_4yr,3),nsmall = 3)
  )  

#b5
#limit data period(1991 - 2010)
outcomedata <- outcomedata%>%
  dplyr::filter(year >= 1991 & year <= 2010)

#export data
write.csv(outcomedata,"outcomedata.csv",fileEncoding = "CP932")