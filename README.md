# Milestone 1 - Air quality data exploration
By Anh Le and Eve Wicksteed

You can find the link to our report for milestone 1 [here](https://stat547-ubc-2019-20.github.io/group_04_anh_eve/Docs/milestone1.html)

In our project we use air quality data from [the UPI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Air+Quality).



# Milestone 2 - Air quality data exploration

You can find the link to our project for milestone 2 [here](https://stat547-ubc-2019-20.github.io/group_04_anh_eve/Docs/milestone2.html)

## Usage:

1. Clone this repo:
  `git clone https://github.com/STAT547-UBC-2019-20/group_04_anh_eve.git`

2. Ensure the following packages are installed:
- here
- tidyverse
- DT
- knitr
- lubridate
- tidyquant
- corrplot
- cowplot

3. Run the following scripts (in order)

- load_data.R

  `Rscript Scripts/load_data.R --url="https://raw.githubusercontent.com/STAT547-UBC-2019-20/data_sets/master/airquality.csv" -- outfilename="aq.csv"`

- clean_data.R

  `Rscript Scripts/clean_data.R --data_dir="Data" --infilename="aq.csv" --outfilename="clean_aq.csv"`

- EDA.R

  `Rscript Scripts/EDA.R --data_dir="Data" --datafilename="clean_aq.csv"`

# Milestone 3 - Air quality data regressions

- LinearRegression.R

  `Rscript Scripts/EDA.R --data_dir="Data" --datafilename="clean_aq.csv"`
  
- Knit.R
  `Rscript Scripts/Knit.R --docdir="Docs" --finalreport="milestone2.rmd"`




