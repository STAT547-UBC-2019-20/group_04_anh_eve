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
  
  ##### Export your model object to an RDS file
  
  chemnames <- c("CO", "Tin_oxide", "Hydro_carbons", "Benzene", 
                "Titania", "NOx", "Tungsten_oxide_NOx", "NO2", "Tungsten_oxide_NO2", 
                "Indium_oxide")
  
  for (i in 1:length(regressions)) {
    assign(chemnames[[i]], regressions[[i]])
    saveRDS(regressions[[i]], file = paste("Data/",chemnames[[i]], ".rds", sep = ""))
  }
  
  
  ##### COEFFICIENTS PLOTS
  
  #NOx %>% mutate(model = "NOx"), 
  #Tungsten_oxide_NOx %>% mutate(model = "Tungsten Oxide NOx"), 
  #NO2 %>% mutate(model = "NO2"),
  #Tungsten_oxide_NO2 %>% mutate(model = "Tungsten Oxide NO2"), 
  #Indium_oxide %>% mutate(model = "Indium Oxide")) 
  #CO %>% mutate(model = "CO"), 
  #Hydro_carbons %>% mutate(model = "Hydro Carbons"),
  
  chemModels <- rbind(Tin_oxide %>% mutate(model = "Tin Oxide"),
                      Benzene %>% mutate(model = "Benzene"), 
                      Titania %>% mutate(model = "Titania")) %>% 
    relabel_predictors(c("(Intercept)" = "Intercept",
                         Temp = "Temperature",
                         AH = "Absolute Humidity"))
  
  small_multiple(chemModels, show_intercept = FALSE) +
    geom_hline(yintercept = 0, colour = "grey60", linetype = 2) +
    theme_bw() + 
    xlab("Pollutants/ Dependant Variables") +
    ylab("Coefficient Estimates") +
    ggtitle("Coefficient Estimates for Predicting Air Pollutants' Concentrate") +
    theme(plot.title = element_text(size = 25, hjust = 0.5, family="serif", margin=margin(0,0,30,0)),
          legend.position = "none",
          legend.background = element_rect(colour="grey00"),
          axis.text = element_text(size = 15, family="serif"),
          axis.title.x = element_text(size = 25, family="serif", vjust = 1),
          axis.title.y = element_text(size = 25, family="serif", vjust = 1))
      
  
  ggsave("Images/CoefPlot_Group4.png", device = 'png', width = 15, height = 10, units = "in")
  
}

main(opt$path, opt$datafilename)












