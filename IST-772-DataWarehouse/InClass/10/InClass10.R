#####################################
# Chapter 11

# install.packages("BEST")
# install.packages("bcp")
# install.packages("changepoint")
# install.packages("tseries")
# install.packages("ez")
library(BEST)
library(changepoint)
library(bcp)
library(tseries)
library(ez)

# ---------- repeated measures ANOVA (RM-ANOVA)  ---------- 
boxplot(weight ~ Time, data=ChickWeight)

# t-test
ch16index <- ChickWeight$Time == 16 # Chicks measured at time 16
ch18index <- ChickWeight$Time == 18 # Chicks measured at time 18
bothChicks <- ChickWeight[ch16index | ch18index,] # Both sets together

time16weight <- bothChicks[bothChicks$Time == 16,"weight"] # Grab the weights for t=16
time18weight <- bothChicks[bothChicks$Time == 18,"weight"] # Grab the weights for t=18
cor(time16weight,time18weight) # Are they correlated?

# 0.9789155

# Yes, the weights are highly correlated

mean(time16weight)

# 168.0851

mean(time18weight)
# 190.1915

# mean difference is significant - what does the t-test say?

t.test(time18weight,time16weight,paired = FALSE) # Independent groups t-test

# Welch Two Sample t-test
# 
# data:  time18weight and time16weight
# t = 2.0446, df = 88.49, p-value = 0.04386
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   0.6216958 43.5910701
# sample estimates:
#   mean of x mean of y 
# 190.1915  168.0851

# t-test shows a significant p-value < .05, but the CI ranges from 0.62 to 43.6,
# so on the low end the mean difference is close to zero

BESTmcmc(time18weight, time16weight)# Run the Bayesian equivalent 

# MCMC fit results for BEST analysis:
#   100002 simulations saved.
# mean     sd median   HDIlo  HDIup  Rhat n.eff
# mu1    189.79  8.661 189.76 172.571 206.73 1.000 60415
# mu2    167.92  7.036 167.93 153.939 181.57 1.000 60311
# nu      36.71 29.667  28.25   2.952  95.36 1.001 18041
# sigma1  56.61  6.671  56.17  44.072  70.12 1.000 44693
# sigma2  46.02  5.511  45.64  35.766  57.29 1.000 42980
# 
# 'HDIlo' and 'HDIup' are the limits of a 95% HDI credible interval.
# 'Rhat' is the potential scale reduction factor (at convergence, Rhat=1).
# 'n.eff' is a crude measure of effective sample size.

# Bayesian t-test shows at the 95% HDIIs for the two means overlap, so there
# is not a credible difference between the two means

t.test(time18weight,time16weight,paired = TRUE) # Dependent groups t-test

# Paired t-test
# 
# data:  time18weight and time16weight
# t = 10.136, df = 46, p-value = 2.646e-13
# alternative hypothesis: true difference in means is not equal to 0
# 95 percent confidence interval:
#   17.71618 26.49658
# sample estimates:
#   mean of the differences 
# 22.10638 

# so this is a paired t-test, t-value of 10.1 on 46 dof, p < .001
# t-value is much larger than independent t-test, and the CI is narrower (17.7 to 26.5)
# with lower bound < 0

# paired t-test compares changes in weight for individual chicks

weightDiffs <- time18weight - time16weight # Make difference scores
t.test(weightDiffs) # Run a one sample t-test on difference scores

# One Sample t-test
# 
# data:  weightDiffs
# t = 10.136, df = 46, p-value = 2.646e-13
# alternative hypothesis: true mean is not equal to 0
# 95 percent confidence interval:
#   17.71618 26.49658
# sample estimates:
#   mean of x 
# 22.10638 

# a one-sample t-test on the difference yields a similar result to the paired t-test

BESTmcmc(weightDiffs) # Run the Bayesian equivalent on difference scores

# MCMC fit results for BEST analysis:
#   100002 simulations saved.
# mean     sd median  HDIlo  HDIup Rhat n.eff
# mu    21.98  2.285  21.97 17.453  26.41    1 60350
# nu    40.08 30.453  31.81  2.779 100.49    1 23051
# sigma 14.96  1.714  14.82 11.799  18.43    1 48561
# 
# 'HDIlo' and 'HDIup' are the limits of a 95% HDI credible interval.
# 'Rhat' is the potential scale reduction factor (at convergence, Rhat=1).
# 'n.eff' is a crude measure of effective sample size.

# the 95% HDI shows a mean difference with lbound of 17.5 and ubound of 26.5, similar to t-test

# ANOVA within
chwBal <- ChickWeight # Copy the dataset
chwBal$TimeFact <- as.factor(chwBal$Time) # Convert Time to a factor
list <- rowSums(table(chwBal$Chick,chwBal$TimeFact))==12 # Make a list of rows
list <- list[list==TRUE] # Keep only those with 12 observations
list <- as.numeric(names(list)) # Extract the row indices
chwBal <- chwBal[chwBal$Chick %in% list,] # Match against the data

table(chwBal$Chick,chwBal$TimeFact) # Check results

#    0 2 4 6 8 10 12 14 16 18 20 21
# 18 0 0 0 0 0  0  0  0  0  0  0  0
# 16 0 0 0 0 0  0  0  0  0  0  0  0
# 15 0 0 0 0 0  0  0  0  0  0  0  0
# (elided)

# this is a list of chick weights that have no empty cells (e.g. missing observations)
summary(aov(weight ~ TimeFact + Error(Chick), data=chwBal))

# Error: Chick
#              Df Sum Sq Mean Sq F value Pr(>F)
# Residuals    44 429899    9770               
# 
# Error: Within
#              Df  Sum Sq Mean Sq F value Pr(>F)    
#  TimeFact    11 1982388  180217   231.6 <2e-16 ***
#   Residuals 484  376698     778                   
# ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# this shows the anova across time partitions
# F-ratio of F(11,484) = 231.6, p-value < .001, rejecting null hypothesis
# that the weight of chicks do not vary across time

# Code for the Sidebar
ezANOVA(data=chwBal, dv=.(weight), within=.(TimeFact), wid=.(Chick), detailed=TRUE)

# $ANOVA
# Effect DFn DFd     SSn      SSd        F             p p<.05       ges
# 1 (Intercept)   1  44 8431251 429898.6 862.9362  1.504306e-30     * 0.9126857
# 2    TimeFact  11 484 1982388 376697.6 231.5519 7.554752e-185     * 0.7107921
# 
# $`Mauchly's Test for Sphericity`
# Effect            W             p p<.05
# 2 TimeFact 1.496988e-17 2.370272e-280     *
#   
#   $`Sphericity Corrections`
# Effect       GGe        p[GG] p[GG]<.05       HFe       p[HF] p[HF]<.05
# 2 TimeFact 0.1110457 7.816387e-23         * 0.1125621 4.12225e-23         *
#   

# Treating time as a random variable
#summary(aov(weight ~ Time + Error(Chick), data=chwBal))
#summary(lme(weight ~ TimeFact, data=chwBal, random = ~1 | Chick))

# ---------- time-series analysis ---------- 

set.seed(1234)				                    # Control random numbers
tslen <- 180					                    # About half a year of daily points
ex1 <- rnorm(n=tslen,mean=0,sd=10)        # Make a random variable
tex1 <- ex1 + seq(from=1, to=tslen, by=1) # Add the fake upward trend

plot.ts(tex1) # Plot the time series with a connected line 

ex2 <- rnorm(n=tslen,mean=0,sd=10)        # Make another random variable
tex2 <- ex2 + seq(from=1, to=tslen, by=1) # Add the fake upward trend
cor(ex1, ex2)                           # Correlation between the two random variables 

# -0.09385519

# two variables are effectively uncorrelated

cor(tex1, tex2)                         # Correlation between the two time series 

# 0.9634188

# however, the two time-series are highly correlated because we added an upward
# trend to each series

plot(tex1, tex2)

# both variables are uncorrelated but contain the same growth trend

# create a 3rd fake variable with an upward trend but also a seasonal component
# using the sine wave
ex3 <- rnorm(n=tslen,mean=0,sd=10)  
tex3 <- ex3 + seq(from=1, to=tslen, by=1) # Add the fake upward trend
tex3 <- tex3 + sin(seq(from=0,to=36,length.out=tslen))*20
plot.ts(tex3)

decOut <- decompose(ts(tex3,frequency=30))
plot(decOut)

# plot shows:
# - observed graph
# - trend (upward)
# - seasonality
# - noise
# 

mean(decOut$trend,na.rm=T)

# 90.22522

# sequence of numbers for, 1 to 180

mean(decOut$seasonal)

# 1.262782e-16
# sine wave oscillates around zero

mean(decOut$random,na.rm=T)

# -0.5675377

# random normal variable with a mean of 0

cor(ex3, decOut$random, use="complete.obs")

# 0.8304297

# correlation is quite large because decompose function was able to 
# remove a lot of the noise factor

set.seed(1234)
tslen <- 180
ex1 <- rnorm(n=tslen,mean=0,sd=10)        # Make a random variable
acf(ex1, main=NULL)

# stationary time series shows little correlation among lagged variables

tex1 <- ex1 + seq(from=1, to=tslen, by=1) # Add the fake upward trend
acf(tex1, main=NULL)

# adding trend increases the correlation among lagged observations

ex3 <- rnorm(n=tslen,mean=0,sd=10)  
tex3 <- ex3 + seq(from=1, to=tslen, by=1) # Add the fake upward trend
tex3 <- tex3 + sin(seq(from=0,to=36,length.out=tslen))*20
acf(tex3)
acf(decOut$trend,na.action=na.pass)

acf(decOut$seasonal, main=NULL)

# demonstrates seasonality with negative correlations

acf(decOut$random,na.action=na.pass, main=NULL)
# demonstrates some significant correlations with noise

decComplete <- decOut$random[complete.cases(decOut$random)]
adf.test(decComplete) # Shows significant, so it is stationary

# Augmented Dickey-Fuller Test
# 
# data:  decComplete
# Dickey-Fuller = -5.1302, Lag order = 5, p-value = 0.01
# alternative hypothesis: stationary

# we can reject the NULL hypothesis that the series is NOT stationary
# due to the low p-value 

plot(EuStockMarkets, main=NULL)

# plot shows clear upward trend

plot(diff(EuStockMarkets), main=NULL)

# variablity increases over time indicating heteroskedasticity
adf.test(diff(EuStockMarkets[,"DAX"]))

# Augmented Dickey-Fuller Test
# 
# data:  diff(EuStockMarkets[, "DAX"])
# Dickey-Fuller = -9.9997, Lag order = 12, p-value = 0.01
# alternative hypothesis: stationary

# we can reject the NULL hypothesis that the data is nonstationery
cor(diff(EuStockMarkets))

# DAX       SMI       CAC      FTSE
# DAX  1.0000000 0.7468422 0.7449335 0.6769647
# SMI  0.7468422 1.0000000 0.6414284 0.6169238
# CAC  0.7449335 0.6414284 1.0000000 0.6707475
# FTSE 0.6769647 0.6169238 0.6707475 1.0000000

# The following code examines change point analysis

# Use changepoint analysis to locate the position of a change
# in means

DAX <- EuStockMarkets[,1]
DAXcp <- cpt.mean(DAX)
DAXcp

# summary(.)  :
#   ----------
#   Created Using changepoint version 2.2.2 
# Changepoint type      : Change in mean 
# Method of analysis    : AMOC 
# Test Statistic  : Normal 
# Type of penalty       : MBIC with value, 22.585 
# Minimum Segment Length : 1 
# Maximum no. of cpts   : 1 
# Changepoint Locations : 1467

# Method of analysis = AMOC (at most one change, same as maximum # of cpts = 1)
# Type of penalty = MBIC (Modified Bayesian information Criterion) of 22.585 means
# any change that crosses that line is noteworthy
# Changepoint in time series mean detected at point #1467 / 1860 points

plot(DAXcp,cpt.col="grey",cpt.width=5)

#1997 is shift in means, from ~ 2,000 to 4,000

# look for a change in variance
cpt.var(diff(EuStockMarkets[,"DAX"])) # Examine the change in variance

# summary(.)  :
#   ----------
#   Created Using changepoint version 2.2.2 
# Changepoint type      : Change in variance 
# Method of analysis    : AMOC 
# Test Statistic  : Normal 
# Type of penalty       : MBIC with value, 22.58338 
# Minimum Segment Length : 2 
# Maximum no. of cpts   : 1 
# Changepoint Locations : 1480 

# change in variability detected at point #1480 / 1860

# Change to a simple output data structure to retrieve the confidence value
DAXcp <- cpt.mean(DAX,class=FALSE) 
DAXcp["conf.value"]

# conf.value 
# 1

# this is a high confidence level, like R^2

# Baysian analysis
bcpDAX <- bcp(as.vector(DAX))
plot(bcpDAX,outer.margins = list(left = unit(4,"lines"), bottom = unit(3, "lines"), right = unit(3, "lines"), top = unit(2,"lines")), main=NULL) 

# upper plot shows the original series; lower plot shows the probability of 
# a mean change at each point

# Let's plot the high-probability points on the chart
plot(bcpDAX$posterior.prob>.95)
