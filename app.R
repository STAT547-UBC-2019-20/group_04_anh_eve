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

intro_text <- dccMarkdown('This app will be used to examine the effect of temperature and humidity on pollutants. Users will be able to select different variables to look at and compare. They will be able to choose between temperature and humidity to display on the x-axis and between any of the recorded pollutants to display on the y axis. 

They will also be able to choose an averaging period over which to look at the data as a time series (monthly, weekly or daily). There will also be a plot showing the daily distribution of pollutants with a dropdown to select the pollutant. 
                          
')


# >> Dropdown component for Pollutants ----
# Storing the labels/values as a tibble means we can use this both 
# to create the dropdown and convert colnames -> labels when plotting
yaxisKey <- tibble(label = c("Carbon monoxide (reference analyzer)", 
                             "Tin oxide (nominally CO targeted)", 
                             "Overall non-metanic Hydrocarbons (reference analyzer)", 
                             "Benzene (reference analyzer)",
                             "Titania (nominally NMHC targeted)", 
                             "NOx (reference analyzer)", 
                             "Tungsten oxide (nominally NOx targeted)", 
                             "NO2 (reference analyzer)",
                             "Tungsten oxide (nominally NO2 targeted)",
                             "Indium oxide (nominally O3 targeted)"),
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
weatherKey <- tibble(label = c("Temperature in Celcius", 
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
  figure=plot_aq_w_time_e() # gets initial data using argument defaults
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
app$layout( #describes the layout of the app.
  htmlDiv(
    list(
      title,
      htmlIframe(height=10, width=10, style=list(borderWidth = 0)), #space
      intro_text,
      #selection components
      htmlIframe(height=25, width=10, style=list(borderWidth = 0)), #space
      htmlLabel('Select Polutants:'),
      yaxisDropdown,
      htmlIframe(height=25, width=10, style=list(borderWidth = 0)), #space
      #graph
      graph1,
      htmlIframe(height=25, width=10, style=list(borderWidth = 0)), #space,
      htmlLabel('Select Weather Variable:'),
      weatherDropdown,
      htmlIframe(height=25, width=10, style=list(borderWidth = 0)), #space
      # air quality weather graph
      aq_wx,
      htmlIframe(height=25, width=10, style=list(borderWidth = 0)),
      # eve's new graph
      dist_graph,
      htmlIframe(height=25, width=10, style=list(borderWidth = 0))
    )
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





