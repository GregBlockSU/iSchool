#####################################
# Chapter 1
data()
summary(BOD)
rainfall <- c(0,0,0,2,1,1,4)  # Amount of rain each day this week
sum(rainfall) / length(rainfall)  # Compute the mean the hard way
mean(rainfall) # Use a function to compute the mean

# Only if you did not do this in the Introduction
install.packages("modeest")  # Download the mode estimation package
library(modeest) # Make the package ready to use
mfv(rainfall) # mfv stands for most frequent value  

votes <- c(200,300,400) # Here is scenario one 
(votes - mean(votes)) ^ 2 # Show a list of squared deviations
sum( (votes - mean(votes)) ^ 2) # Add them together
sum( (votes - mean(votes)) ^ 2) / length(votes) # Divide by the number of observations

votes1 <- c(200,300,400) # Here is scenario one again
sqrt( sum((votes1 - mean(votes1))^2) / length(votes1) ) # That is the standard deviation
votes2 <- c(299,300,301) # Here is scenario two
sqrt( sum((votes2 - mean(votes2))^2) / length(votes2) ) # And the same for candidate 2

# The commented code makes a high res plot when run in R
#png("Figure01_1.png", width = 6, height = 6, units = 'in', res = 300)
hist( rnorm(n=1000, mean=100, sd=10), main=NULL )
#dev.off()

# This shows a finer-grained histogram with 100 categories or “breaks”
# Try increasing the n and the breaks to see what happens
hist( rnorm(n=10000, mean=100, sd=10), breaks=100 )

#png("Figure01_2.png", width = 6, height = 6, units = 'in', res = 300)
hist(rpois(n=1000, lambda=1), main=NULL)
#dev.off()

mean(rpois(n=1000, lambda=1))

myPoiSample <- rpois(n=1000, lambda=1)
mean(myPoiSample)
hist(myPoiSample)

