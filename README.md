# Air quality data exploration
By Anh Le and Eve Wicksteed

In our project we use air quality data from [the UPI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/Air+Quality).


# Milestones

## [Milestone 1](https://stat547-ubc-2019-20.github.io/group_04_anh_eve/Docs/milestone1.html)

## [Milestone 2](https://stat547-ubc-2019-20.github.io/group_04_anh_eve/Docs/milestone2.html)

## [Milestone 3](https://stat547-ubc-2019-20.github.io/group_04_anh_eve/Docs/milestone3.html)

## [Milestone 4](https://stat547-ubc-2019-20.github.io/group_04_anh_eve/Docs/milestone4.html)


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


# Dashboard information

## Sketch

![](/Images/dashboard_sketch_m4.png)

## Description

This app will be used to examine the effect of temperature and humidity on pollutants. Users will be able to select different variables to look at and compare. They will be able to choose between temperature and humidity to display on the x-axis and between any of the recorded pollutants to display on the y axis. 

They will also be able to choose an averaging period over which to look at the data as a time series (monthly, weekly or daily). There will also be a plot showing the daily distribution of pollutants with a dropdown to select the pollutant. 


## Usage scenario

Sam works for the department of environmental affairs. He wants to know whether the hot weather that is forecasted for next week will have any impact on air quality levels in the city. 

When Sam looks at the air pollution and weather app he will see a time series of pollution over a year and a graph of pollutant vs. temperature. If he would rather look at the effect of humidity on the pollutant he can choose that option from a dropdown menu. He is also able to choose the particular pollutant he is interested in. 
Sam will also be able to look at the daily distributions of pollutants to determine whether day of the week will have any impact on pollution levels in the city. 

Sam may choose to look at Nitrous Oxides (NOx). He sees that high temperatures generally mean higher concentrations of NOx, and looking at the daily distributions, he see that these concentrations are generally higher on weekdays. He may determine that in line with his prior knowledge, this is likely due to higher vehicle traffic which produces NOx. 



