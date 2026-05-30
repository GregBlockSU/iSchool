# Answer code for ANOVA analysis of insurance data
# The insurance.csv dataset contains 1338 observations (rows) and 7 features (columns). 
# The dataset contains 4 numerical features (age, bmi, children and medical expenses) and 
# 3 nominal features (sex, smoker and region).
# A simulated data set by Brett Lantz.


######################
# Breakout 1

aovOut <- aov(weight ~ group, data=PlantGrowth)
aovOut
tuk <- TukeyHSD(aovOut)
plot(tuk)


# Set to where your data live
setwd('C:/Users/HQRGRS27/OneDrive/Courses/Syracuse/2020/03-Summer/772/WeekByWeekLive/Week 06')
getwd()
library(readr)
# Change the filename as needed
insurance <- read_csv("dWeek6insurance.csv")

boxplot(charges ~ region,data=insurance, horizontal = TRUE)

# Get group means and SDs
tapply(insurance$charges,insurance$region,mean)
tapply(insurance$charges,insurance$region,sd)
tapply(insurance$charges,insurance$region,hist)
mean(insurance$charges)

# Conventional ANOVA
aovOut <- aov(charges ~ region, data=insurance)
summary(aovOut)

# Statistically significant at p<.05

# Bayesian ANOVA
library(BayesFactor)
set.seed(1)
insurance$region <- as.factor(insurance$region)
bayesOut <- anovaBF(charges ~ region,data=insurance) # Calc Bayes Factors
mcmcOut <- posterior(bayesOut,iterations=10000)  # Run mcmc iterations

# Box plots are informal methods of comparing HDIs
# Note that these values are relative to the grand mean
boxplot(as.matrix(mcmcOut[,2:5]), main=NULL, horizontal=TRUE)
quantile(mcmcOut[,4], c(0.025,0.975)) # HDI for southeast
quantile(mcmcOut[,5], c(0.025,0.975)) # HDI for southwest
# The HDIs for these two regions do not overlap: Credibly different
summary(mcmcOut)


######################
# Breakout 2

# Calculates the inflation in experimentwise alpha
fwer <- function(alpha, numComp) {
  return(1 - (1 - alpha)^numComp)
}

fwer(0.05, 1) # Test, should be 0.05
fwer(0.05, 2)
fwer(0.05, 3)

# Demonstration: Examined by itself, the t-test of SE vs SW is p<.01
tOut <- t.test(insurance$charges[insurance$region=="southwest"],
       insurance$charges[insurance$region=="southeast"],
       alternative="less")
tOut
p.adjust(p=tOut$p.value, method="holm", n=6 ) # Use the Holm adjustment
# Results still show as significant at p<.05

TukeyHSD(aovOut) # Create a Tukey table
plot(TukeyHSD(aovOut))
# install.packages("emmeans")
library(emmeans)

emOut <- emmeans(aovOut, "region") # Estimate marginal means
plot(emOut)
summary(emOut)


pwpp(emOut) # Show a Tukey plot based on em means results
# Generally speaking, should match the Tukey table
