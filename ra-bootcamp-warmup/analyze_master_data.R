###analize master data###
#load packages
library(tidyverse)
library(openxlsx)
library(VIM)
library(purrr)
library(plm)
library(modelsummary)

#load data
masterdata <- readr::read_csv("masterdata.csv")
#delete [,1]
masterdata <- masterdata[,-1]

##a.discriptive analysis##
#a1. count NA in each columns
#make vacant list and columns name list

masterdata%>% map_int(VIM::countNA)

#a2


#a3. plot the rate of 4 years graduation
#make a list of the rate of 4 years graduation
years = c(1991,1992,1993,1995,1996,1997,1998,1999,
          2000,2001,2002,2003,2004,2005,2006,2007,
          2008,2009,2010)
ave4grads = c()

for(y in years){
  eachyeardata = masterdata%>%
    dplyr::filter(year == y)
  rate = mean(eachyeardata$total_gradrate_4yr)
  
  ave4grads = c(ave4grads,c(rate))
}
a3data <- data.frame(years,ave4grads)

#plot
ggplot(data = a3data,
       mapping = aes(x = years,
                     y = ave4grads),
       ylim = c(0.25,0.75))+
  geom_line()+
  coord_cartesian(ylim = c(0.30, 0.45))

#a4. plot the rate of semester
#make a list of the rate of semester
years = c(1991,1992,1993,1995,1996,1997,1998,1999,
          2000,2001,2002,2003,2004,2005,2006,2007,
          2008,2009,2010)
r_sem <- c()

for(y in years){
  r_eachyeardata <- masterdata%>%
    dplyr::filter(year == y)
  semrate = mean(r_eachyeardata$semester)
  
  r_sem <- c(r_sem,c(semrate))
}
a4data <- data.frame(years,r_sem)

#plot
ggplot(data = a4data,
       mapping = aes(x = years,y = r_sem)) + 
  geom_line()+
  coord_cartesian(ylim = c(0.85, 0.96))

#a5. scatter plot
#create column
masterdata <- masterdata%>%
  mutate(
    women_rate = w_cohortsize/totcohortsize,
    white_rate = white_cohortsize/totcohortsize
  )

#plot
xlab_list <- c("women_rate","white_rate","instatetuition")
for(x in xlab_list){
  xs <- rlang::sym(x)
  
  g <- ggplot(data = masterdata)+
              geom_point(aes(x = !!xs,y = total_gradrate_4yr))
  x11(); plot(g)
}

#a6. regression
#reroad data as panel data
p_masterdata <- pdata.frame(masterdata,
                            index = c("unitid","year"))
pooled_plm <- plm(total_gradrate_4yr ~ after,
                  data = p_masterdata,
                  model = "pooling")
msummary(pooled_plm,star = TRUE)
