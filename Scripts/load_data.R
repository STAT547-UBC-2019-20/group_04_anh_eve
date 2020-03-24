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
library(testthat)

opt <- docopt(doc)

main <- function(url, outfilename){
  
  #loading data
  data_url <- url
  path <- here("data", outfilename)
  
  write_csv(read_csv(data_url), path) #read data from url, then write it to local directory called "path"
  
  #testing the saved cvs is the same as the data from the url
  data <- read_csv(path) #load the saved data
  test_that("first value of the third column is equal to 2.6", {
    expect_equal(data[[3]][1], 2.6, tolerance=1e-5)
  })
  
  data
  
  print(glue::glue("Reading data from ", url, " and saving to ", outfilename))
  print("pass test")
  
}

main(opt$url, opt$outfilename)

