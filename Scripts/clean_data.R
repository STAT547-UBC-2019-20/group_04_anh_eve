# March 2020
# Eve Wicksteed and Anh Le

# script to clean data

"


Usage: clean_data.R --data_dir=<data_dir> --infilename=<infilename> --outfilename=<outfilename>
" -> doc

# load libraries
library(here)
library(tidyverse)
library(glue)
library(tidyr)
library(docopt)
library(lubridate) 



opt <- docopt(doc)



main <- function(data_dir, infilename, outfilename){
  data <- readr::read_csv(here::here(data_dir, infilename))
  #convert Missing Values (tagged with -200 value) to NA
  data[data == -200] = NA 
  # Convert numeric columns to 'double' type
  data[3:15] <- sapply(data[3:15], as.double)
  data = data %>% 
    mutate(Date_Time = ymd_hms(paste(data$Date, data$Time)))
  
  #save as csv
  readr::write_csv(data, here::here(data_dir, outfilename))
  
  print(glue::glue("Reading data from ", data_dir, "/", infilename, 
                   " cleaning, and saving to ", outfilename))
  
}


main(opt$data_dir, opt$infilename, opt$outfilename)

#example of how to run:
# Rscript Scripts/clean_data.R --data_dir="Data" --infilename="aq.csv" --outfilename="clean_aq.csv"

# Round the values to 2 decimal places
#for correlation plot
#airq_corr <- cor(airq[3:15], use = "complete.obs")
#airq_corr <- round(airq_corr,2)



