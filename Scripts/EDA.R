# March 2020
# Eve Wicksteed and Anh Le

# script to create and save plots
# Description of the script and the command-line arguments
"
This script conducts exploratory data analysis using the cleaned data. The plots are saved to Image folder.

Usage: Scripts/EDA.R --data_dir=<data_dir> --datafilename=<datafilename>
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

main <- function(data_dir, datafilename){
  
  data <- readr::read_csv(here::here(data_dir,datafilename))
  
  #### CORRELATION PLOT
  
  # set up graphics device
  png(filename="Images/correlation.png")
  data %>% 
    select(c(3:15)) %>% 
    cor(use = "complete.obs") %>%
    round(2) %>%
    corrplot(type="upper", 
           method="color",
           tl.srt=45, 
           tl.col = "blue",
           diag = FALSE)
  # turn off graphics device
  dev.off()
  
  ### DATA PREP
  
  #Aggregate Daily Average
  airq_daily <- data %>%
    group_by(Date) %>%
    summarise_all(funs(mean), na.rm = TRUE)
  
  #data preparation: short to long, select pollutants to be included
  airq.lg.d <- airq_daily %>%
    select(Date, Tin_oxide,Benzene, Titania) %>% 
    gather(key = "Variable", value = "Value", -Date)
  
  weather.dly.long <- airq_daily %>%
    select(Date,Temp, RH) %>%
    gather(key = "Variable", value = "Value", -Date)
  
  

  #### POLLUTANTS WITH TIME
  # daily pollutants vs. time
  
  plot_aq_w_time <- airq.lg.d %>% 
    drop_na(Value) %>%
    ggplot(aes(x = Date, y = Value)) + 
    geom_line(aes(color = Variable, linetype = Variable)) +
    theme_bw() +
    #coord_x_date(xlim = c("2005-01-04", "2005-04-04")) +
    xlab("Time") +
    ylab("microg/m^3")+
    ggtitle("Pollutant variation with time")

  ggsave(filename = "Images/pollutantsvstime.png", device = 'png', width=9, height=5)
  
  
  #### WEATHER WITH TIME
  
  plot_wx_w_time <- airq_daily %>% 
    ggplot(aes(x = Date)) + 
    geom_line(aes(y=Temp, colour = "Temperature")) +
    theme_bw() +
    #coord_x_datetime(xlim = c("2005-01-04", "2005-04-04")) +
    xlab("Time") +
    ylab("Temperature (Degrees C)") +
    geom_line(aes(y=RH, colour = "Humidity")) +
    scale_y_continuous(sec.axis = sec_axis(~., name = "Relative Humidity (%)")) +
    ggtitle("Weather variation with time")
  
  ggsave(filename = "Images/weathervstime.png", device = 'png', width=9, height=5)
  
  
  #### TEMP VS BENZENE
    
    #Aggregate Daily Average
    # airq_daily <- data %>%
    # group_by(Date) %>%
    # summarise_all(funs(mean), na.rm = TRUE) %>%
    # select(Date,`T`, `RH`, Benzene) %>%
    
    #plot
  plot_bz_w_time <- data %>% 
    ggplot() + 
    geom_point(aes(y=Benzene, x=Temp)) +
    theme_bw() +
    xlab("Temperature (Degrees C)") +
    ylab("Benzene concentration (microg/m^3")+
    ggtitle("Benzene variation with temperature")

  ggsave(filename = "Images/tempvsbenzene.png", device = 'png', width=9, height=5)
  
  
  print("The script completed successfully and images have been saved to Images/")
  
  }

main(opt$data_dir, opt$datafilename)

# example of how to run:
# Rscript Scripts/EDA.R --data_dir="Data" --datafilename="clean_aq.csv"













  