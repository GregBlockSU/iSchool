# Step 0 - Reset R Studio
rm(list = ls()) # remove variables
graphics.off() # clear graphs

# To use the missForest and amelia package, you first need to install and load 1st
# Install packages if needed --------------------------------
pkgs <- c("forecast", "highcharter", "zoo", "dplyr", "lubridate")
to_install <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
if (length(to_install) > 0) install.packages(to_install)
library(forecast)
library(highcharter)
library(readr)
setwd("C:/repos/iSchool/BUA-345-BusinessAnalytics/Week-07")
getwd()

pricesDF = read_csv("MCD-monthly-prices.csv")
head(pricesDF)

# Year Month Close
# <dbl> <dbl> <dbl>
#   1  2021     6  231.
# 2  2021     7  243.
# 3  2021     8  237.
# 4  2021     9  241.
# 5  2021    10  246.
# 6  2021    11  245.

str(pricesDF)

# spc_tbl_ [61 × 3] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
# $ Year : num [1:61] 2021 2021 2021 2021 2021 ...
# $ Month: num [1:61] 6 7 8 9 10 11 12 1 2 3 ...
# $ Close: num [1:61] 231 243 237 241 246 ...
# - attr(*, "spec")=
#   .. cols(
#     ..   Year = col_double(),
#     ..   Month = col_double(),
#     ..   Close = col_double()
#     .. )
# - attr(*, "problems")=<pointer: 0x000001d660ca7c90> 
#   

summary(pricesDF)

# Year          Month            Close      
# Min.   :2021   Min.   : 1.000   Min.   :230.7  
# 1st Qu.:2022   1st Qu.: 4.000   1st Qu.:259.4  
# Median :2023   Median : 6.000   Median :281.8  
# Mean   :2023   Mean   : 6.492   Mean   :279.0  
# 3rd Qu.:2025   3rd Qu.: 9.000   3rd Qu.:296.5  
# Max.   :2026   Max.   :12.000   Max.   :341.1

# convert to a time series
pricesTS <- ts(
  pricesDF$Close,
  start = c(pricesDF$Year[1], pricesDF$Month[1]),
  frequency = 12
)

head(pricesTS)

# Jun    Jul    Aug    Sep    Oct    Nov
# 2021 230.99 242.71 237.46 241.11 245.55 244.60

str(pricesTS)

# Time-Series [1:61] from 2021 to 2026: 231 243 237 241 246 ...

library(dplyr)
library(lubridate)
pricesDF2 <- pricesDF %>%
  mutate(
    Date = make_date(Year, Month, 1),      # first day of month
    Date = ceiling_date(Date, "month") - 1 # last calendar day
  ) %>%
  arrange(Date)

# create a new column called Date_ms 
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

# Point Forecast    Lo 80    Hi 80    Lo 95    Hi 95
# Jul 2026         284.77 267.4242 302.1158 258.2419 311.2981
# Aug 2026         284.77 260.2394 309.3006 247.2537 322.2863
# Sep 2026         284.77 254.7262 314.8138 238.8220 330.7180
# Oct 2026         284.77 250.0785 319.4615 231.7139 337.8261
# Nov 2026         284.77 245.9837 323.5563 225.4515 344.0885
# Dec 2026         284.77 242.2817 327.2583 219.7898 349.7502
# Jan 2027         284.77 238.8774 330.6626 214.5833 354.9567
# Feb 2027         284.77 235.7088 333.8312 209.7373 359.8027
# Mar 2027         284.77 232.7327 336.8073 205.1858 364.3542
# Apr 2027         284.77 229.9179 339.6221 200.8809 368.6591
# May 2027         284.77 227.2406 342.2994 196.7864 372.7536
# Jun 2027         284.77 224.6825 344.8575 192.8741 376.6659


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
