# Step 0 - Reset R Studio
rm(list = ls()) # remove variables
graphics.off() # clear graphs

# To use the missForest and amelia package, you first need to install and load 1st
# Install packages if needed --------------------------------
pkgs <- c("forecast", "highcharter")
to_install <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
if (length(to_install) > 0) install.packages(to_install)
library(forecast)
library(highcharter)
library(readr)
setwd("C:/repos/iSchool/BUA-345-BusinessAnalytics/Week-07")
getwd()

pricesDF = read_csv("MCD-monthly-prices.csv")
head(pricesDF)
str(pricesDF)

# convert to a time series
pricesTS <- ts(
  pricesDF$Close,
  start = c(pricesDF$Year[1], pricesDF$Month[1]),
  frequency = 12
)

head(pricesTS)
str(pricesTS)

library(dplyr)
library(lubridate)
pricesDF2 <- pricesDF %>%
  mutate(
    Date = make_date(Year, Month, 1),      # first day of month
    Date = ceiling_date(Date, "month") - 1 # last calendar day
  ) %>%
  arrange(Date)

pricesDF2$Date_ms <- datetime_to_timestamp(pricesDF2$Date)


highchart(type = "stock") %>%
  hc_add_theme(hc_theme_darkunica()) %>%
  hc_add_series(pricesDF2,type = "scatter",hcaes(x = Date_ms, y = Close),name = "MCD Monthly Close") %>%
  hc_title(text = "MCD Monthly Closing Prices") %>%
  hc_xAxis(type = "datetime") %>%
  hc_yAxis(title = list(text = "Close Price")) %>%
  hc_tooltip(useHTML = TRUE,  formatter = JS(
    "function () {
         return Highcharts.dateFormat('%b %e, %Y', this.x) +
                '<br/>Close: ' + this.y;
       }"
  )
)

# Fit ARIMA model
pricesFIT <- auto.arima(pricesTS)

pricesFIT  

# Series: pricesTS 
# ARIMA(0,1,0) 
# 
# sigma^2 = 183.2:  log likelihood = -241.45
# AIC=484.91   AICc=484.97   BIC=487

# ⭐ How to interpret the whole block
# Your ARIMA model:
#   
#   fits reasonably (sigma² is not extreme)
# 
# is not overfitting (AIC and BIC are close)
# 
# is stable (AIC ≈ AICc)
# 
# is likely a good forecasting candidate

fitted_vals <- fitted(pricesFIT)
library(zoo)

df_fitted <- data.frame(
  Date = as.Date(as.yearmon(time(fitted_vals))),
  Fitted = as.numeric(fitted_vals)
)
df_fitted$Date_ms <- datetime_to_timestamp(df_fitted$Date)

highchart(type = "stock") %>%
  hc_add_theme(hc_theme_darkunica()) %>%
  
  # Actual data (scatter)
  hc_add_series(pricesDF2,type = "scatter",hcaes(x = Date_ms, y = Close),name = "Actual Close") %>%
  
  # ARIMA fitted values (line)
  hc_add_series(df_fitted,type = "line",hcaes(x = Date_ms, y = Fitted), name = "ARIMA Fitted",
    color = "#FF5733",lineWidth = 2) %>%
  
  hc_title(text = "MCD Monthly Closing Prices with ARIMA Fitted Values") %>%
  hc_xAxis(type = "datetime") %>%
  hc_yAxis(title = list(text = "Price")) %>%
  
  # Custom tooltip (fixes integer date issue)
  hc_tooltip(
    useHTML = TRUE,
    formatter = JS(
      "function () {
         return Highcharts.dateFormat('%b %e, %Y', this.x) +
                '<br/>Value: ' + this.y;
       }"
    )
  )

pricesFC <- forecast(pricesFIT, h = 12, level=c(80,95))

pricesFC

library(zoo)
library(highcharter)

df_fc <- data.frame(
  Date = as.Date(time(pricesFC$mean)),
  Forecast = as.numeric(pricesFC$mean),
  Lo80 = as.numeric(pricesFC$lower[,1]),
  Hi80 = as.numeric(pricesFC$upper[,1]),
  Lo95 = as.numeric(pricesFC$lower[,2]),
  Hi95 = as.numeric(pricesFC$upper[,2])
)

# Convert to milliseconds for Highcharts
df_fc$Date_ms <- datetime_to_timestamp(df_fc$Date)

hc <- highchart(type = "stock") %>%
  hc_add_theme(hc_theme_darkunica()) %>%
  
  # Actual data (scatter)
  hc_add_series(pricesDF2,type = "scatter",hcaes(x = Date_ms, y = Close),name = "Actual Close") %>%
  
  # ARIMA fitted values (line)
  hc_add_series(df_fitted,type = "line",hcaes(x = Date_ms, y = Fitted), name = "ARIMA Fitted",
                color = "#FF5733",lineWidth = 2) %>%
  # Forecast line
  hc_add_series(df_fc,    type = "line",
    hcaes(x = Date_ms, y = Forecast),
    name = "ARIMA Forecast",
    color = "#0072B2",
    lineWidth = 2
  ) %>%
  
  # 80% CI band
  hc_add_series(df_fc,  type = "arearange",
    hcaes(x = Date_ms, low = Lo80, high = Hi80),
    name = "80% CI",
    color = hex_to_rgba("#0072B2", 0.2),
    lineWidth = 0,
    linkedTo = ":previous"
  ) %>%
  
  # 95% CI band
  hc_add_series(
    df_fc,
    type = "arearange",
    hcaes(x = Date_ms, low = Lo95, high = Hi95),
    name = "95% CI",
    color = hex_to_rgba("#0072B2", 0.1),
    lineWidth = 0,
    linkedTo = ":previous"
  ) %>%
  hc_title(text = "MCD Monthly Closing Prices with ARIMA Fitted Values") %>%
  hc_xAxis(type = "datetime") %>%
  hc_yAxis(title = list(text = "Price")) %>%
  
  # Custom tooltip (fixes integer date issue)
  hc_tooltip(
    useHTML = TRUE,
    formatter = JS(
      "function () {
         return Highcharts.dateFormat('%b %e, %Y', this.x) +
                '<br/>Value: ' + this.y;
       }"
    )
  )

library(htmlwidgets)
saveWidget(hc, "MCD-monthly-price-forecast.html", selfcontained = TRUE)
