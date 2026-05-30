# Homework 8
# Run these three functions to get a clean test of homework code
# dev.off() # Clear the graph window
cat('\014')  # Clear the console
rm(list=ls()) # Clear user objects from the environment

# Set working directory 
# setwd("E:\\Documents\\OneDrive - Syracuse University\\Courses\\2020-06-24 IST 772 Quantitative Reasoning\\Homework\\Week 8") 

library(BayesFactor)
library(car)


# Exercise 1
# Create a new dataframe from the mtcars dataset
myCars <- data.frame(mtcars[,1:6])
View(myCars)

# Exercise 2
# Interpret a correlation matrix of myCars
cor(myCars)

plot(myCars$wt, myCars$mpg, main="Scatterplot of Weight to MPG"
     , xlab="weight (lbs 000s)", ylab="mpg", pch=21, bg="green", col="darkgreen")

plot(myCars$cyl, myCars$mpg, main="Scatterplot of Cylinders to MPG"
     , xlab="cylinders", ylab="mpg",  pch=21, col="brown", bg="orange")

plot(myCars$disp, myCars$mpg, main="Scatterplot of Displacement to MPG"
     , xlab="displacement (cu.in.)", ylab="mpg", pch=21, col="darkblue", bg="skyblue")

# The correlation matrix shows three variables, cylinder count, weight, and
# engine displacement, with high correlation to mileage (mpg). Scatterplots
# visually confirm these relationships. Cylinder counts are restricted to 4,6,
# and 8, but the groups show a noticeable drop in mpg as the cylinder counts
# increase. Of the three, weight has the highest correlation at -0.8677.

# Exercise 3
# Create a multiple linear regression model and interpret the results. 
mod <- lm(mpg ~ wt + hp, myCars)
summary(mod)

# Call:
#   lm(formula = mpg ~ wt + hp, data = myCars)
# 
# Residuals:
#   Min     1Q Median     3Q    Max 
# -3.941 -1.600 -0.182  1.050  5.854 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 37.22727    1.59879  23.285  < 2e-16 ***
#   wt          -3.87783    0.63273  -6.129 1.12e-06 ***
#   hp          -0.03177    0.00903  -3.519  0.00145 ** 
#   ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Residual standard error: 2.593 on 29 degrees of freedom
# Multiple R-squared:  0.8268,	Adjusted R-squared:  0.8148 
# F-statistic: 69.21 on 2 and 29 DF,  p-value: 9.109e-12


# The F-statistic for the model is 69.21 with a p-value of 9.109e-12. The
# p-value is well below our standard alpha value of 0.05, there is a
# relationship between mpg and the weight and hp variables. The intercept of
# 37.2273 has a t value of 23.285 and a near 0 p-value. Use of the intercept is
# supported in our equation. The weight coefficient of -3.8778 per increase of
# 1000 lbs. has a t-value of -6.129 and a p-value of 1.12e-06, a p-value well
# below our alpha of 0.05. Use of the coefficient in our equation is supported.
# The horsepower coefficient of -.0318 has t value of -3.519 and a p-value of
# 0.0015, again well below the 0.05 alpha. Use of the coefficient in our
# equation is supported. When comparing the size of the coefficients, note that
# weight coefficient is for increases of 1,000 and the horsepower coefficient is
# for increases of 1.


# Exercise 4
# Construct a prediction equation and predict mpg with new values. 
# mpg <- 37.22727 - 3.87783(wt) - 0.03177(hp)
new_mpg <- 37.22727 - 3.87783 * 6 - 0.03177 * 110
print(new_mpg)

# [1] 10.46559

# The design team is cautioning against the feasibility of building a 3-ton
# (6,000 lbs.) car with a 110-horsepower engine. Not only will it get
# substandard mileage, but it will likely not be able to move as it combines a
# car the size of a Cadillac Fleetwood with an engine the size of a Datsun 710.

# Exercise 5
# Generate a BayesFactor from a Bayesian lm on the same variables
mpgOut <- lmBF(mpg ~ wt + hp, data=myCars,posterior=F)
summary(mpgOut)

# Bayes factor analysis
# --------------
#   [1] wt + hp : 788547604 ±0%
# 
# Against denominator:
#   Intercept only 
# ---
#   Bayes factor type: BFlinearModel, JZS

# The Bayes Factor generated when creating a Bayesian linear model of the
# relationship between mileage and the variables weight and horsepower is
# 7.88e+8. As this represents the odds in favor of the alternate hypothesis,
# there is strong evidence to reject the null hypothesis that there is no
# relationship between mileage and the variables. This supports that there is a
# relationship between mileage and the variables weight and horsepower. This
# finding lines up with the high correlation found between these same dependent
# and independent variables and the frequentist linear model with a p-value
# significantly below the 0.05 alpha selected. Exercise 6 Generate posterior
# probabilities from a Bayesian lm on the same variables

mpgOut2 <- lmBF(mpg ~ wt + hp, data=myCars,posterior=T, iterations=10000)
summary(mpgOut2)

# Iterations = 1:10000
# Thinning interval = 1 
# Number of chains = 1 
# Sample size per chain = 10000 
# 
# 1. Empirical mean and standard deviation for each variable,
# plus standard error of the mean:
#   
#   Mean        SD  Naive SE Time-series SE
# mu   20.08681  0.477741 4.777e-03      4.777e-03
# wt   -3.79650  0.662104 6.621e-03      6.584e-03
# hp   -0.03098  0.009366 9.366e-05      9.512e-05
# sig2  7.44124  2.119318 2.119e-02      2.519e-02
# g     3.98533 13.287552 1.329e-01      1.350e-01
# 
# 2. Quantiles for each variable:
#   
#   2.5%      25%      50%      75%    97.5%
# mu   19.13812 19.76662 20.08833 20.40274 21.03522
# wt   -5.07691 -4.23642 -3.80059 -3.35968 -2.47159
# hp   -0.04915 -0.03712 -0.03117 -0.02484 -0.01215
# sig2  4.36322  5.92083  7.09883  8.56700 12.42731
# g     0.37092  0.95845  1.74123  3.49729 19.62846

# The posterior distributions from the Bayesian linear model creation were both
# significant in that there was a 95% probability that neither included 0. The
# HDI for weight ranged from -5.1204 to -2.4565 with a median of -3.7942. The
# HDI for horsepower ranged from -0.0499 to -0.0118 with a median of -0.0310.
# There is sufficient support to reject the null hypothesis of there being no
# relationship between the dependent and independent variables. Exercise 8
# Generate VIF values for the original linear model and a new model that
# includes all variables.

# Exercise 7

vif(mod)

# wt       hp 
# 1.766625 1.766625 

# The variance inflation factor, or VIF, is useful for identifying covariance
# between independent variables in a linear model. It measures how much variance
# is inflated due to collinearity. As a rule, a VIF of 1 shows no collinearity,
# 1-5 shows some collinearity, and greater than 5 significant collinearity.

mod2 <- lm(mpg ~ ., myCars)
vif(mod2)

# cyl      disp        hp      drat        wt 
# 7.869010 10.463957  3.990380  2.662298  5.168795

# The original linear model (mpg ~ wt + hp) generated the same VIF for both
# variables. This makes sense because each variable would affect the other
# variable the same. When the model was rerun to include all variables (mpg ~
# .), it showed collinearity between independent variables with 3 crossing the 5
# threshold (significant collinearity). A reasonable set of next steps would be
# to try pairs of independent variables separately and remove those that are
# highly correlated to another independent variable. The target is to create a
# model with the lowest p-value for the f-value where all coefficients generated
# are also significant.