
# breakout #2

set.seed(1234) 			      # Control randomization
testPop <- rnorm(100000, mean=100, sd=10) # Create simulated pop

# Custom function to pull one sample
sampleTestScores <- function(n){sample(testPop,size=n,replace=TRUE)}

samplingDistribution <- replicate(1000, mean(sampleTestScores(100)))

# par(mfrow=c(2,1))
hist(testPop, xlim=c(50,140))
hist(samplingDistribution, xlim=c(50,140))
par(mfrow=c(1,1))


# Case Study A
hist(samplingDistribution)
abline(v=quantile(samplingDistribution,prob=0.025))
abline(v=quantile(samplingDistribution,prob=0.975))
abline(v=101, col="red")

# Case Study B
samplingDistribution <- replicate(1000, mean(sampleTestScores(49)))
hist(samplingDistribution)
abline(v=quantile(samplingDistribution,prob=0.025))
abline(v=quantile(samplingDistribution,prob=0.975))
abline(v=104, col="red")

# Case Study C
samplingDistribution <- replicate(1000, mean(sampleTestScores(500)))
hist(samplingDistribution)
abline(v=quantile(samplingDistribution,prob=0.025))
abline(v=quantile(samplingDistribution,prob=0.975))
abline(v=101, col="red")

# Case Study D
testPop <- rnorm(100000, mean=50, sd=5) # Create simulated pop
samplingDistribution <- replicate(1000, mean(sampleTestScores(64)))
hist(samplingDistribution)
abline(v=quantile(samplingDistribution,prob=0.025))
abline(v=quantile(samplingDistribution,prob=0.975))
abline(v=48, col="red")

# Case Study E
samplingDistribution <- replicate(1000, (mean(sampleTestScores(36))-mean(sampleTestScores(36))))
hist(samplingDistribution)
abline(v=quantile(samplingDistribution,prob=0.025))
abline(v=quantile(samplingDistribution,prob=0.975))
abline(v=3, col="red")


# Supplemental code from slides

sdVector <- NULL # Start a list with nothing
sampSizes <- (2:100)^2 # A list of 9 sample sizes ranging from 4 to 100

for (i in sampSizes) 
{
  # Do a sampling distribution for each sample size
  samplingDistribution <- replicate(1000, mean(sampleTestScores(i)))
  
  # Add the standard deviation of that sampling distribution to the list
  sdVector <- c(sdVector, sd(samplingDistribution))
}
plot(sampSizes, sdVector)

