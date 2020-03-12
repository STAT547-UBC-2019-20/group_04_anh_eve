# March 2020
# Anh Le

# script to run linear regression, plotting coefficients and other analysis
# Export any plots you want to include in your final report as an image (to the images directory)
# Export your model object to an RDS file so you can load this file in your final report 
# Use the tidy, augment, or glance functions from the broom package to reference the model’s statistical findings
# Add a line in the Usage section on how to use this script
"
This script run linear regression, and any subsequent explorations and analyses using the cleaned data. 

Usage: LinearRegression.R --path=<path> --datafilename=<datafilename>
" -> doc

library(broom)
library(here)
library(tidyverse)
library(DT)
library(knitr)
library(lubridate) 
library(tidyquant)
library(corrplot)
library(ggplot2)
library(cowplot)
library(docopt)


opt <- docopt(doc)

main <- function(path, datafilename){
  
  #read data
  data <- readr::read_csv(here::here(glue::glue(path, datafilename)))
  
  #Aggregate Daily Average
  airq_daily = airq %>%
    group_by(Date) %>%
    summarise_all(funs(mean), na.rm = TRUE)
  
  ##### REGRESSION
  #Fit benzene against temperature & humidity (relative humidity is correlated to temperature) 
  tempbenzene = lm(`C6H6(GT)` ~ T + AH, data = airq_daily)
  #save RDS file
  saveRDS(tempbenzene, file = "tempbenzene.rds")
  tidy(tempbenzene)
  
  #Fit titania against temperature & humidity 
  temptitania = lm(`PT08.S2(NMHC)` ~ T + AH, data = airq_daily)
  #save RDS file
  saveRDS(temptitania, file = "temptitania.rds")
  tidy(temptitania)
  
  #Fit tin oxide against temperature & humidity 
  temptinoxide = lm(`PT08.S1(CO)` ~ T + AH, data = airq_daily)
  #save RDS file
  saveRDS(temptinoxide, file = "temptinoxide.rds")
  tidy(temptinoxide)
  
  
  ##### COEFFICIENTS PLOTS
  
  
}

main(opt$path, opt$datafilename)












