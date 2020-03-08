# March 2020
# Eve Wicksteed and Anh Le

# script to clean data

"


Usage: clean_data.R --data=<data> --outfilename=<outfilename>
" -> doc

# load libraries
library(here)
library(tidyverse)
library(glue)
library(tidyr)
library(docopt)



opt <- docopt(doc)



main <- function(data, outfilenames){
  #convert Missing Values (tagged with -200 value) to NA
  data[data == -200] = NA 
  # Convert numeric columns to 'double' type
  data[3:15] <- sapply(data[3:15], as.double)
  data = data %>% 
    mutate(Date_Time = ymd_hms(paste(data$Date, data$Time)))
  
  #save as csv
  
}





main(opt$data, opt$outfilename)

# Round the values to 2 decimal places
#for correlation plot
#airq_corr <- cor(airq[3:15], use = "complete.obs")
#airq_corr <- round(airq_corr,2)



