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
library(dotwhisker)
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
  
  ##### READ DATA
  data <- readr::read_csv(here::here(glue::glue(path, datafilename)))
  
  
  ##### Aggregate Daily Average
  airq_daily = data %>%
    group_by(Date) %>%
    summarise_all(funs(mean), na.rm = TRUE)
  
  ##### Regressions for ALL chemicals
  regressions = airq_daily %>% 
    select(-c(Date, Time, Date_time, Temp, RH, AH )) %>%  # leave only dependent variables
    map(~lm(.x ~  Temp + AH, data = airq_daily)) %>% 
    map(tidy) 
  

  
  ##### COEFFICIENTS PLOTS
  
  chemModels <- rbind(regressions$CO %>% mutate(model = "CO"), 
                      regressions$Tin_oxide %>% mutate(model = "Tin Oxide"),
                      regressions$Hydro_carbons %>% mutate(model = "Hydro Carbons"),
                      regressions$Benzene %>% mutate(model = "Benzene"), 
                      regressions$Titania %>% mutate(model = "Titania"), 
                      regressions$NOx %>% mutate(model = "NOx"), 
                      regressions$Tungsten_oxide_NOx %>% mutate(model = "Tungsten Oxide NOx"), 
                      regressions$NO2 %>% mutate(model = "NO2"),
                      regressions$Tungsten_oxide_NO2 %>% mutate(model = "Tungsten Oxide NO2"), 
                      regressions$Indium_oxide %>% mutate(model = "Indium Oxide")) %>% 
    relabel_predictors(c("(Intercept)" = "Intercept",
                         Temp = "Temperature",
                         AH = "Absolute Humidity"))
  
  small_multiple(chemModels) +
    theme_bw() + 
    xlab("") +
    ylab("") +
    ggtitle("Coefficient Estimates for Predicting Air Pollutants' Concentrate") +
    theme(plot.title = element_text(size = 15, hjust = 0.5, family="serif"),
          legend.position = "none",
          legend.background = element_rect(colour="grey80"),
          legend.title = element_blank(),
          legend.key.size = unit(15, "pt"))
  
  ggsave("Images/CoefPlot_Group4.png", device = 'png', width = 7, height = 7, units = "in")
  
}

main(opt$path, opt$datafilename)












