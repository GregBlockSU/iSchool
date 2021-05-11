library(BayesFactor)
library(BEST)

set.seed(1) # Make sampling reproducible
x <- rexp(100, rate=1/10) # Exponential
y <- x + rnorm(100,mean=2) # Adds a random effect to y

hist(x); hist(y) # Take a look
t.test(x,y) # Conventional frequentist

bestOut <- BESTmcmc(x, y) # BEST estimate
plot(bestOut) # Plot of mean diff posterior
bfOut <- ttestBF(x,y) # Plain Bayes Factor without posterior
bfOut # What is the Bayes factor
bfOutPost <- ttestBF(x,y, posterior = T, iterations=10000) # Run posteriors on this BF
plot(bfOutPost[,"beta (x - y)"]) # Examine the posterior plot
quantile(bfOutPost[,"beta (x - y)"], c(0.025,0.975)) # Look at the HDI

# Try a non-parametric alternative - The Mann-Whitney
?wilxox.test

wilcox.test(x,y)

