#####################################
# Chapter 10


# Create a sequence of 100 numbers, ranging from -6 to 6 to serve as the X variable
logistX <- seq(from=-6, to=6, length.out=100)

# Compute the logit function using exp(), the inverse of log()
logistY <- exp(logistX)/(exp(logistX)+1)

# Now review the S curve
plot(logistX,logistY)

# Create a random, standard-normal predictor variable
set.seed(123)
logistX <- rnorm(n=100,mean=0,sd=1)

# Create an outcome variable as a logit function of the predictor
logistY <- exp(logistX)/(exp(logistX)+1)
plot(logistX,logistY)

# Make the dichotomous/binomial version of the outcome variable
binomY <- round(logistY)
plot(logistX, binomY)

# Add noise to the predictor so that it does not perfectly predict the outcome
logistX <- logistX/1.41 + rnorm(n=100,mean=0,sd=1)/1.41
plot(logistX, binomY)

# Convert the outcome variable into a factor and create a data frame
binomY <- factor(round(logistY), labels=c('Truth','Lie'))
logistDF <- data.frame(logistX, logistY, binomY) # Make data frame

boxplot(formula=logistX ~ binomY, data=logistDF, ylab="GSR", main=NULL)

glmOut <- glm(binomY ~ logistX, data=logistDF, family=binomial())
summary(glmOut)

# Deviance Residuals: 
#   Min       1Q   Median       3Q      Max  
# -2.3216  -0.7982   0.3050   0.8616   1.7414  
# 
# Coefficients:
#              Estimate Std. Error z value Pr(>|z|)    
# (Intercept)   0.1199     0.2389   0.502    0.616    
# logistX       1.5892     0.3403   4.671    3e-06 ***
#   ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 138.47  on 99  degrees of freedom
# Residual deviance: 105.19  on 98  degrees of freedom
# AIC: 109.19

# Y-intercept is close to zero; logistX coefficient of 1.5892 has a low
# p-value of 3e-06, lower than the alpha value of .01, so we can reject
# the NULL hypothesis that the coefficient of logistX is 0

mean(residuals(glmOut))

# 0.004100191
# the mean of the residuals is close to zero.

hist(residuals(glmOut))
# distribution is slightly negatively skewed

exp(coef(glmOut)) # Convert log odds to odds

# (Intercept)     logistX 
# 1.127432    4.900041

# based on the log-odds, a one unit change in logistX gives us a 4.9:1 change
# in the odds of binomY

exp(confint(glmOut)) # Look at confidence intervals around log-odds

#                 2.5 %    97.5 %
# (Intercept) 0.7057482  1.812335
# logistX     2.6547544 10.190530

# range of odds for Y-intercept straddle 1 (the NULL hypothesis)
# 95% CI for logistX variable spans 2.65 to 10.19, which is a wide range
# so we stick with a point estimate of 4.9

# Null deviance: 138.47  on 99  degrees of freedom
# Residual deviance: 105.19  on 98  degrees of freedom

# also, null deviance of 138.47 and residual deviance of 105.19 = 33.28
# which measures how much error has been reduced with the one-predictor model

anova(glmOut, test="Chisq")  # Compare null model to one predictor model

# Response: binomY
# 
# Terms added sequentially (first to last)
# 
# 
# Df Deviance Resid. Df Resid. Dev  Pr(>Chi)    
# NULL                       99     138.47              
# logistX  1   33.279        98     105.19 7.984e-09 ***
#   ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

# low p-value of 7.984e-09 means we can reject NULL hypothesis that 
# adding the variable did not reduce the error

# Akaike Information criterion (AIC) is 109.19 but there
# is no other model to compare this model to

par(mfrow=c(1,2))                          # par() configures the plot area
plot(binomY, predict(glmOut),ylim=c(-4,4)) # Compare with earlier plot
plot(binomY, logistX,ylim=c(-4,4))

# predictions (left side) versus actual (right side)
# note that the dispersion for the prediction is wider than actual,
# reflecting the error in the model

# Logistic regression with a real data example

# install.packages("car")
library(car)
data(Chile)

ChileY <- Chile[Chile$vote == "Y",] # Grab the Yes votes
ChileN <- Chile[Chile$vote == "N",] # Grab the No votes
ChileYN <- rbind(ChileY,ChileN) # Make a new dataset with those
ChileYN <- ChileYN[complete.cases(ChileYN),] # Get rid of missing data
ChileYN$vote <- factor(ChileYN$vote,levels=c("N","Y")) # Fix the factor

dim(ChileYN)

# 1703    8

table(ChileYN$vote)

#   N   Y 
# 867 836

par(mfrow=c(1,2))      
boxplot(age ~ vote, data=ChileYN, main=NULL)
boxplot(income ~ vote, data=ChileYN)

# age/vote boxplot demonstrates that younger voters are more likely
# to vote no than older voters; income/vote plot indicates that wealthier voters
# are more likely to vote no; both plots show substantial overlap - could
# this be sampling error?

chOut <- glm(formula = vote ~ age + income, family = binomial(), data = ChileYN)

summary(chOut)

# Deviance Residuals: 
#   Min      1Q  Median      3Q     Max  
# -1.435  -1.126  -1.004   1.191   1.373  
# 
# Coefficients:
#                 Estimate Std. Error z value Pr(>|z|)    
# (Intercept)   -7.581e-01  1.418e-01  -5.346 9.01e-08 ***
#   age          1.924e-02  3.324e-03   5.788 7.11e-09 ***
#   income      -2.846e-07  1.142e-06  -0.249    0.803    
# ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 2360.3  on 1702  degrees of freedom
# Residual deviance: 2326.0  on 1700  degrees of freedom
# AIC: 2332
# 
# Number of Fisher Scoring iterations: 4

# note that the Y-intercept differs significantly from 0 (-7.581, with
# a p-value of 9.01e-08. Y-intercept measuees odds of a 0-aged, 0-income
# person voting Yes!
# age coefficient is 1.924e-02 with a p-value of 7.11e-09, below our alpha value,
# so we can reject the NULL hypothesis for age;
# income  coefficient of -2.846e-07 (close to zero) has a p-value of 0.803,
# so we fail to reject the NULL hypothesis for income

exp(coef(chOut)) # Convert log odds to odds

# (Intercept)         age      income 
#   0.4685354   1.0194293   0.9999997

# the odds of 1.019 shows that for every year, the person is 1.9% more likely
# to vote yes

exp(confint(chOut)) # Look at confidence intervals

#                   2.5 %    97.5 %
#   (Intercept) 0.3544246 0.6180933
#   age         1.0128365 1.0261271
#   income      0.9999975 1.0000020

# divide age by 10 to see how the CI changes
ChileYN10 <- ChileYN
ChileYN10$age <- ChileYN10$age/10
chOut10 <- glm(formula = vote ~ age + income, family = binomial(), data = ChileYN10)
exp(confint(chOut10)) # Look at confidence intervals

#                 2.5 %    97.5 %
#  (Intercept) 0.3544246 0.6180933 (versus 1.0261271)
#  age         1.1360392 1.2942297
#  income      0.9999975 1.0000020

# the CI for the age variable spans 1.01 to 1.026, with the point estimate of 1.019

anova(chOut, test="Chisq")   # Compare null model to predictor models

# Model: binomial, link: logit
# 
# Response: vote
# 
# Terms added sequentially (first to last)
# 
# 
# Df Deviance Resid. Df Resid. Dev  Pr(>Chi)    
#   NULL                    1702     2360.3              
#   age     1   34.203      1701     2326.1 4.964e-09 ***
#   income  1    0.062      1700     2326.0    0.8032    
# ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 


# install.packages("BaylorEdPsych")
library(BaylorEdPsych)
PseudoR2(chOut)

#     McFadden     Adj.McFadden        Cox.Snell       Nagelkerke McKelvey.Zavoina           Effron 
# 1.451751e-02     1.112811e-02     1.991966e-02     2.656249e-02     2.435449e-02     2.000043e-02 
#        Count        Adj.Count              AIC    Corrected.AIC 
# 5.590135e-01     1.016746e-01     2.332029e+03     2.332043e+03 

# Nagelkerke R2 is 0.027, so the proportion of variance in the outcome variable
# (vote) that age and income accounted for

# the large sample size of n=1703 allows us to capture a smaller effect size
hist(predict(chOut,type="response"))
table(round(predict(chOut,type="response")),ChileYN$vote)

# N   Y
# 0 565 449
# 1 302 387


# Now do it the Bayesian way

# install.packages("MCMCpack")    # Download MCMCpack package
library(MCMCpack) # Load the package 
ChileYN$vote <- as.numeric(ChileYN$vote) - 1 # Adjust the outcome variable
bayesLogitOut <- MCMClogit(formula = vote ~ age + income, data = ChileYN)
summary(bayesLogitOut) # Summarize the results

# 1. Empirical mean and standard deviation for each variable,
# plus standard error of the mean:
#   
#   Mean        SD  Naive SE Time-series SE
# (Intercept) -7.602e-01 1.452e-01 1.452e-03      4.849e-03
# age          1.935e-02 3.317e-03 3.317e-05      1.089e-04
# income      -3.333e-07 1.151e-06 1.151e-08      3.723e-08
# 
# 2. Quantiles for each variable:
#   
#   2.5%        25%        50%        75%      97.5%
# (Intercept) -1.044e+00 -8.588e-01 -7.609e-01 -6.639e-01 -4.710e-01
# age          1.278e-02  1.711e-02  1.930e-02  2.157e-02  2.584e-02
# income      -2.549e-06 -1.113e-06 -3.662e-07  4.437e-07  1.926e-06

plot(bayesLogitOut)

#graph of income shows the HDI straggles zero, but the age plot centers on 0.20
exp(mean(bayesLogitOut[,"age"]))

# 1.019542

exp(quantile(bayesLogitOut[,"age"],c(0.025)))


#     2.5% 
# 1.012866

exp(quantile(bayesLogitOut[,"age"],c(0.975)))

#    97.5% 
# 1.026173

ageLogOdds <- as.matrix(bayesLogitOut[,"age"])
ageOdds <- apply(ageLogOdds,1,exp)

hist(ageOdds, main=NULL)
abline(v=quantile(ageOdds,c(0.025)),col="black") 
abline(v=quantile(ageOdds,c(0.975)),col="black")

# histogram centers on 1.02, which matches the CI we derived from
# glm. The HDI spans 1.013 to 1.026


