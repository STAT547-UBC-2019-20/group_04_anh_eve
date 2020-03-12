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
  airq_daily = airq %>%
    group_by(Date) %>%
    summarise_all(funs(mean), na.rm = TRUE)
  
  
  ##### REGRESSIONs
  
  #Fit benzene against temperature & humidity (relative humidity is correlated to temperature) 
  Benzene = lm(`C6H6(GT)` ~ T + AH, data = airq_daily)
  #save RDS file
  saveRDS(Benzene, file = "Benzene.rds")
  tidy(Benzene)
  
  #Fit titania against temperature & humidity 
  Titania = lm(`PT08.S2(NMHC)` ~ T + AH, data = airq_daily)
  #save RDS file
  saveRDS(Titania, file = "Titania.rds")
  tidy(Titania)
  
  #Fit tin oxide against temperature & humidity 
  Tinoxide= lm(`PT08.S1(CO)` ~ T + AH, data = airq_daily)
  #save RDS file
  saveRDS(Tinoxide, file = "Tinoxide.rds")
  tidy(Tinoxide)
  
  
  ##### COEFFICIENTS PLOTS
  
  threeM <- rbind(tidy(Benzene) %>% mutate(model = "Benzene"), 
                  tidy(Titania) %>% mutate(model = "Titania"), 
                  tidy(Tinoxide) %>% mutate(model = "Tin oxide")) %>% 
    relabel_predictors(c("(Intercept)" = "Intercept",
                         T = "Temperature",
                         AH = "Absolute Humidity"))
  
  small_multiple(threeM) +
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












