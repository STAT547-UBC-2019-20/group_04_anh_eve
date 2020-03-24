# March 2020
# Anh Le


#Knit the final report Rmd file so that it exports an HTML and PDF file.
#Run without any intervention from the user after running the script from a terminal/command prompt
#Print a helpful message to the terminal informing the user that the script has completed successfully
"
This script knits the final report Rmd file so that it exports an HTML and PDF file.

Usage: Knit.R --docdir=<docdir> --finalreport=<finalreport>
" -> doc

library(here)
library(docopt)
library(testthat)


opt <- docopt(doc)

main <- function(docdir="Docs", finalreport) {
  rmarkdown::render(here(docdir, finalreport), 
                    c("html_document", "pdf_document"))
  
  print("HTML & PDF files successfully knitted")
}


main(opt$docdir, opt$finalreport)

#usage: Rscript Scripts/Knit.R --docdir="Docs" --finalreport="milestone3.rmd"
