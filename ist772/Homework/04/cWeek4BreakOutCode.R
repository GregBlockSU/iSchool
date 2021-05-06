# Week 4 instructor code

#########################
# Analyses and graphics for introductory slides
sampSize <- 100 # Set sample size
set.seed(11) # Control randomization

groupA <- rnorm(n=sampSize/2) # Generate one sample
groupB <- rnorm(n=sampSize/2) + 0.2 # Generate a second sample that has an effect of 0.2
tout <- t.test(groupA, groupB) # Run a t-test
tout$conf.int[1:2] # Report just the CI for showing to the class

# Now let's have a function that reports TRUE if
# both ends of the CI are below zero; remember that the because
# Group B mean should be larger than Group A mean, we are
# looking for a significant negative difference
rerunT <- function() {
  groupA <- rnorm(n=sampSize/2)
  groupB <- rnorm(n=sampSize/2) + 0.2
  
  tout <- t.test(groupA, groupB)
  (tout$conf.int[1] < 0) && (tout$conf.int[2] < 0)
}

# Create a table showing how many times we passed the test
table(replicate(n=10000,expr=rerunT()))
# Results show a 16.45% correct rate

#install.packages("pwr")
library(pwr) # Do power analysis
pwr.t.test(n=(sampSize/2), d=0.2, type="two.sample") # What's the power to detect d=0.2?



# Here's a function to create a single mean difference
meanDiffs <- function() {
  groupA <- rnorm(n=sampSize/2)
  groupB <- rnorm(n=sampSize/2) + 0.2
  mean(groupA) - mean(groupB)
}

# Show a histogram of the sampling distribution
hist(replicate(n=10000,expr=meanDiffs()))

# Run 100 t-tests and plot a CI for each one
df <- data.frame(Run = 1:100, U = 0, M = 0, L = 0)

for (i in 1:100) {
  groupA <- rnorm(n=sampSize*100/2) # Sample one group
  groupB <- rnorm(n=sampSize*100/2) + 0.2 # Sample a second group with d=0.2
  tout <- t.test(groupA, groupB) # Run the t-test
  df$L[i] <- tout$conf.int[1] # Lower limit of CI
  df$U[i] <- tout$conf.int[2] # Upper limit of CI
  df$M[i] <- mean(tout$conf.int) # Middle of CI
}

# Create a plot: How many overlap with 0?
# How many overlap with 
require("ggplot2")
ggplot(df, aes(x = Run, y = M)) +
  geom_point(size = 1) +
  geom_errorbar(aes(ymax = U, ymin = L), width=0.15) +
  geom_hline(col="red", yintercept = 0) +
  geom_hline(col="green", yintercept = -0.2)



#########################
# First breakout
# 
setwd("C:/Users/HQRGRS27/OneDrive/Courses/Syracuse/2020/03-Summer/772/WeekByWeekLive/WeekByWeekLive/Week4")

library(readr)
battData <- read_csv("bBatterydata.csv")
str(battData)
summary(battData)
hist(battData$Time[battData$Battery==1])
hist(battData$Time[battData$Battery==2])

boxplot(Time ~ Battery, data=battData, ylim=c(min(battData$Time)-50,max(battData$Time)+50))

tapply(X=battData$Time,INDEX=battData$Battery,FUN=mean)
tapply(X=battData$Time,INDEX=battData$Battery,FUN=sd)

t.test(Time ~ Battery, data=battData)

#########################
# Second breakout

library(readr)
cBattPop <- read_csv("cBattPop.csv")

popMeanDiff <- aggregate(Time ~ Battery, cBattPop, mean)[1,2] -
  aggregate(Time ~ Battery, cBattPop, mean)[2,2]

# Or. . .
tapply(X=cBattPop$Time,INDEX=cBattPop$Battery,FUN=mean)[1] -
  tapply(X=cBattPop$Time,INDEX=cBattPop$Battery,FUN=mean)[2]
  
replBattCI <- function()
{
  mySamp <- cBattPop[sample(1:100000,size=172, replace=TRUE), ]
  nicad <- mySamp$Time[mySamp$Battery==1]
  liion <- mySamp$Time[mySamp$Battery==2]
  return(t.test(nicad,liion)$conf.int)
} 

confIntList <- t(replicate(100,replBattCI()))

plot.ts(confIntList[,1],col="red", ylim=c(-45,-5), xlab="Replications", ylab="CIs Around Mean Diff")

lines(confIntList[,2], col="green")

abline(h=popMeanDiff)
