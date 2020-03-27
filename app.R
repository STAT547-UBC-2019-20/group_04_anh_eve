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

# > Load data
data <- readr::read_csv(here::here("Data","clean_aq.csv"))
#Aggregate Daily Average
airq_daily <- data %>%
  group_by(Date) %>%
  summarise_all(list(mean), na.rm = TRUE)

# 1. Make plot ----
plot_aq_w_time <- function(yaxis = "Benzene",
                           weather = "None"){
  
  # gets the label matching the column value
  y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  
  # Second y-axis
  ay <- list(
    overlaying = "y",
    side = "right"
  )
  
  # make the polutant plot
  p1 <- airq_daily %>% 
    ggplot(aes(x = Date, y = !!sym(yaxis))) + 
    geom_line(na.rm = T, color='green', size = 0.3) +
    theme_bw() +
    #coord_x_date(xlim = c("2005-01-04", "2005-04-04")) +
    xlab("Date") +
    ylab("microg/m<sup>3</sup>")+
    ggtitle(paste0("Variation of ", y_label, " concentration over time ")) 
  
  if (weather == "Temp"){
    p1 <- p1 + geom_line(data = airq_daily, aes(y = Temp),na.rm = T, color='red', size = 0.3) 
  } else {
    if (weather == "AH") {
      p1 <- p1 + geom_line(data = airq_daily, aes(y = AH),na.rm = T, color='dodgerblue4', size = 0.3) 
    } else {
      if (weather == "RH") {
        p1 <- p1 + geom_line(data = airq_daily, aes(y = RH),na.rm = T, color='dodgerblue', size = 0.3)
      }
    }
  }
  
  ggplotly(p1) %>% layout(
    # NEW: this is optional but changes how the graph appears on click
    # more layout stuff: https://plotly-r.com/improving-ggplotly.html
    xaxis = list(
      rangeslider = list(type = "date")),
    yaxis2 = ay)
}


plot_aq_w_temp <- function(yaxis = "Benzene"){
  
  # gets the label matching the column value
  y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  
  # make second axis
  ay <- list(
    tickfont = list(color = "red"),
    overlaying = "y",
    side = "right",
    title = "second y axis"
  )
  # make the polutant plot
  p1 <- airq_daily %>% 
    ggplot(aes(x = Date, y = !!sym(yaxis))) + 
    geom_line(na.rm = T, color='green', size = 0.3) +
    theme_bw() +
    #coord_x_date(xlim = c("2005-01-04", "2005-04-04")) +
    xlab("Date") +
    ylab("microg/m<sup>3</sup>")+
    ggtitle(paste0("Variation of ", y_label, " concentration over time ")) 
  
  ggplotly(p1) %>% layout(
    # NEW: this is optional but changes how the graph appears on click
    # more layout stuff: https://plotly-r.com/improving-ggplotly.html
    xaxis = list(
      rangeslider = list(type = "date")))
}



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
weatherKey <- tibble(label = c("None", "Temperature in Celcius", 
                               "Absolute Humidity (g/m3)", "Relative Humidity (%)"),
                     value = c("None", "Temp", "AH", "RH"))
#Create the dropdown
weatherDropdown <- dccDropdown(
  id = "weather",
  options = map(
    1:nrow(weatherKey), function(i){
      list(label=weatherKey$label[i], value=weatherKey$value[i])
    }),
  value = "None"
)


# >> Graphs

graph1 <- dccGraph(
  id = 'graph1',
  figure=plot_aq_w_time() # gets initial data using argument defaults
)


# 3. Create instance of a Dash App ----
app <- Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css") 


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
      weatherDropdown,
      htmlIframe(height=25, width=10, style=list(borderWidth = 0)), #space
      #graph
      graph1,
      htmlIframe(height=25, width=10, style=list(borderWidth = 0)) #space
    )
  )
)

# 5. App Callbacks ----

# graph1
app$callback(
  #update figure of plot_aq_w_time
  output=list(id = 'graph1', property='figure'),
  #based on values of date, y-axis components
  params=list(input(id = 'y-axis', property='value'),
              input(id = 'weather', property = 'value')),
  #this translates your list of params into function arguments
  function(yaxis, weather) {
    plot_aq_w_time(yaxis, weather)
  })


# 6. Update Plot ----

# 7. Run app ----
app$run_server(debug=TRUE) #runs the Dash app, automatically reload the dashboard when changes are made

# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")





