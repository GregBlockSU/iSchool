# Homework 5, exercises 6, 7, 9 & 10

#Exercise 6
data("PlantGrowth")
ctrl.weights = PlantGrowth$weight[PlantGrowth$group == 'ctrl']
trt1.weights = PlantGrowth$weight[PlantGrowth$group == 'trt1']
trt2.weights = PlantGrowth$weight[PlantGrowth$group == 'trt2']

# Perform a t-test between TRT1 and the control group.
t.test(ctrl.weights,trt1.weights)

# data:  ctrl.weights and trt1.weights
# t = 1.1913, df = 16.524, p-value = 0.2504
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -0.2875162  1.0295162
# sample estimates:
#   mean of x mean of y 
# 5.032     4.661 

# The reported value t is 1.1913, the degrees of freedom is 16.524 and the p-value is 
# 0.2504. The confidence interval is -0.2875162 to 1.0295162. With an alpha of .05 and 
# a p-value of 0.2504, we would fail to reject the null hypothesis. 

# Exercise 7
# Run a mcmc simulation with the control group and treatment group weights.
library(rjags)
library(BEST)
PGBest <- BESTmcmc(ctrl.weights,trt1.weights)
plot(PGBest, main=NULL)

# The boundary values for the 95% HDI are -0.352 and 1.16. The HDI, or highest 
# density interval, shows, with a probability of 95%, where the population value will fall.

# Exercise 8
# Explain the findings from the null hypothesis test, the confidence interval, and the HDI.
# In the null hypothesis test, there is a 25% chance (p-value of 0.2504) that the t-value will occur. 
# This is not a rare enough condition to reject the null hypothesis so 
# we would fail to reject the null hypothesis. The confidence interval is -0.2875 to 1.0295 
# which may contain the population value. If the test is run 100 times, 
# on average, 95 of those would contain the value and 5 would not. The current 
# confidence interval spans 0, which leaves a reasonable probability that the difference 
# between the two groups is also zero. In the HDI results, the 95% HDI 
# is -0.352 and 1.16, also spanning zero. Although most occurrences were near the mean of .386, 
# there is a possibility that the population value could be zero. In all three cases, 
# there is reasonable probability that there is no difference between the mean value of the two groups.

#Exercise 9
# Perform a t-test between TRT2 and the control group.
t.test(ctrl.weights,trt2.weights)

# data:  ctrl.weights and trt2.weights
# t = -2.134, df = 16.786, p-value = 0.0479
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -0.98287213 -0.00512787
# sample estimates:
#   mean of x mean of y 
# 5.032     5.526

PGBest2 <- BESTmcmc(ctrl.weights,trt2.weights)
plot(PGBest2, main=NULL)

# The same tests between the control group and the TRT2 group. For the null hypothesis test, 
# the p-value was 0.0479. This suggests the null hypotheses should be rejected, but it is 
# close to alpha of .05. The confidence interval is -0.9829 to -0.0051. It does not span zero, 
# but if the test is run 100 times, on average 5 confidence intervals do not contain the 
# population value. There is a chance that other confidence intervals may contain zero. 
# There 95% HDI also spans zero, also suggesting a probability that zero is the value, 
# though 95.9% of all simulated values fall below zero. Most observations are near -.488, 
# the observation mean. Although reasonable to suggest the results are significant, 
# they near the edge of that suggestion. We will run the experiment again with larger samples, 
# reducing the confidence interval range and providing more a stronger case the findings are 
# significant.

#Exercise 10
# Examine the results of running a t-test on a very large sample size.
set.seed(1234)
t.test(rnorm(100000,mean=17.1,sd=3.8),rnorm(100000,mean=17.2,sd=3.8))

# data:  rnorm(1e+05, mean = 17.1, sd = 3.8) and rnorm(1e+05, mean = 17.2, sd = 3.8)
# t = -5.9629, df = 199994, p-value = 2.483e-09
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   -0.13427906 -0.06784225
# sample estimates:
#   mean of x mean of y 
# 17.11113  17.21219

# When using large sample sizes, even small differences between the groups will be
# detected as significant. In this experiment, the p-value was near zero. 
# The confidence interval was -0.1342 to -0.067, a span that includes the known difference 
# of .1. If the means were unknown, it would be reasonable to state that the means 
# between the two groups is different and there is a reasonable probability that the 
# population value falls within the confidence interval.