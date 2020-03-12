# March 2020
# Anh Le


#Knit the final report Rmd file so that it exports an HTML and PDF file.
#Run without any intervention from the user after running the script from a terminal/command prompt
#Print a helpful message to the terminal informing the user that the script has completed successfully
"
This script knits the final report Rmd file so that it exports an HTML and PDF file.

Usage: LinearRegression.R --path=<path> --datafilename=<datafilename>
" -> doc

library(tidyverse)
library(here)
library(docopt)

opt <- docopt(doc)

