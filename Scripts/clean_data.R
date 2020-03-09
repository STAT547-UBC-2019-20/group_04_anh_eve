# March 2020
# Eve Wicksteed and Anh Le

# script to clean data

"


Usage: clean_data.R --path=<path> --datafilename=<datafilename> --outfilename=<outfilename>
" -> doc

# load libraries
library(here)
library(tidyverse)
library(glue)
library(tidyr)
library(docopt)
library(lubridate) 



opt <- docopt(doc)



main <- function(path , datafilename, outfilename){
  data <- readr::read_csv(here::here(glue::glue(path, datafilename)))
  #convert Missing Values (tagged with -200 value) to NA
  data[data == -200] = NA 
  # Convert numeric columns to 'double' type
  data[3:15] <- sapply(data[3:15], as.double)
  data = data %>% 
    mutate(Date_Time = ymd_hms(paste(data$Date, data$Time)))
  
  #save as csv
  readr::write_csv(data, here::here(glue::glue(path, outfilename,".csv")))
  
  print(glue::glue("Reading data from ", path, datafilename, 
                   " cleaning, and saving to ", outfilename, ".csv"))
  
}





main(opt$path, opt$datafilename, opt$outfilename)

# Round the values to 2 decimal places
#for correlation plot
#airq_corr <- cor(airq[3:15], use = "complete.obs")
#airq_corr <- round(airq_corr,2)



