
#######################################


# 1. Make plot ----
plot_aq_w_time_e <- function(yaxis = "Benzene"){
  
  # gets the label matching the column value
  y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  
  
  # make the polutant plot
  p1 <- airq_daily %>% 
    ggplot(aes(x = Date, y = !!sym(yaxis))) + 
    geom_line(na.rm = T, color='green', size = 0.3) +
    theme_bw() +
    #coord_x_date(xlim = c("2005-01-04", "2005-04-04")) +
    xlab("Date") +
    ylab("Concentration (microg/m<sup>3</sup>)")+
    ggtitle(paste0("Variation of ", y_label, " concentration over time ")) 
  
  
  ggplotly(p1) %>% layout(
    # NEW: this is optional but changes how the graph appears on click
    # more layout stuff: https://plotly-r.com/improving-ggplotly.html
    xaxis = list(
      rangeslider = list(type = "date")))
}


#######################################

plot_aq_w_wx <- function(yaxis = "Benzene",
                           weather = "Temp"){
  
  # gets the label matching the column value
  y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  
  # make the polutant plot
  
  plot_bz_w_time <- airq_daily %>% 
    ggplot(aes(x = !!sym(weather), y = !!sym(yaxis))) + 
    geom_point(na.rm = T, alpha = 0.8) +
    theme_bw() +
    xlab(weather) +
    ylab("Concentration (microg/m<sup>3</sup>)")+
    ggtitle(paste0("Variation of ", y_label, " with ", weather)) 
  

  
  ggplotly(plot_bz_w_time) 
  
}

#######################################

# create a distribution plot
dist_plot <- function(yaxis = "Benzene"){
  
  # gets the label matching the column value
  y_label <- yaxisKey$label[yaxisKey$value==yaxis]
  
  
  plot <- newdata %>% 
    ggplot() + 
    geom_violin(aes(x = DOTW, y = !!sym(yaxis), fill=DOTW), width=1.2) +
    geom_boxplot(aes(x = DOTW, y = !!sym(yaxis)), width=0.1, color="grey", alpha=0.4) +
    theme_bw() +
    labs(y = paste0("Concentration of ", y_label), 
         x= "Day of the week") +
    scale_x_discrete(drop = FALSE)+
    theme(legend.position="none")
  
  
  ggplotly(plot)
}


