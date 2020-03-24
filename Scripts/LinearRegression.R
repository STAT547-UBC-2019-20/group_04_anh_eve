# March 2020
# Anh Le

# script to run linear regression, plotting coefficients and other analysis
# Export any plots you want to include in your final report as an image (to the images directory)
# Export your model object to an RDS file so you can load this file in your final report 
# Use the tidy, augment, or glance functions from the broom package to reference the model’s statistical findings
# Add a line in the Usage section on how to use this script
"
This script run linear regression, and any subsequent explorations and analyses using the cleaned data. 

Usage: LinearRegression.R --path=<path> --datafilename=<datafilename>
" -> doc

library(broom)
library(dotwhisker)
library(here)
library(tidyverse)
library(DT)
library(knitr)
library(lubridate) 
library(tidyquant)
library(corrplot)
library(ggplot2)
library(cowplot)
library(docopt)


opt <- docopt(doc)

main <- function(path, datafilename){
  
  ##### READ DATA
  data <- readr::read_csv(here::here(glue::glue(path, datafilename)))
  
  
  ##### Aggregate Daily Average
  airq_daily = data %>%
    group_by(Date) %>%
    summarise_all(funs(mean), na.rm = TRUE)
  
  ##### Regressions for ALL chemicals
  regressions = airq_daily %>% 
    select(-c(Date, Time, Date_time, Temp, RH, AH )) %>%  # leave only dependent variables
    map(~lm(.x ~  Temp + AH, data = airq_daily)) %>% 
    map(tidy) 
  
  ##### Export your model object to an RDS file
  
  chemnames <- c("CO", "Tin_oxide", "Hydro_carbons", "Benzene", 
                "Titania", "NOx", "Tungsten_oxide_NOx", "NO2", "Tungsten_oxide_NO2", 
                "Indium_oxide")
  
  for (i in 1:length(regressions)) {
    assign(chemnames[[i]], regressions[[i]])
    saveRDS(regressions[[i]], file = paste("Data/",chemnames[[i]], ".rds", sep = ""))
  }
  
  
  ##### COEFFICIENTS PLOTS
  
  #NOx %>% mutate(model = "NOx"), 
  #Tungsten_oxide_NOx %>% mutate(model = "Tungsten Oxide NOx"), 
  #NO2 %>% mutate(model = "NO2"),
  #Tungsten_oxide_NO2 %>% mutate(model = "Tungsten Oxide NO2"), 
  #Indium_oxide %>% mutate(model = "Indium Oxide")) 
  #CO %>% mutate(model = "CO"), 
  #Hydro_carbons %>% mutate(model = "Hydro Carbons"),
  
  chemModels <- rbind(Tin_oxide %>% mutate(model = "Tin Oxide"),
                      Benzene %>% mutate(model = "Benzene"), 
                      Titania %>% mutate(model = "Titania")) %>%
    relabel_predictors(c(Temp = "Temperature",
                         AH = "Absolute Humidity"))
  
  # coef_plot ----
  coef_plot = small_multiple(chemModels, dot_args = list(size = 0.75),
                             whisker_args = list(size = 0.5), dist_args = list(alpha = 0.5),
                             line_args = list(alpha = 0.75, size = 0.5), style = "distribution") +
    geom_hline(yintercept = 0, colour = "grey60", linetype = 2) +
    theme_bw() + 
    xlab("Pollutants/ Dependant Variables") +
    ylab("Coefficient Estimates") +
    ggtitle("Coefficient Estimates for Predicting Air Pollutants' Concentrate") +
    theme(legend.position = "none")
      

  
  ### add some more plots with the linear regression line:
  benzene_coefs <- readRDS(here::here("Data", "Benzene.rds"))
  tita_coefs <- readRDS(here::here("Data", "Titania.rds"))
  tin_coefs <- readRDS(here::here("Data", "Tin_oxide.rds"))
  
  lr_b <- benzene_coefs[2][[1]][2]*data["Temp"] + benzene_coefs[2][[1]][1]
  lr_titania <- tita_coefs[2][[1]][2]*data["Temp"] + tita_coefs[2][[1]][1]
  lr_tin <- tin_coefs[2][[1]][2]*data["Temp"] + tin_coefs[2][[1]][1]
  new_data <- data
  new_data["lr_b"] <- lr_b
  new_data["lr_titania"] <- lr_titania
  new_data["lr_tin"] <- lr_tin
  
  corb <- cor(new_data["Benzene"], new_data["Temp"], use = "complete.obs")
  cor_tin <- cor(new_data["Tin_oxide"], new_data["Temp"], use = "complete.obs")
  cor_t <- cor(new_data["Titania"], new_data["Temp"], use = "complete.obs")
  
  lr1 <- new_data %>% 
    ggplot() + 
    geom_point(aes(y=Benzene, x=Temp), alpha=0.2) +
    geom_line(aes(x=Temp, y=lr_b), color="red")+
    theme_bw() +
    xlab("Temperature (Degrees C)") +
    ylab("concentration (microg/m^3)")+
    ggtitle(glue::glue("Benzene concentration variation with temperature (corr = {round(corb, 2)})"))
  
  lr2 <- new_data %>% 
    ggplot() + 
    geom_point(aes(y=Titania, x=Temp), alpha=0.2) +
    geom_line(aes(x=Temp, y=lr_titania), color="red")+
    theme_bw() +
    xlab("Temperature (Degrees C)") +
    ylab("concentration (microg/m^3)")+
    ggtitle(glue::glue("Titania concentration variation with temperature (corr = {round(cor_t, 2)})"))
  
  lr3 <- new_data %>% 
    ggplot() + 
    geom_point(aes(y=Tin_oxide, x=Temp), alpha=0.2) +
    geom_line(aes(x=Temp, y=lr_tin), color="red")+
    theme_bw() +
    xlab("Temperature (Degrees C)") +
    ylab("concentration (microg/m^3)")+
    ggtitle(glue::glue("Tin Oxide concentration variation with temperature (corr = {round(cor_tin, 2)})"))
   
   
  # lrplot ----
  lrplot <- plot_grid(lr1, lr2, lr3, ncol=1)
  
  
  
  ##### NEW PLOT WITH LINEAR REGRESSION LINES
  
  fit1 <- lm(new_data$Benzene ~  new_data$Temp + new_data$AH)
  fit2 <- lm(new_data$Titania ~  new_data$Temp + new_data$AH)
  fit3 <- lm(new_data$Tin_oxide ~  new_data$Temp + new_data$AH)
  
  corb <- summary(fit1)$r.squared
  cor_tin <- summary(fit3)$r.squared
  cor_t <- summary(fit2)$r.squared
  
  
  equation1=function(x){coef(fit1)[2]*x+coef(fit1)[1]}
  equation2=function(x){coef(fit2)[2]*x+coef(fit2)[1]}
  equation3=function(x){coef(fit3)[2]*x+coef(fit3)[1]}
  
  np1 <- new_data %>% 
    ggplot(aes(y=Benzene,x=Temp,color=AH))+
    geom_point()+
    stat_function(fun=equation1,geom="line",color=scales::hue_pal()(2)[1])+
    theme_bw() +
    xlab("Temperature (Degrees C)") +
    ylab("concentration (microg/m^3)")+
    ggtitle(glue::glue("Benzene concentration variation with temperature (corr = {round(corb, 2)})"))
  
  np2 <- new_data %>% 
    ggplot(aes(y=Titania,x=Temp,color=AH))+
    geom_point()+
    stat_function(fun=equation2,geom="line",color=scales::hue_pal()(2)[1])+
    theme_bw() +
    xlab("Temperature (Degrees C)") +
    ylab("concentration (microg/m^3)")+
    ggtitle(glue::glue("Titania concentration variation with temperature (corr = {round(cor_t, 2)})"))
  
  
  np3 <- new_data %>% 
    ggplot(aes(y=Tin_oxide,x=Temp,color=AH))+
    geom_point()+
    stat_function(fun=equation3,geom="line",color=scales::hue_pal()(2)[1])+
    theme_bw() +
    xlab("Temperature (Degrees C)") +
    ylab("concentration (microg/m^3)")+
    ggtitle(glue::glue("Tin oxide concentration variation with temperature (corr = {round(cor_tin, 2)})"))
  
  
  # more_lrplots ----
  more_lrplots <- plot_grid(np1, np2, np3, ncol=1)
  
  
  ### Align plots ----
  
  aligned_plots <- align_plots(coef_plot, lrplot, more_lrplots, align = 'h', axis = 'lr')
  
  coef = ggdraw(aligned_plots[[1]]) %>%
    ggsave(filename = "Images/CoefPlot_Group4.png", device = 'png', width=7, height=4.5)
  lr = ggdraw(aligned_plots[[2]]) %>%
    ggsave(filename = "Images/lr_plots.png", device = 'png', width=9, height=10)
  more_lr = ggdraw(aligned_plots[[3]]) %>%
    ggsave(filename = "Images/more_lr_plots.png", device = 'png', width=9, height=10)

  
  
  print("Script should have run sucessfully")
  print("Images saves to Images folder")
  
}

main(opt$path, opt$datafilename)












