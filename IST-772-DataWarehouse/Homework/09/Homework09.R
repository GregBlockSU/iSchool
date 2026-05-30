# Homework number: 9
# Run these three functions to get a clean test of homework code
# dev.off() # Clear the graph window
cat('\014')  # Clear the console
rm(list=ls()) # Clear user objects from the environment

# ------------------------------------------
# Exercise #1
# The built-in data sets of R include one called "mtcars," which stands for
# Motor Trend cars. Motor Trend was the name of an automotive magazine and this
# data set contains information on cars from the 1970s. Use "?mtcars" to display
# help about the data set. The data set includes a dichotomous variable called
# vs, which is coded as 0 for an engine with cylinders in a v-shape and 1 for so
# called "straight" engines. Use logistic regression to predict vs, using two
# metric variables in the data set, gear (number of forward gears) and hp
# (horsepower). Interpret the resulting null hypothesis significance tests.

?mtcars

# Create box plots of the relationship between 
# the independent variables and the dependent variable
par(mfrow=c(1,2))
boxplot(gear ~ vs, data=mtcars, main="Top Gear vs. Engine Config.", col="orange") 
boxplot(hp ~ vs, data=mtcars, main="Horsepower vs. Engine Config.", col="skyblue") 

glmOut <- glm(formula = vs ~ gear + hp, family = binomial(), data = mtcars)
summary(glmOut)

# Deviance Residuals: 
#   Min        1Q    Median        3Q       Max  
# -1.76095  -0.20263  -0.00889   0.38030   1.37305  
# 
# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)  
# (Intercept) 13.43752    7.18161   1.871   0.0613 .
# gear        -0.96825    1.12809  -0.858   0.3907  
# hp          -0.08005    0.03261  -2.455   0.0141 *
#   ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 43.860  on 31  degrees of freedom
# Residual deviance: 16.013  on 29  degrees of freedom
# AIC: 22.013
# 
# Number of Fisher Scoring iterations: 7

# plot(glmOut)

# transform coefficient from log-odds to regular odds
exp(coef(glmOut))

# (Intercept)         gear           hp 
# 6.852403e+05 3.797461e-01 9.230734e-01

# Analysis:
# Looking first at the intercept, the null hypothesis is that the log-odds of
# the intercept is 0. The z-test value of 1.871 and the associated p value of
# 0.0613 means that we fail to reject the null hypothesis as the p value is
# above our chosen alpha of .05. The null hypothesis for the gear variable is
# that the log-odds is 0. We also fail to reject the null hypothesis because the
# z value of -0.858 and associated p value of .3907 is not significant. For the
# variable hp, the z value and associated p value of 0.0141 is significant with
# our alpha of .05. The change in log-odds of adding one unit of horsepower is
# -0.08005. The value 1 in our dependent variable is "straight." This can be
# interpreted as "The [log]odds of an engine being a "straight" configuration
# goes down as horsepower goes up." In this case, if the intercept and gear are
# zero, the log odds of the engine being a straight configuration for a one unit
# increase in hp is -.3907

# ------------------------------------------
# Exercise 5
# As noted in the chapter, the BaylorEdPsych add-in package contains a procedure
# for generating pseudo-Rsquared values from the output of the glm() procedure.
# Use the results of Exercise 1 to generate, report, and interpret a Nagelkerke
# pseudo-R-squared value.

library(BaylorEdPsych)
PseudoR2(glmOut)

#  McFadden     Adj.McFadden        Cox.Snell       Nagelkerke McKelvey.Zavoina           Effron 
# 0.6349042        0.4525061        0.5811397        0.7789526        0.8972195        0.6445327 
#     Count        Adj.Count              AIC    Corrected.AIC 
# 0.8125000        0.5714286       22.0131402       22.8702830 

# Analysis:
# The Nagelkerke pseudo r-squared value of 0.7790 can be loosely interpreted as
# the amount of variance in the dependent variable, vs (v-shaped, straight),
# explained by the independent variables, hp and gear. Exercise 6 Load the Chile
# vote data

# ------------------------------------------
# Exercise 6
# Continue the analysis of the Chile data set described in this chapter. The
# data set is in the "car" package, so you will have to install.packages() and
# library() that package first, and then use the data(Chile) command to get
# access to the data set. Pay close attention to the transformations needed to
# isolate cases with the Yes and No votes as shown in this chapter. Add a new
# predictor, statusquo, into the model and remove the income variable. Your new
# model specification should be vote ~ age + statusquo. The statusquo variable
# is a rating that each respondent gave indicating whether they preferred change
# or maintaining the status quo. Conduct general linear model and Bayesian
# analysis on this model and report and interpret all relevant results. Compare
# the AIC from this model to the AIC from the model that was developed in the
# chapter (using income and age as predictors).

library(car)

data(Chile)

# transform Chile dataset
ChileN=Chile[Chile$vote=='N',] # isolate yes votes
ChileY=Chile[Chile$vote=='Y',] # isolate no votes
ChileYN=rbind(ChileN, ChileY) # combine both yes and no
ChileYN=ChileYN[complete.cases(ChileYN),] # get rid of missing data
ChileYN$vote=factor(ChileYN$vote, levels=c("N", "Y")) # simplify the factor
str(ChileYN)

# linear
chileGLM=glm(vote ~ age + statusquo, family=binomial(), data=ChileYN)
summary(chileGLM)

# Deviance Residuals: 
#   Min       1Q   Median       3Q      Max  
# -3.2095  -0.2830  -0.1840   0.1889   2.8789  
# 
# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept) -0.193759   0.270708  -0.716   0.4741    
# age          0.011322   0.006826   1.659   0.0972 .  
# statusquo    3.174487   0.143921  22.057   <2e-16 ***
#   ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 2360.29  on 1702  degrees of freedom
# Residual deviance:  734.52  on 1700  degrees of freedom
# AIC: 740.52
# 
# Number of Fisher Scoring iterations: 6

# transform coefficient from log-odds to regular odds
exp(coef(chileGLM))

# (Intercept)         age   statusquo 
# 0.8238564   1.0113863  23.9145451

library(MCMCpack)

ChileYN$vote=as.numeric(ChileYN$vote)-1 # adjust outcome variable
ChileBayes=MCMClogit(formula=vote~ age + statusquo, data=ChileYN)
summary(ChileBayes)

# 1. Empirical mean and standard deviation for each variable,
# plus standard error of the mean:
  
#   Mean       SD  Naive SE Time-series SE
# (Intercept) -0.18272 0.272640 2.726e-03       0.008938
# age          0.01123 0.006817 6.817e-05       0.000223
# statusquo    3.19061 0.145853 1.459e-03       0.004993
# 
# 2. Quantiles for each variable:
#   
#   2.5%       25%      50%        75%   97.5%
# (Intercept) -0.742761 -0.365241 -0.17552 -0.0003872 0.34439
# age         -0.002005  0.006733  0.01121  0.0157683 0.02499
# statusquo    2.914442  3.087259  3.18546  3.2847388 3.48698

plot(ChileBayes)

# Analysis
# In the frequentist analysis, the intercept and age variable both generated z
# values that were not significant based on their p values of 0.4741 and 0.0972
# respective. We fail to reject both the null hypothesis that "the log-odds of
# the intercept is 0" and the "log odds of the age variable is 0." The
# independent variable, statusquo, has a z value of 22.0570 and a p value near
# zero, well below the chosen alpha of .05. We reject the null hypothesis that
# "the log-odds of statusquo predicting vote outcome is 0." The Bayesian
# analysis supports the z-test results. The HDI for both age and the intercept
# include zero. This supports failing to reject the null hypothesis in the
# z-tests. The distribution of posterior probabilities for statusquo has an HDI
# that does not include 0 with a range from 2.914 to 3.4870 and a median value
# of 3.1854. This supports the z-test finding of rejecting the null hypothesis.
# There is a 95% probability that the population log-odds for statusquo falls
# within the HDI. Comparing the AIC values for this model (740.52) and the one
# in the book (2332) shows that the model that includes statusquo can reduce the
# error rate with less complexity than the model that includes income. Between
# the two, we should choose the model with the lower AIC, the statusquo model.

# ------------------------------------------
# Exercise 7
# Bonus R code question: Develop your own custom function that will take the posterior distribution of a
# coefficient from the output object from an MCMClogit() analysis and automatically create a histogram of the
# posterior distributions of the coefficient in terms of regular odds (instead of log-odds). Make sure to mark
# vertical lines on the histogram indicating the boundaries of the 95% HDI.
OddsHistogram <- function(mcmc_out, seq){
  logOdds <- as.matrix(mcmc_out[,3])
  odds <- apply(logOdds,1,exp)
  hist(odds, col="skyblue", 
       main="Histogram of Statusquo Odds - Bayesian Analysis", 
       xlab='statusquo odds')
  abline(v=quantile(odds,c(0.025)),col='black')
  abline(v=quantile(odds,c(0.975)),col='black')
}
OddsHistogram(ChileBayes, 3)

