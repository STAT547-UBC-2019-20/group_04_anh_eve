# Milestone 1 - Air quality data exploration
By Anh Le and Eve Wicksteed

You can find the link to our report for milestone 1 [here](https://stat547-ubc-2019-20.github.io/group_04_anh_eve/Docs/milestone1.html)

In our project we use air quality data from [the UPI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Air+Quality).


## Usage:

1. Clone this repo

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
Rscript load_data.R --url="https://raw.githubusercontent.com/STAT547-UBC-2019-20/data_sets/master/airquality.csv" --outfilename="aq"

- clean_data.R
Rscript clean_data.R --data_dir="data" --datafilename="orig_aq.csv" --outfilename="aq.csv"

- EDA.R







