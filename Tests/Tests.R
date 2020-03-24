# March 2020
# Eve Wicksteed and Anh Le

# script to create tests

"
This script produce tests to make sure all codes run. 

Usage: Scripts/EDA.R --data_dir=<data_dir> --loaddata=<loaddata> --cleaneddata=<cleaneddata>
" -> doc

library(docopt)
library(testthat)
library(tidyverse)

opt <- docopt(doc)

main <- function(data_dir, loaddata, cleaneddata){
  
  #reading saved loaded data
  loaddata <- readr::read_csv(here::here(data_dir,loaddata))
  
  #reading cleaned data
  cleaneddata <- readr::read_csv(here::here(data_dir,cleaneddata))
  
  #Test for load_data.R ----
  ##testing the saved cvs is the same as the data from the url
  test_that("first value of the third column is equal to 2.6", {
    expect_equal(loaddata[[3]][1], 2.6, tolerance=1e-5)
  })
  
  #Tests for clean_data.R ----
  test_that("all -200 values are now converted to NA", {
    expect_true(!(-200 %in% cleaneddata))
  })
  
  #Tests for EDA.R ----
  images = c("Images/pollutantsvstime", "Images/weathervstime", "Images/tempvsbenzene")
  test_that("all the EDA plots were successfully created", {
    map(images,
        ~ expect_true(file.exists(here::here(glue::glue(.x, ".png")))))
  })
  
  #Tests for Knit.R ----
  fileformat = c(".pdf", ".html")
  test_that("all the files were successfully created", {
    map(fileformat,
        ~ expect_true(file.exists(here::here(glue::glue("Docs/","milestone4", .x)))))
  })

  print("Pass all tests")
  
}


main(opt$data_dir, opt$loaddata, opt$cleaneddata)

