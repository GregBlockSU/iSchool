# Step 0 - Reset R Studio
rm(list = ls()) # remove variables
graphics.off() # clear graphs

# Step 1 - Load Week 3 Data Set
data_path <- "C:/Users/gregb/OneDrive/Syracuse/Courses/College of Professional Studies/BUA-345 - Business Analytics/Week-03"
setwd(data_path)
getwd()
load("Week 3 - Lab Data.RData")

write.csv(NASHVILLE, "Nashville.csv", row.names = TRUE)
# Step 2 - Explore Data Frame 
head(NASHVILLE)
View(NASHVILLE)

# Step 3 - Name and describe data elements in Data Frame
summary(NASHVILLE)

# Step 4 - Identify Dependent and Independent variables for Linear model

# dependent variable - PRICE
# independent variables - ACRES + AREA + BATHS + YEAR

# Step 5 - Construct and run Simple regression model 
model <- lm(PRICE ~ ACRES + AREA + BATHS + YEAR, data=NASHVILLE)
summary(model)

#Residuals:
#  Min      1Q  Median      3Q     Max 
#-227805  -58467  -18219   39819 1524703 

#Coefficients:
#  Estimate Std. Error t value             Pr(>|t|)    
#(Intercept) 1949851.88  273773.84   7.122     0.00000000000183 ***
#  ACRES         -2051.55    5738.48  -0.358                0.721    
#  AREA            101.87      10.19  10.000 < 0.0000000000000002 ***
#  BATHS         27923.65    6705.34   4.164     0.00003346179502 ***
#  YEAR           -999.95     141.09  -7.087     0.00000000000233 ***
#  ---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

#Residual standard error: 101300 on 1195 degrees of freedom
#Multiple R-squared:  0.1663,	Adjusted R-squared:  0.1635 
#F-statistic: 59.59 on 4 and 1195 DF,  p-value: < 0.00000000000000022

# install.packages("car")
library(car)
# Create a single combined visualization
avPlots(model, ask = FALSE)

# Step 6 - Identify intercept and coefficients

#(Intercept) 1949851.88  
#ACRES         -2051.55
#AREA            101.87
#BATHS         27923.65
#YEAR           -999.95

# PRICE = 1949851.88 + ACRES * -2051.55 + AREA * 101.87 + BATHS * 27923.65 + YEAR * -999.95

# Step 7 - Predict the price of a home for the following cases:

# 1. Home with .25 Acres, 1200 SF, 2 baths, and built in 1960

# 2. Home with .4 Acres, 1350 SF, 3 baths, and built in 1940

new_data = data.frame(ACRES=c(.25, .4),AREA=c(1200,1350),BATHS=c(2,3),YEAR=c(1960,1940))
head(new_data)
#use the fitted model to predict the rating for the new player
predict(model, newdata=new_data)

#1        2 
#167535.9 230431.5

new_data$PRICE_calc <- model$coefficients["(Intercept)"] +
                       model$coefficients["ACRES"] * new_data$ACRES +
                       model$coefficients["AREA"]  * new_data$AREA +
                       model$coefficients["BATHS"] * new_data$BATHS +
                       model$coefficients["YEAR"]  * new_data$YEAR

new_data$PRICE_calc
# 167535.9 230431.5

# how accurate is this model?
#⭐ 1. R‑squared and Adjusted R‑squared
#These tell you how much of PRICE variation the model explains.

#R² = proportion of variance explained

#Adjusted R² = penalized for number of predictors

#Interpretation:
  
#  0.00–0.20 → weak accuracy
#  0.20–0.40 → moderate
#  0.40–0.60 → strong for housing data
#  0.60+ → unusually strong unless you have location variables

#⭐ 2. Residual Standard Error (RSE)
#This is the average prediction error in dollars.

#Example:
#  If RSE = 100,000, your predictions are off by about $100k on average.

#Lower RSE = better accuracy.
