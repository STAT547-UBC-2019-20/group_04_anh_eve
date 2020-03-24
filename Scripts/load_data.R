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
  
  #loading data
  data_url <- url
  path <- here("data", outfilename)
  
  write_csv(read_csv(data_url), path) #read data from url, then write it to local directory called "path"
  
  print(glue::glue("Reading data from ", url, " and saving to ", outfilename))
  
}

main(opt$url, opt$outfilename)

