# Air quality data exploration
By Anh Le and Eve Wicksteed

In our project we use air quality data from [the UPI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Air+Quality).

# Milestone 1

You can find the link to our report for milestone 1 [here](https://stat547-ubc-2019-20.github.io/group_04_anh_eve/Docs/milestone1.html)


# Milestone 2

You can find the link to our project for milestone 2 [here](https://stat547-ubc-2019-20.github.io/group_04_anh_eve/Docs/milestone2.html)

# Milestone 3

You can find the link to our project for milestone 3 [here](https://stat547-ubc-2019-20.github.io/group_04_anh_eve/Docs/milestone3.html)


# Milestone 4

You can find the link to our project for milestone 4 [here](https://stat547-ubc-2019-20.github.io/group_04_anh_eve/Docs/milestone4.html)


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
- broom
- dotwhisker
- ggplot2
- docopt


3. Run the following scripts (in order)

### To run scripts one by one:

- load_data.R

  `Rscript Scripts/load_data.R --url="https://raw.githubusercontent.com/STAT547-UBC-2019-20/data_sets/master/airquality.csv" --outfilename="aq.csv"`

- clean_data.R

  `Rscript Scripts/clean_data.R --data_dir="Data" --infilename="aq.csv" --outfilename="clean_aq.csv"`

- EDA.R

  `Rscript Scripts/EDA.R --data_dir="Data" --datafilename="clean_aq.csv"`

- LinearRegression.R

  `Rscript Scripts/LinearRegression.R --path="Data/" --datafilename="clean_aq.csv"`
  
- Knit.R

  `Rscript Scripts/Knit.R --docdir="Docs" --finalreport="milestone4.rmd"`
  
- Test.R

  `Rscript Tests/Tests.R --data_dir="Data" --loaddata="aq.csv" --cleaneddata="clean_aq.csv"`


### Or use GNU MAKE:

To run all scripts first run: `make clean` in the terminal. And then run `make all` to generate everything. 

