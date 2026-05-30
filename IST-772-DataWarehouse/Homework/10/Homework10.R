# Homework 10
# dev.off() # Clear the graph window
cat('\014')  # Clear the console
rm(list=ls()) # Clear user objects from the environment


# install.packages("nlme")
# install.packages("car")
library(nlme)
library(car)

# -------- Question 2 --------
# Download and library the nlme package and use data ("Blackmore") to
# activate the Blackmore data set. Inspect the data and create a box plot
# showing the exercise level at different ages. Run a repeated measures ANOVA to
# compare exercise levels at ages 8, 10, and 12 using aov(). You can use a
# command like, myData <- Blackmore[Blackmore$age <=12,], to subset the data.
# Keeping in mind that the data will need to be balanced before you can conduct
# this analysis, try running a command like this,
# table(myDatasubject,myDataage)), as the starting point for cleaning up the
# data set.



data("Blackmore")

# Explore the data
summary(Blackmore)

# subject         age           exercise          group    
# 100    :  5   Min.   : 8.00   Min.   : 0.000   control:359  
# 101    :  5   1st Qu.:10.00   1st Qu.: 0.400   patient:586  
# 105    :  5   Median :12.00   Median : 1.330                
# 106    :  5   Mean   :11.44   Mean   : 2.531                
# 107    :  5   3rd Qu.:14.00   3rd Qu.: 3.040                
# 108    :  5   Max.   :17.92   Max.   :29.960 

View(Blackmore)

# Round down to just the integer age
Blackmore$age = round(Blackmore$age)

# Create a plot of exercise by age
boxplot( exercise ~ age, data=Blackmore, 
         main="Blackmore Study - Exercise by Age", 
         xlab="age", col="seagreen3")

# Filter down to just the study group
black_filtered <- Blackmore[Blackmore$age <= 12,]
black_filtered$age <- factor(black_filtered$age)

table(black_filtered$subject, black_filtered$age)

#      8 10 12
# 100  1  1  1
# 101  1  1  1
# 102  1  1  1
# 103  1  1  1
# 104  1  1  1
# 105  1  1  1
# 106  1  1  1
# 107  1  1  1
# (elided)

# Balance the samples
list <- rowSums(table(black_filtered$subject, black_filtered$age))==3
list <- list[list==TRUE]
list <- factor(names(list))
black_filtered <- black_filtered[black_filtered$subject %in% list,]
table(black_filtered$age)

#   8  10  12 
# 187 187 187

summary(aov(exercise ~ age + Error(subject), data=black_filtered))

# Error: subject
# Df Sum Sq Mean Sq F value Pr(>F)
# Residuals 186   1979   10.64               
# 
# Error: Within
#            Df Sum Sq Mean Sq F value   Pr(>F)    
# age         2  102.1   51.04   28.23 3.87e-12 ***
# Residuals 372  672.7    1.81                     
# ---
#         Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# In the model we are testing the hypothesis that exercise does not vary over
# age. In the Error Within section, the effect of age is expressed as an
# F-ratio, F(2,372)=28.23, and a p-value of 3.87e-12 ***. Since the low p-value
# is below the threshold of significance, we can reject the null hypothesis and
# give support to the alternative hypothesis that the exercise level of kids do
# vary across different ages.

# -------- Exercise 5 --------
# Given that the AirPassengers data set has a substantial growth trend, use
# diff() to create a differenced data set. Use plot() to examine and interpret
# the results of differencing. Use cpt.var() to find the change point in the
# variability of the differenced time series. Plot the result and describe in
# your own words what the change point signifies.

# install.packages("changepoint")
library(changepoint)

data("AirPassengers")
# Create a differenced data set of air passengers

diff_air <- diff(AirPassengers)

# Plot the differences
plot(diff_air,
     main="Difference in Air Passenger Counts over Time",
     ylab = "Passenger Count Change")

# Use changepoint var to find a change point in variance
varAir <- cpt.var(diff_air)
varAir

# Class 'cpt' : Changepoint Object
# ~~   : S4 class containing 12 slots with names
# cpttype date version data.set method test.stat pen.type pen.value minseglen cpts ncpts.max param.est 
# 
# Created on  : Sat Jun 27 20:48:36 2020 
# 
# summary(.)  :
#         ----------
#         Created Using changepoint version 2.2.2 
# Changepoint type      : Change in variance 
# Method of analysis    : AMOC 
# Test Statistic  : Normal 
# Type of penalty       : MBIC with value, 14.88853 
# Minimum Segment Length : 2 
# Maximum no. of cpts   : 1 
# Changepoint Locations : 76

plot(varAir,cpt.col="grey",cpt.width=5, 
     main="Difference in Air Passenger Counts w/ Change Point",
     ylab="Passenger Count Change")

# -----------------------------------------------
# Exercise 6 - Changepoint mean
varMean <- cpt.mean(AirPassengers)
varMean

# Class 'cpt' : Changepoint Object
# ~~   : S4 class containing 12 slots with names
# cpttype date version data.set method test.stat pen.type pen.value minseglen cpts ncpts.max param.est 
# 
# Created on  : Sat Jun 27 20:48:36 2020 
# 
# summary(.)  :
#         ----------
#         Created Using changepoint version 2.2.2 
# Changepoint type      : Change in mean 
# Method of analysis    : AMOC 
# Test Statistic  : Normal 
# Type of penalty       : MBIC with value, 14.90944 
# Minimum Segment Length : 1 
# Maximum no. of cpts   : 1 
# Changepoint Locations : 77

plot(varMean,cpt.col="grey",cpt.width=5, 
     main="Air Passenger Counts w/ Mean Change Point",
     ylab="Passenger Count Change")

# The red line signifies the changepoint. This point is a timepoint of a major
# transition in the data. The changepoint allows us to record the point in time
# when the transition occurred as well as the change in the mean level of the
# time series. In this case, it occurred around 1955.

# -------- Exercise 6 --------
# Use cpt.mean() on the AirPassengers time series. Plot and interpret the
# results. Compare the change point of the mean that you uncovered in this case
# to the change point in the variance that you uncovered in Exercise 5. What do
# these change points suggest about the history of air travel?
# change point in mean

airmean=cpt.mean(AirPassengers)
airmean

# Class 'cpt' : Changepoint Object
# ~~   : S4 class containing 12 slots with names
# cpttype date version data.set method test.stat pen.type pen.value minseglen cpts ncpts.max param.est 
# 
# Created on  : Wed Jun 09 23:06:46 2021 
# 
# summary(.)  :
#         ----------
#         Created Using changepoint version 2.2.2 
# Changepoint type      : Change in mean 
# Method of analysis    : AMOC 
# Test Statistic  : Normal 
# Type of penalty       : MBIC with value, 14.90944 
# Minimum Segment Length : 1 
# Maximum no. of cpts   : 1 
# Changepoint Locations : 77 

plot(airmean, main="Changepoint in Mean for AirPassengers")

airmean2 <- cpt.mean(AirPassengers, class=FALSE)

airmean2["conf.value"]

## conf.value
## 1

# When looking at the change point of mean, we can see that the major shift is
# around the same period as the change point in variance, about 1955. This was a
# period of more passengers traveling and using planes. It probably signifies
# more people were traveling in this post-war period where plane technology got
# better and people possibly had more disposable income to spend.

# -------- Exercise 7 --------
# Find historical information about air travel on the Internet and/or in reference materials that sheds light on
# the results from Exercises 5 and 6. Write a mini-article (less than 250 words) that interprets your statistical
# findings from Exercises 5 and 6 in the context of the historical information you found.

# SOURCE: https://theconversation.com/longing-for-the-golden-age-of-air-travel-be-careful-what-you-wishfor-34177
# 1955 was part of the Golden Age of aviation. Jets were introduced in the late 1950s which allowed passengers
# to travel to even more distance locations at even faster speeds. It opened up air travel for global travel
# anywhere in the world. After this period, planes also got safer and people had less of a reason to be as
# afraid to travel on them. This provides some context behind the changepoint in mean and variance having
# the biggest transition period around 1955.

# -------- Exercise 8 --------
# Use bcp() on the AirPassengers time series. Plot and interpret the results.
# Make sure to contrast these results with those from Exercise 6.

# install.packages("bcp")
library(bcp)

bcpAir <- bcp(as.vector(diff_air)) 
summary(bcpAir)

# Bayesian Change Point (bcp) summary:
#         Probability of a change in mean and posterior means:
#         
#         Probability    X1
# 1         0.016 130.8
# 2         0.014 131.1
# 3         0.016 131.4
# (elided)

plot(bcpAir) 
plot(bcpAir$posterior.prob >.95,
     main="Plot of Air Passenger Posterior Probabilities > 95%",
     ylab="Posterior Probability", col="darkblue") 

# When looking at this Bayesian changepoint analysis, we can see that there is a
# shift in mean and probability at about the 77th location, which is the
# location confirmed in the changepoint of mean analysis. The probability of a
# mean change is much higher at this point and there is a major shift that
# happens.
