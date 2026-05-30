# Homework number: 6
# Run these three functions to get a clean test of homework code
# dev.off() # Clear the graph window
cat('\014')  # Clear the console
rm(list=ls()) # Clear user objects from the environment

# install.packages("rjags")

# Load the insect sprays built-in dataset.
data("InsectSprays")

# Problem 1. dependent variable: count (of insects killed); independent variable: type of spray
# total observations: 72
# Print summary statistics
summary(InsectSprays)
str(InsectSprays)
dim(InsectSprays)
table(InsectSprays)

# Problem 2. Perform ANOVA on insect sprays
aovSpraysOut <- aov(count ~ spray, data = InsectSprays)
summary(aovSpraysOut)

#               Df Sum Sq Mean Sq F value Pr(>F)    
#  spray         5   2669   533.8    34.7 <2e-16 ***
#   Residuals   66   1015    15.4                   
# ---
#  Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# In the result output above the spray Mean Sq of 533.8 represents the variance between groups. 
# The Residuals variance of 15.4 represents within groups. In this result the between groups 
# demonstrates the spread of the means in the data while the within groups is based on variance 
# in each of the data elements or raw data. The Pr amount tells you this is significant 
# and that there is variation between entities, so you would reject the null hypothesis

# Problem 3
# The F-ratio is calculated by creating a ration of mean squares from the two groups 
# in the ANOVA output. In this case it would be: 533.8/15.4 = 34.6633377 so the F-ratio 
# is 34.663 The F-ratio here indicates a few things: First, it is greater than 1.0 so it 
# is significant. Second the Pr value is less than any alpha level which also tells me this is significant. 

# Problem 4
# the degrees of freedom within groups is 66 and the degrees of freedom between groups is 5
# This means that out of a set of 72 observations, we will lose one degree for the grand mean of 
# the dataset. The remainder are split between those free to vary one the initial set of 
# statistics have been calculated with the rest being the residuals and representing degrees of 
# freedom within the groups. Adding these together brings us back to 71
# observations and missing the one given for the grand mean from the original 72 observations.

# Problem 5
# In this experiment we are considering the use of 6 different insect sprays on samples of 
# 12 different groups of insects for a total of 72 observations based on a independent variable 
# of one of six sprays and a dependent variable of the count of insects killed. 
# We begin with a hypothesis that there is no difference between sprays. Our alternative 
# hypothesis is that there is a difference. We run an ANOVA test and the results are shown above. 
# We can see differences between the mean squares which are made more clear as we calculate the 
# F-Value significantly above 1.0. The Pr value being below the alpha level means that the 
# result of the test is significant and thus there is a difference between groups. 
# This suggests the alternative hypothesis has support and we should reject the null hypothesis.

# Problem 6. Perform bayes factor analysis on the insect sprays dataset
# install.packages("BayesFactor")
# install.packages("BEST")
library("BayesFactor")
library("BEST")
spraysBayesOut <- anovaBF(count ~ spray, data=InsectSprays)
spraysBayesOut
# Generate posterior probabilities
spraysMCMCOut <- posterior(spraysBayesOut,iterations=10000)
summary(spraysMCMCOut)

# 1. Empirical mean and standard deviation for each variable,
# plus standard error of the mean:
#   
#   Mean     SD Naive SE Time-series SE
# mu       9.506 0.4683 0.004683       0.004683
# spray-A  4.802 1.0407 0.010407       0.010407
# spray-B  5.617 1.0431 0.010431       0.010676
# spray-C -7.157 1.0567 0.010567       0.010718
# spray-D -4.411 1.0358 0.010358       0.010358
# spray-E -5.774 1.0291 0.010291       0.010479
# spray-F  6.923 1.0592 0.010592       0.010815
# sig2    16.080 2.8939 0.028939       0.034385
# g_spray  3.467 3.2533 0.032533       0.032858
# 
# 2. Quantiles for each variable:
#   
#   2.5%    25%    50%    75%  97.5%
# mu       8.583  9.194  9.505  9.820 10.418
# spray-A  2.765  4.122  4.811  5.497  6.872
# spray-B  3.539  4.925  5.608  6.316  7.681
# spray-C -9.225 -7.849 -7.168 -6.444 -5.106
# spray-D -6.392 -5.111 -4.427 -3.717 -2.350
# spray-E -7.831 -6.467 -5.783 -5.085 -3.749
# spray-F  4.858  6.205  6.921  7.627  9.002
# sig2    11.360 14.011 15.759 17.786 22.553
# g_spray  0.827  1.687  2.570  4.084 11.487
plot(spraysMCMCOut[,"mu"], main=NULL)
boxplot(as.matrix(spraysMCMCOut[,2:7]))
#  Display of HDIs. You can see the in the graph below and also in the outputs above 
# The lower bound is 8.5 and the upper bound is 10.4

# The boxplot above shows deviations from the grand mean in the form of 
# posterior distributions. The separation above and below zero and the non-overlap 
# clearly shows difference. Given a null hypothesis of no difference and an 
# alternative hypothesis of difference this suggests a direction. This separation 
# is demonstrated above in the quartiles between spray A,B,F vs. the others. 
# This is also demonstrated in the Bayes Factor Analysis which is above 1.0 thus
# suggesting a rejection of the null hypothesis. The separation above and below zero 
# and the non-overlap clearly also reflects difference. Thus a rejection of the null is appropriate.

# Problem 7. Perform a Bayesian t-test between spray-C and spray-F

CandF_obs <- InsectSprays[InsectSprays$spray=="C" | InsectSprays$spray=="F",]
sprayC_obs <- InsectSprays[InsectSprays$spray=="C",1]
sprayF_obs <- InsectSprays[InsectSprays$spray=="F",1]
obs <-data.frame("C" = sprayC_obs, ".F" = sprayF_obs)

# Performa a Bayes t-test against just the C and F sprays.
plot(BESTmcmc(InsectSprays[InsectSprays$spray=="C",1],
              InsectSprays[InsectSprays$spray=="F",1]))
spray_BFOut <- anovaBF(count ~ spray, data=CandF_obs)
summary(spray_BFOut)
# We can see from the test results that the entire distribution is below 0. This
# indicates, as we have seen before, that spray F performs much better than spray
# C. The most likely mean difference being -14.5 worst with a 95% chance of the 
# mean difference being between -19 and -10.