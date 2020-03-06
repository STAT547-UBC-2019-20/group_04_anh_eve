# March 2020
# Eve Wicksteed 

# script to load in data

"
This script will read in our dataset from a URL argument and save it to a csv file with a given output file name.
Returns loaded data as a tibble. 

Usage: load_data.R --url=<url> --outfilename=<outfilename>
"

library(here)
library(tidyverse)
library(glue)
library(tidyr)

main <- function(url){
  
  data_url <- url
  path <- here::here("data", glue::glue(outfilename, ".csv"))
  
  readr::write_csv(readr::read_csv(data_url), path)
  
  data <- readr::read_csv(path)
  
  print("Reading data from ", url, " and saving to ", glue::glue(outfilename, ".csv"))
  
  return(data)
  
}

#
# data_url <- "https://raw.githubusercontent.com/STAT547-UBC-2019-20/data_sets/master/airquality.csv"


### tests?
# could test that inputs are strings

main(opt$url, opt$outfilename)