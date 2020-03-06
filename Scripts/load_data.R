# March 2020
# Eve Wicksteed 

# script to load in data

"
This script will read in our dataset from a URL argument and save it to a csv file with a given output file name.

Usage: load_data.R --url=<url> --outfilename=<outfilename>
"

library(here)
library(tidyverse)
library(glue)

main <- function(url){
  
  data_url <- url
  
  readr::write_csv(readr::read_csv(url),here::here("data", glue::glue(outfilename, ".csv")))
  
  print("Reading data from ", url, " and saving to ", glue::glue(outfilename, ".csv"))
  
}

### tests?
# could test that inputs are strings

main(opt$url, opt$outfilename)