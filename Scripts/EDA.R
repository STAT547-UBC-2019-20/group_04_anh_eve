# March 2020
# Eve Wicksteed and Anh Le

# script to create and save plots
# Description of the script and the command-line arguments
"
This script conducts exploratory data analysis using the cleaned data. The plots are saved to Image folder.

Usage: EDA.R --path=<path> --datafilename=<datafilename>
" -> doc

library(here)
library(tidyverse)
library(DT)
library(knitr)
library(lubridate) 
library(tidyquant)
library(corrplot)
library(cowplot)
library(docopt)

opt <- docopt(doc)

main <- function(path, datafilename){
  
  data <- readr::read_csv(here::here(glue::glue(path, datafilename)))
  
  # correlation plot
  data %>% 
    select(c(3:12)) %>% 
    cor(use = "complete.obs") %>%
    round(2) %>%
    corrplot(type="upper", 
           method="color",
           tl.srt=45, 
           tl.col = "blue",
           diag = FALSE)
  
  ggsave(filename = "Images/corrplot.png", device = 'png')
  
  
  # daily pollutants vs. time
  aq_time_plot <- function(data){
  
  #Aggregate Daily Average
  airq_daily <- data %>%
    group_by(Date) %>%
    summarise_all(funs(mean), na.rm = TRUE)
  
  #data preparation: short to long, select pollutants to be included
  airq.lg.d <- airq_daily %>%
    select(Date, `PT08.S1(CO)`,`C6H6(GT)`, `PT08.S2(NMHC)`) %>% 
    gather(key = "Variable", value = "Value", -Date)

  plot_aq_w_time <- airq.lg.d %>% 
    drop_na(Value) %>%
    ggplot(aes(x = Date, y = Value)) + 
    geom_line(aes(color = Variable, linetype = Variable)) +
    theme_bw() +
    #coord_x_date(xlim = c("2005-01-04", "2005-04-04")) +
    xlab("Time") +
    ylab("microg/m^3")+
    ggtitle("Pollutant variation with time")
  }
  
  ggsave(filename = "Images/pollutantsvstime.png", device = 'png')
  
  
  # daily weather vs. time
  weather_time_plot <- function(data){
  
  #Aggregate Daily Average
  airq_daily <- data %>%
    group_by(Date) %>%
    summarise_all(funs(mean), na.rm = TRUE)
  
  weather.dly.long <- airq_daily %>%
    select(Date,`T`, `RH`) %>%
    gather(key = "Variable", value = "Value", -Date)
  
  plot_wx_w_time <- airq_daily %>% 
    ggplot(aes(x = Date)) + 
    geom_line(aes(y=T, colour = "Temperature")) +
    theme_bw() +
    #coord_x_datetime(xlim = c("2005-01-04", "2005-04-04")) +
    xlab("Time") +
    ylab("Temperature (Degrees C)") +
    geom_line(aes(y=RH, colour = "Humidity")) +
    scale_y_continuous(sec.axis = sec_axis(~., name = "Relative Humidity (%)")) +
    ggtitle("Weather variation with time")
  }
  
  ggsave(filename = "Images/weathervstime.png", device = 'png')
  
  
  # Plot of temp vs. benzene
  plot_temp_benzene <- function(data){
    
    #Aggregate Daily Average
    airq_daily <- data %>%
    group_by(Date) %>%
    summarise_all(funs(mean), na.rm = TRUE) %>%
    select(Date,`T`, `RH`, `C6H6(GT)`) %>%
    
    #plot
    ggplot(aes(x = Date)) + 
    geom_line(aes(y=T, colour = "Temperature")) +
    theme_bw() +
    #coord_x_datetime(xlim = c("2005-01-04", "2005-04-04")) +
    xlab("Time") +
    ylab("Temperature (Degrees C)") +
    geom_line(aes(y=RH, colour = "Humidity")) +
    scale_y_continuous(sec.axis = sec_axis(~., name = "Relative Humidity (%)"))
  }
  
  ggsave(filename = "Images/tempvsbenzene.png", device = 'png')
  
  
  print("The script completed successfully")
  
  }

main(opt$path, opt$datafilename)













  