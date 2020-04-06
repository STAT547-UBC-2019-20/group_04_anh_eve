
#######################################
# 1. Make plot ----
plot_aq_w_time <- function(yaxis = "Benzene"){
  
  # gets the label matching the column value
  y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  
  #add second y axis
  ay <- list(
    tickfont = list(color = "red"),
    overlaying = "y",
    side = "right",
    title = "Celsius"
  )
  
  # make the polutant plot
  p1 <- airq_daily %>% 
    ggplot(aes(x = Date, y = !!sym(yaxis))) + 
    geom_line(na.rm = T, color='green', size = 0.3) +
    theme_bw() +
    #coord_x_date(xlim = c("2005-01-04", "2005-04-04")) +
    xlab("Choose Time Range from March 2004 to April 2005") +
    ylab("Concentration (microg/m<sup>3</sup>)")+
    ggtitle(paste0("Daily concentration of ", y_label, " from March 2004 to April 2005 ")) + 
    scale_x_date(date_breaks = "1 month", date_minor_breaks = "1 week",
                 date_labels = "%B")
    
  p2 = p1 + geom_line(data = airq_daily, aes(y = Temp, color = "red"))
  
  ggplotly(p1, width = 900, height = 300) %>% 
    #add_lines(name = "Pollutant concentration") %>% 
    #add_lines(name = "Temperature", yaxis = "y2") %>% 
    plotly::layout(
    # NEW: this is optional but changes how the graph appears on click
    # more layout stuff: https://plotly-r.com/improving-ggplotly.html
     xaxis = list(
       rangeslider = list(type = "date"))
    )
}


#######################################

plot_aq_w_wx <- function(yaxis = "Benzene",
                           weather = "Temp"){
  
  # gets the label matching the column value
  y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  w_label <- weatherKey$label[weatherKey$value==weather]
  
  # make the polutant plot
  
  plot_bz_w_time <- airq_daily %>% 
    ggplot(aes(x = !!sym(weather), y = !!sym(yaxis))) + 
    geom_point(na.rm = T, alpha = 0.8) +
    theme_bw() +
    xlab(w_label) +
    ylab("Concentration (microg/m<sup>3</sup>)")+
    ggtitle(paste0("Daily variation of ", y_label, " with ", w_label)) 
  

  
  ggplotly(plot_bz_w_time, width = 900, height = 400)
}

#######################################

# create a distribution plot
dist_plot <- function(yaxis = "Benzene"){
  
  # gets the label matching the column value
  y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  
  plot <- newdata %>% 
    ggplot() + 
    geom_violin(aes(x = DOTW, y = !!sym(yaxis), fill=DOTW), width=1.2, alpha=0.4) +
    geom_boxplot(aes(x = DOTW, y = !!sym(yaxis)), width=0.1, color="grey") +
    theme_bw() +
    labs(y = paste0("Concentration of ", y_label), 
         x= "Day of the week") +
    scale_x_discrete(drop = FALSE)+
    theme(legend.position="none")+
    ggtitle(paste0("Weekly distribution of ", y_label, " concentration"))
  
  
  ggplotly(plot,width = 900, height = 300)
}


