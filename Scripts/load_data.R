# March 2020
# Eve Wicksteed 

# script to load in data

"
This script will read in our dataset from a URL argument and save it to a csv file with a given output file name.
Returns loaded data as a tibble. 

Usage: load_data.R --url=<url> --outfilename=<outfilename.csv>
" -> doc

library(here)
library(tidyverse)
library(glue)
library(tidyr)
library(docopt)

opt <- docopt(doc)

main <- function(url, outfilename){
  
  data_url <- url
  path <- here::here("data", outfilename)
  
  readr::write_csv(readr::read_csv(data_url), path)
  
  data <- readr::read_csv(path)
  
  print(glue::glue("Reading data from ", url, " and saving to ", outfilename))
  
  #return(data)
  
}

#
# example: run like this:
# Rscript load_data.R --url="https://raw.githubusercontent.com/STAT547-UBC-2019-20/data_sets/master/airquality.csv" --outfilename="aq.csv"

### tests?
# could test that inputs are strings

main(opt$url, opt$outfilename)

