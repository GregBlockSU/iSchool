#Week 4 Lab Price 
# Step 0 - Reset R Studio
rm(list = ls()) # remove variables
graphics.off() # clear graphs


#Turn off Scientific notation
options(scipen = 50)
#------------------------------------------------------

# Step 0 - Load Week4Data
getwd()
file_path = "C:/repos/iSchool/BUA-345-BusinessAnalytics/Week-04"
file_name <- "Week4Data.RData"

full_path <- file.path(file_path, file_name)
load(full_path )

# Step 1 - Load and install package
if (!requireNamespace("ggiraphExtra", quietly = TRUE)) {
  install.packages("ggiraphExtra")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
library(ggiraphExtra)
library(ggplot2)

# Step 2 - Exploratory Data Analysis - Open Data Frame RIHANA (Not sure why 
# named that?)

# Identify data elements by Name and describe type 
head(RIHANNA)

# CUT           WEIGHT PRICE
# 1 very good   0.28   433
# 2 excellent   0.44  1982
# 3 excellent   0.52  3323
# 4     ideal   1.32 10685
# 5 excellent   1.36  7800
# 6 very good   0.52  1981

# Structure and summary
str(RIHANNA)

summary(RIHANNA)

# CUT         WEIGHT          PRICE      
# excellent:50   Min.   :0.250   Min.   :  433  
# ideal    :50   1st Qu.:0.585   1st Qu.: 3052  
# very good:50   Median :0.875   Median : 4554  
# Mean   :0.854   Mean   : 5077  
# 3rd Qu.:1.117   3rd Qu.: 6778  
# Max.   :1.400   Max.   :10914

# Step 3 - Identify Dependent and Independent variables for Linear model if we want to predict price

# Y = PRICE
# X = CUT, WEIGHT

# Distribution of cut with absolute values
table(RIHANNA$CUT)

# excellent ideal very good 
# 50        50    50

# Distribution of cut with proportions
prop.table(table(RIHANNA$CUT))

# excellent     ideal very good 
# 0.3333333 0.3333333 0.3333333


# Price distribution
ggplot(RIHANNA, aes(x = PRICE)) +
  geom_histogram(bins = 50, fill = "steelblue", color = "white") +
  labs(title = "Histogram of Price")

# the histogram shows a trimodal distribution, peaking
# around 3K, 6K and 9K

# Carat distribution
ggplot(RIHANNA, aes(x = WEIGHT)) +
  geom_histogram(bins = 50, fill = "darkorange", color = "white") +
  labs(title = "Histogram of Weight")

# the histogram shows a bimodal distribution, peaking
# around 0.5 and 1.0

# Scatter: PRICE vs WEIGHT, colored by CUT
ggplot(RIHANNA, aes(x = WEIGHT, y = PRICE, color = CUT)) +
  geom_point(alpha = 0.4) +
  labs(title = "PRICE vs WEIGHT by CUT")

# scatterplot shows a linear relationship for WEIGHT * CUT to PRICE

# Step 4 - Construct and run multiple regression model 
pricemodel <- lm(PRICE ~ WEIGHT + CUT, data=RIHANNA)
summary(pricemodel)

# Residuals:
#   Min       1Q   Median       3Q      Max 
# -1650.72  -461.94   -17.13   481.33  1756.51 
# 
# Coefficients:
#   Estimate Std. Error t value            Pr(>|t|)    
# (Intercept)    -317.8      179.1  -1.774              0.0781 .  
# WEIGHT         6257.5      179.2  34.913 <0.0000000000000002 ***
#   CUTideal       1782.2      140.4  12.698 <0.0000000000000002 ***
#   CUTvery good  -1630.2      140.4 -11.611 <0.0000000000000002 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 701.3 on 146 degrees of freedom
# Multiple R-squared:  0.925,	Adjusted R-squared:  0.9235 
# F-statistic: 600.7 on 3 and 146 DF,  p-value: < 0.00000000000000022

# Step 5 - Identify intercept and coefficients for each CUT
# Which cut of Diamonds the model select?
# How do you know ?

# The model chose “excellent” as the baseline (reference) category.
# 
# Here’s how you can tell:
#   
#   How R encodes categorical predictors in lm()
# For a factor with 3 levels:
#   
#   Code
# ideal
# excellent
# very good
# R automatically picks one level as the reference and creates dummy variables for the others.
# The reference category is the one not shown in the coefficient table.

# Step 6 - Use ggPredict command to visualize model. Set interactive to TRUE 
ggPredict(pricemodel, interactive = TRUE)


# Step 7 - Answer the following questions
# How many different regression lines do we see?

# 3

# Why is there more than one ?

# one for each category member in the CUT category, 
# excellent, ideal, very good
# What do they each represent? 

# the linear relationship between WEIGHT and PRICE for each CUT

# Step 8 - How do we predict the price for a given cut?

# Hint (Week 2 filtering and Week 3 Predict command for a specific cut )

# Create new Data Frame and lm for Cut = Excellent
cut_excellent <- Diamonds[RIHANNA$CUT == "excellent", ]

head(cut_excellent)

#     CUT       WEIGHT PRICE
# 2  excellent   0.44  1982
# 3  excellent   0.52  3323
# 5  excellent   1.36  7800
# 7  excellent   0.44  1979
# 9  excellent   1.10  6399
# 11 excellent   0.78  4152

excellent <- lm(PRICE ~ WEIGHT, data=cut_excellent)

summary(excellent)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -767.09 -279.61   16.72  260.73  584.12 
# 
# Coefficients:
#   Estimate Std. Error t value             Pr(>|t|)    
# (Intercept)   -506.5      140.8  -3.598             0.000758 ***
#   WEIGHT        6484.2      157.8  41.101 < 0.0000000000000002 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 359.6 on 48 degrees of freedom
# Multiple R-squared:  0.9724,	Adjusted R-squared:  0.9718 
# F-statistic:  1689 on 1 and 48 DF,  p-value: < 0.00000000000000022

# PREDICT Price for cut = Excellent and weight = .75 Carats
predict_excellent_df <- data.frame(WEIGHT=c(.75))

#use the fitted model to predict the rating for the new player
predicted_price_excellent <- predict(excellent, newdata=predict_excellent_df)
predicted_price_excellent

# 4356.655

# PREDICT Price for cut = Excellent and weight = .75 Carats
predict_excellent_df2 <- data.frame(WEIGHT=c(1.5))

#use the fitted model to predict the rating for the new player
predicted_price_excellent2 <- predict(excellent, newdata=predict_excellent_df2)
predicted_price_excellent2

# 9219.839
