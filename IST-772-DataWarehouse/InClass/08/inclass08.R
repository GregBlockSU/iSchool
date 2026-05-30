#####################################
# Chapter 8

# create 3 random variables, plus a "noise" variable
set.seed(321)
hardwork <- rnorm(120)
basicsmarts <- rnorm(120)
curiosity <- rnorm(120)
randomnoise <- rnorm(120)

# synthesize gpa from these variables; divide each variable by
# 2 (square root of 4 = 4 input variables) yields an sd of ~ 1
gpa <- hardwork/2 + basicsmarts/2 + curiosity/2 + randomnoise/2
sd(gpa)
# 1.011214
mean(gpa)
# 0.1619686
mean(hardwork)
# 0.004557451

# scatterplot = linearity (rough shape of point cloud)
# bivariate normlaity - dense where X, Y means intersect
# not a lot of outliers
# "guess" a slope of 0.56

plot(hardwork, gpa, main=NULL)
abline(a=0, b=0.56)

# draw "error of prediction" for the point
arrows(min(hardwork),gpa[which.min(hardwork)],min(hardwork),min(hardwork)*0.56)

# pick 2 points to demonstrate predicted value of gpa, actual value of gpa, and
# prediction error
hardwork[14]
#  2.44326
gpa[14]
# 1.85159

pre <- 0.56 * hardwork[14]
act <- gpa[14]
err <- act - pre
err
#dev.off()


# draw histogram of estimated best-fitting line and each point
# note this is normally distributed, centered on 0
hist(gpa - (hardwork * 0.56), main=NULL)

# sum of errors is ~ 19, but the errors above and below the lines
# cancel each other
sum(gpa - (hardwork * 0.56))

# use squared error to eliminate +/- cancellation
calcSQERR <- function(y, x, slope)
{
  (y - (x * slope))^2
}

head(calcSQERR(gpa,hardwork,0.56))

# 3.742599e+00 8.443497e-06 2.959611e+00 1.432950e+00 1.451349e+00 3.742827e+00
sum(calcSQERR(gpa,hardwork,0.56))
# 86.42242

# the histogram is positive because negative values removed by squaring;
# most near zero
hist(calcSQERR(gpa,hardwork,0.56), main=NULL)

#dev.off()
# create function to calculate the sum of squared errors for different slopes
# note that x, y are hard-coded
sumSQERR <- function(slope)
{
  sum(calcSQERR(gpa, hardwork, slope))
}

sumSQERR(0.56)

# returns same as sum(calcSQERR(gpa,hardwork,0.56))
# 86.42242

# create a sequence of "possible" slopes
trySlopes <- seq(from=0, to=1, length.out=40)

# View(data.frame(trySlopes, sqerrList))

# calculate sum of squared errors for each of these test slopes
sqerrList <- sapply(trySlopes, sumSQERR)

# plot each slope and its sum of squared errors
# note the parabolic shape, as a result of using squares
# sum of squared errors is at its lowest point ~ 0.60 (close to 0.56)
plot(trySlopes, sqerrList, main=NULL)
#dev.off()

# now set up test to  use linear model
educdata <- data.frame(gpa, hardwork, basicsmarts, curiosity)
regOut <- lm(gpa ~ hardwork, data=educdata)
summary(regOut)

regOut3 <- lm(gpa ~ hardwork + basicsmarts + curiosity, data=educdata)
summary(regOut3)

#png("Figure08_6.png", width = 6, height = 6, units = 'in', res = 300) 
plot(randomnoise,regOut3$residuals, main=NULL)
#dev.off()

summary(residuals(regOut3))
cor(educdata)


regOutMCMC <- lmBF(gpa ~ hardwork + basicsmarts + curiosity, data=educdata, posterior=TRUE, iterations=10000)
summary(regOutMCMC)


#png("Figure08_7.png", width = 6, height = 6, units = 'in', res = 300) 
hist(regOutMCMC[,"hardwork"], main=NULL)
abline(v=quantile(regOutMCMC[,"hardwork"],c(0.025)), col="black")
abline(v=quantile(regOutMCMC[,"hardwork"],c(0.975)), col="black")
#dev.off()

rsqList <- 1 - (regOutMCMC[,"sig2"] / var(gpa))
# length(rsqList)  # Confirms 10000 R-squared estimates
mean(rsqList)  # Overall mean R-squared is 0.75
#png("Figure08_8.png", width = 6, height = 6, units = 'in', res = 300) 
hist(rsqList, main=NULL)
abline(v=quantile(rsqList,c(0.025)), col="black")
abline(v=quantile(rsqList,c(0.975)), col="black")
#dev.off()

regOutBF <- lmBF(gpa ~ hardwork + basicsmarts + curiosity, data=educdata)
regOutBF

# Real example using state.x77 data
stateData <- data.frame(state.x77)
stateOut <- lm(Life.Exp ~ HS.Grad + Income + Illiteracy,data=stateData)
summary(stateOut)

stateOutMCMC <- lmBF(Life.Exp ~ HS.Grad + Income + Illiteracy,data=stateData, posterior=TRUE, iterations=100000)
summary(stateOutMCMC)
rsqList <- 1 - (stateOutMCMC[,"sig2"] / var(stateData$Life.Exp))
mean(rsqList)  # Overall mean R-squared
quantile(rsqList,c(0.025))
quantile(rsqList,c(0.975))

hist(stateData$Illiteracy) # Histogram of raw data
hist(stateOutMCMC[,"Illiteracy"]) # Posterior distribution of B weight
boxplot(as.numeric(stateOutMCMC[,"Illiteracy"])) # Posterior distribution of B weight

stateOutBF <- lmBF(Life.Exp ~ HS.Grad + Income + Illiteracy,data=stateData)
stateOutBF

# Code for bonus homework item
set.seed(1)
betaVar <- scale(rbeta(50,shape1=1,shape2=10))
normVar <- rnorm(50)
poisVar <- scale(rpois(50,lambda=10))
noiseVar <- scale(runif(50))
depVar <- betaVar/2 + normVar/2 + poisVar/2 + noiseVar/2
oddData <- data.frame(depVar,betaVar,normVar,poisVar)

summary(lm(depVar ~ .,data=oddData))

