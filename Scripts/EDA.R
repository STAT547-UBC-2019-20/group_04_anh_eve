# March 2020
# Eve Wicksteed and Anh Le

# script to create and save plots

# create diff functions for each plot

### NEED TO CREATE ONE MAIN FUNCTION TO CALL ALL PLOT FUNCTIONS
### NEED TO SAVE PLOTS TO PLOT DIRECTORY

# correlation plot
corr_plot <- function(data){
  corr_data <- cor(data[3:15], use = "complete.obs")
  
  # Round the values to 2 decimal places
  corr_data <- round(corr_data,2)
  corrplot(corr_data, 
           type="upper", 
           method="color",
           tl.srt=45, 
           tl.col = "blue",
           diag = FALSE)
  
}



# daily pollutants vs. time
aq_time_plot <- function(data){
  
  #Aggregate Daily Average
  airq_daily <- data %>%
    group_by(Date) %>%
    summarise_all(funs(mean), na.rm = TRUE)
  
  #data preparation: short to long, select pollutants to be included
  airq.lg.d <- airq_daily %>%
    select(Date, `PT08.S1(CO)`,`C6H6(GT)`, `PT08.S2(NMHC)`) %>% 
    gather(key = "Variable", value = "Value", -Date)

  plot_aq_w_time <- airq.lg.d %>% 
    drop_na(Value) %>%
    ggplot(aes(x = Date, y = Value)) + 
    geom_line(aes(color = Variable, linetype = Variable)) +
    theme_bw() +
    #coord_x_date(xlim = c("2005-01-04", "2005-04-04")) +
    xlab("Time") +
    ylab("microg/m^3")+
    ggtitle("Pollutant variation with time")
}



# daily weather vs. time
weather_time_plot <- function(data){
  
  #Aggregate Daily Average
  airq_daily <- data %>%
    group_by(Date) %>%
    summarise_all(funs(mean), na.rm = TRUE)
  
  weather.dly.long <- airq_daily %>%
    select(Date,`T`, `RH`) %>%
    gather(key = "Variable", value = "Value", -Date)
  
  plot_wx_w_time <- airq_daily %>% 
    ggplot(aes(x = Date)) + 
    geom_line(aes(y=T, colour = "Temperature")) +
    theme_bw() +
    #coord_x_datetime(xlim = c("2005-01-04", "2005-04-04")) +
    xlab("Time") +
    ylab("Temperature (Degrees C)") +
    geom_line(aes(y=RH, colour = "Humidity")) +
    scale_y_continuous(sec.axis = sec_axis(~., name = "Relative Humidity (%)")) +
    ggtitle("Weather variation with time")
  
  
}



# Plot of temp vs. benzene
plot_temp_benzene <- function(data){
  airq_daily <- data %>%
    group_by(Date) %>%
    summarise_all(funs(mean), na.rm = TRUE)
  
  data.long <- airq_daily %>%
    select(Date,`T`, `RH`)
  
  ### NEED TO COMPLETE THIS PLOT
}














  