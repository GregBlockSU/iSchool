# Run these three functions to get a clean test of homework code
#dev.off() # Clear the graph window
cat('\014')  # Clear the console
rm(list=ls()) # Clear user objects from the environment

# Load the data set
data("ChickWeight")

# Generate summary information on the data set
summary(ChickWeight)

# Report the dimensions of the data set
dim(ChickWeight)

? ChickWeight

# Report on a summary of the weight variable. 
summary(ChickWeight$weight)

# Return the first six values of the weight 
# variable in the data set.
head(ChickWeight$weight)

# Return the mean of the weight attribute
mean(ChickWeight$weight)

# Pass the weights to a variable
myChkWts <- ChickWeight$weight

# Return the median weight value 
quantile(myChkWts, 0.5)

# Create a histogram from the weights vector
hist(myChkWts, main="Histogram of Chick Weights"
     , ylab = "frequency"
     , xlab="grams"
     , col="darkgoldenrod3"
     , breaks=20)
abline(v=quantile(myChkWts,c(.025,.975)),col="darkgreen",lwd=2)

# Return quantile values
quantile(myChkWts,c(.025,.50,.975))
mean(myChkWts)

# Create a collection of sample means from the weight attribute. 
samplingDistribution <- replicate(10000,mean(sample(myChkWts,11,replace=T)))

# Display a histogram of the sampling distribution
hist(samplingDistribution, main="Histogram of Chick Weight Sample Means"
     , ylab = "frequency"
     , xlab="average weight (gms)"
     , col="darkslateblue"
     , border = "white"
     , breaks=30)
abline(v=quantile(samplingDistribution,c(.025,.975)),col="red3",lwd=2)

# Return quantile values
quantile(samplingDistribution, c(.025, .975))

# Create a collection of sample means from the weight attribute. 
samplingDistribution2 <- replicate(10000,mean(sample(myChkWts,100,replace=T)))

# Display a histogram of the sampling distribution
hist(samplingDistribution2, main="Histogram of Chick Weight Sample Means (n=100)"
     , ylab = "frequency"
     , xlab="average weight (gms)"
     , col="darkgreen"
     , border = "white"
     , breaks=30)
abline(v=quantile(samplingDistribution2,c(.025,.975)),col="darkorange",lwd=2)

# Return quantile values
quantile(samplingDistribution2, c(.025, .975))


# Create a collection of sample means from the weight attribute. 
samplingDistribution2 <- replicate(10000,mean(sample(myChkWts,578,replace=T)))

# Display a histogram of the sampling distribution
hist(samplingDistribution2, main="Histogram of Chick Weight Sample Means (n=578)"
     , ylab = "frequency"
     , xlab="average weight (gms)"
     , col="dodgerblue4"
     , border = "white"
     , breaks=30)
abline(v=quantile(samplingDistribution2,c(.025,.975)),col="orangered3",lwd=2)

# Return quantile values
quantile(samplingDistribution2, c(.025, .975))












