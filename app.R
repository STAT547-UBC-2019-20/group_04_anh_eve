# created by: Anh Le 
# edited by:
# date: Mar 20 2020

"This script is the main file that creates a Dash app for Group 4 project on the pollutants dataset.

Usage: app.R
"

library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
library(gapminder)

# load in the functions that make graphs
source('Scripts/dash_functions.R')

######################################################

# > Load data
data <- readr::read_csv(here::here("Data","clean_aq.csv"))
#Aggregate Daily Average
airq_daily <- data %>%
  group_by(Date) %>%
  summarise_all(list(mean), na.rm = TRUE)

# set up column for day of the week
newdata <- data %>% 
  mutate(DOTW = factor(case_when(weekdays(Date) == 'Monday' ~ 'Monday',
                                 weekdays(Date) == 'Tuesday' ~ 'Tuesday',
                                 weekdays(Date) == 'Wednesday' ~ 'Wednesday',
                                 weekdays(Date) == 'Thursday' ~ 'Thursday',
                                 weekdays(Date) == 'Friday' ~ 'Friday',
                                 weekdays(Date) == 'Saturday' ~ 'Saturday',
                                 weekdays(Date) == 'Sunday' ~ 'Sunday'),
                       levels = c("Monday" , "Tuesday","Wednesday", "Thursday","Friday", "Saturday", "Sunday")))


######################################################

# 2. Assign components to variables ----
# >> Heading ----
title <- htmlH1('Air quality and weather explorer')

intro_text <- dccMarkdown('The adverse affects of air pollution on health are well documented and air pollution can lead to a large range of diseases and increased morbidity and mortality. Adverse health impacts include, but are not limited to, lung cancer risk, respiritory infections, allergic disease and asthma. These health risks can affect a large proportion of the population as many different groups are vulnerable to the effects of air pollution including infants, children, the elderly, people with impaired immune systems, and people who work or are physically active outdoors.

Because of the many, and severe, impacts of air quality, it is important to understand patterns in the data. We have a dataset of air quality observations as well as temperature and humidity data which we will use to gain understanding of the patterns and impacts of weather on air quality. 
                          
For this reason our research question is: What is the affect of temperature and humidity on the concentration of air pollutants, such as benzene, titania, and tin oxide?') 

annotation <- dccMarkdown('Here you can examine the effect of temperature and humidity on air pollutants. 
                          Plot 1 shows the variation of pollutants over the year that data was collected. 
                          You can zoom in on certain time periods by using the date slider below the graph. 
                          Plot 2 shows the relationship of the pollutant concentrations with different 
                          weather variables. Plot 3 shows the weekly variation of the pollutant. 
                          Both the pollutant and weather variable can be selected in a dropdown on the 
                          left hand side of the page.
                          The data source is the UCI Machine Learning Repository: https://archive.ics.uci.edu/ml/datasets/Air+Quality')



# >> Dropdown component for Pollutants ----
# Storing the labels/values as a tibble means we can use this both 
# to create the dropdown and convert colnames -> labels when plotting
yaxisKey <- tibble(label = c("Carbon monoxide", 
                             "Tin oxide", 
                             "Hydrocarbons", 
                             "Benzene",
                             "Titania", 
                             "NOx", 
                             "Tungsten oxide (NOx)", 
                             "NO2",
                             "Tungsten oxide (NO2)",
                             "Indium oxide"),
                   value = c("CO", "Tin_oxide", "Hydro_carbons", "Benzene", 
                             "Titania", "NOx", "Tungsten_oxide_NOx", "NO2", 
                             "Tungsten_oxide_NO2", "Indium_oxide"))
#Create the dropdown
yaxisDropdown <- dccDropdown(
  id = "y-axis",
  options = map(
    1:nrow(yaxisKey), function(i){
      list(label=yaxisKey$label[i], value=yaxisKey$value[i])
    }),
  value = "Benzene"
)


# >> Dropdown component for Weather:
# Storing the labels/values as a tibble means we can use this both 
# to create the dropdown and convert colnames -> labels when plotting
weatherKey <- tibble(label = c("Temperature (C)", 
                               "Absolute Humidity (g/m3)", "Relative Humidity (%)"),
                     value = c("Temp", "AH", "RH"))
#Create the dropdown
weatherDropdown <- dccDropdown(
  id = "weather",
  options = map(
    1:nrow(weatherKey), function(i){
      list(label=weatherKey$label[i], value=weatherKey$value[i])
    }),
  value = "Temp"
)


# >> Graphs


graph1 <- dccGraph(
  id = 'graph1',
  figure=plot_aq_w_time() # gets initial data using argument defaults
)

dist_graph <- dccGraph(
  id = 'dist',
  figure=dist_plot()
)

aq_wx <- dccGraph(
  id = 'aqwx',
  figure=plot_aq_w_wx()
)


######################################################

# 3. Create instance of a Dash App ----
app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css") 


######################################################

# 4. Specify App layout ----

# layout with side bar etc. 

div_header <- htmlDiv(
  list(title, 
       intro_text)
)


div_sidebar <- htmlDiv(
  list(
    #selection components
    htmlLabel('Select Pollutant:'),
    yaxisDropdown,
    htmlBr(),
    htmlLabel('Select Weather Variable:'),
    weatherDropdown,
    htmlBr(),
    annotation

  ), style= list('flex-basis' = '20%')
)


div_main <- htmlDiv(
  list(graph1,
       dist_graph,
       htmlBr(),
       aq_wx,
       htmlBr()
  ), style= list('flex-basis' = '70%')
)

# specify layout:

app$layout(
  htmlDiv(list(
  div_header),
  style = list(
    backgroundColor = '#0B2326', 
    textAlign = 'center',
    color = 'white',
    margin = 5,
    marginTop = 0
  )),
  htmlDiv(
    list(
      div_sidebar,
      div_main
    ),
    style = list('display' = 'flex', 'background-color' = 'white'),
  )
)



######################################################

# 5. App Callbacks ----


# graph1
app$callback(
  #update figure of plot_aq_w_time
  output=list(id = 'graph1', property='figure'),
  #based on values of date, y-axis components
  params=list(input(id = 'y-axis', property='value')),
  #this translates your list of params into function arguments
  function(yaxis) {
    plot_aq_w_time(yaxis)
  })


# graph2
app$callback(
  #update distribution plot
  output=list(id = 'dist', property='figure'),
  #based on values of date, y-axis components
  params=list(input(id = 'y-axis', property='value')),
  #this translates your list of params into function arguments
  function(yaxis) {
    dist_plot(yaxis)
  })

# plot 3
app$callback(
  #update figure of plot_aq_w_wx
  output=list(id = 'aqwx', property='figure'),
  #based on values of date, y-axis components
  params=list(input(id = 'y-axis', property='value'),
              input(id = 'weather', property = 'value')),
  #this translates your list of params into function arguments
  function(yaxis, weather) {
    plot_aq_w_wx(yaxis, weather)
  })


######################################################

# 6. Update Plot ----


######################################################

# 7. Run app ----
app$run_server(debug=TRUE) #runs the Dash app, automatically reload the dashboard when changes are made

# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")





