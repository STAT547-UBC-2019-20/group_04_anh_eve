# author: Anh Le
# date: Mar 12 2020
# makefile for Group4 STAT 547

# download data
aq.csv : Scripts/load_data.R
	load_data.R Rscript Scripts/load_data.R --url="https://raw.githubusercontent.com/STAT547-UBC-2019-20/data_sets/master/airquality.csv" --outfilename="aq.csv"

# clean data
clean_aq.csv : Scripts/clean_data.R data/clean_data.csv
	Rscript Scripts/clean_data.R --data_dir="Data" --infilename="aq.csv" --outfilename="clean_aq.csv"

# EDA
Images/correlation.png Images/pollutantsvstime.png Images/weathervstime.png Images/tempvsbenzene.png : EDA.R Data/clean_aq.csv
	Rscript Scripts/EDA.R --data_dir="Data" --datafilename="clean_aq.csv"
	
# LinearRegression
Images/CoefPlot_Group4.png Data/CO.rds, Data/Tin_oxide.rds, Data/Hydro_carbons.rds, Data/Benzene.rds, Data/Titania.rds, Data/NOx.rds, 
Data/Tungsten_oxide_NOx.rds, Data/NO2.rds, Data/Tungsten_oxide_NO2.rds, Data/Indium_oxide.rds : LinearRegression.R Data/clean_aq.csv
	Rscript Scripts/LinearRegression.R --data_dir="Data" --datafilename="clean_aq.csv"

# Knit report
docs/finalreport.html docs/finalreport.pdf : Images/correlation.png Images/pollutantsvstime.png Images/weathervstime.png Images/tempvsbenzene.png Docs/finalreport.Rmd Data/clean_aq.csv Scripts/Knit.R Docs/refs.bib
	Rscript Scripts/Knit.R --finalreport="docs/finalreport.Rmd"

# Phony target. Delete all files in data and images, leaving the script (delete .md and .html in docs). 
clean :
	rm -f Data/*
	rm -f Images/*
	rm -f Docs/*.md
	rm -f Docs/*.html

# Phony target. all is going to be a target, and its dependencies will be the final outputs of our data analysis pipeline. 
all: Docs/finalreport.html Docs/finalreport.pdf
