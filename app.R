# created by: Anh Le 
# edited by:
# date: Mar 20 2020

"This script is the main file that creates a Dash app for Group 4 project on the pollutants dataset.

Usage: app.R
"

## 1. Load libraries ----
library(dash)
library(dashCoreComponents)
library(dashHtmlComponents)
library(dashTable)
library(tidyverse)
library(plotly)
library(gapminder)

# > Make plot ----

# > Assign components to variables ----

# > Create Dash instance ----


# 2. Create instance of a Dash App ----
app <- Dash$new() # creates a new instance of a dash app


# 3. Specify App layout ----
app$layout( #describes the layout of the app.
  htmlDiv(
    list(
      ### Add components here
    )
  )
)

# 4. App Callbacks ----

# 5. Update Plot ----

# 6. Run app ----
app$run_server(debug=TRUE) #runs the Dash app, automatically reload the dashboard when changes are made

# command to add dash app in Rstudio viewer:
# rstudioapi::viewer("http://127.0.0.1:8050")





