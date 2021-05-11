# Jags Tutorial - For IST772/777

# Where is the JAGS model file?
setwd("C:/Users/HQRGRS27/OneDrive/Courses/Syracuse/2020/03-Summer/772/WeekByWeekLive/Week 05")


# Make sure JAGS is installed for native OS
# along with these packages:
# install.packages("rjags")
# install.packages("MCMCvis")
library("rjags")

set.seed(1)
n <- 100
beta.0 <- 0 # This is the center of the prior for the mean
sigma.sq <- 5 # This is the prior for the variance


y <- rnorm(n, beta.0, sqrt(sigma.sq)) # Make some data to model with those parms
hist(y); mean(y); sd(y); var(y)


data <- list(y = y, n = n) # Prepare data to go to jags

inits <- list(beta.0 = beta.0, sigma.sq = sigma.sq) # Priors for the run

# n.chains - Number of separate MCMC chains to run
# n.adapt - Number of initial samples not counted in chain (inital samples may be used to set 
# step size, e.g., for Metropolis-Hastings)
jags.m <- jags.model(file = "simpleDist.jags", data = data,
                     inits = inits, n.chains = 3, n.adapt = 100)

# This is a complex object full of code. The rest of the work is
# done in R.
View(jags.m) 

# These are the parameters for which we want to see output.
params <- c("beta.0", "sigma.sq")
samps <- coda.samples(jags.m, params, n.iter = 10000)

# Note that the trace plots show separate colors for each chain.
# The chains should "mix" - that is they should converge with each
# other from a distributional standpoint.
plot(samps)

# These commands give diagnostics on the quality of the separate chains.
gelman.diag(samps) # Factors of one mean that between-chain and within-chain variance are equal
gelman.plot(samps)
# Rule of thumb: values of 1.1 or less show adequate convergence

burn.in <- 1000 # Provides an initial set of samples that will be ignored
summary(window(samps, start = burn.in))

library(MCMCvis) # Package for visualizing MCMC results
MCMCsummary(samps, round=3)
MCMCtrace(samps, pdf=FALSE)



####################################################
# Now do two independent means

x <- mtcars$mpg[mtcars$am==0]
y <- mtcars$mpg[mtcars$am==1]

# Where is the JAGS model file?
setwd("~/Dropbox/Teaching/Statistics/WeekByWeekLive/Week5")

# Set up the priors 
mean_mu = mean(c(x, y)) # Set the means
precision_mu = 1 / (mad( c(x, y) )^2 * 1000000) # Precision is inverse of variance
sigmaLow = mad( c(x, y) ) / 1000 # mad is mean absolute deviation
sigmaHigh = mad( c(x, y) ) * 1000

inits_list <- list(
  mu_x = mean(x), mu_y = mean(y),
  sigma_x = mad(x), sigma_y = mad(y),
  nuMinusOne = 4)

data_list <- list(
  x = x, y = y,
  mean_mu = mean_mu,
  precision_mu = precision_mu,
  sigmaLow = sigmaLow,
  sigmaHigh = sigmaHigh)

# The parameters to monitor.
params <- c("mu_x", "mu_y", "mu_diff", "sigma_x", "sigma_y", "sigma_diff",
            "nu", "eff_size", "x_pred", "y_pred")

# Run the model
model <- jags.model("two_indep_means.jags.txt", data = data_list,
                    inits = inits_list, n.chains = 3, n.adapt=1000)

update(model, 1000) # Length of the burn in samples
samples <- coda.samples(model, params, n.iter=10000)

# Inspecting the posterior
plot(samples)
summary(samples)

# The bandwidth is calculated by 1.06 times the 
# minimum of the standard deviation and the interquartile range 
# divided by 1.34 times the sample size to the negative one fifth power


plot(samples[,"mu_diff"])


####################################################
# Now do two independent means with a simpler model

library(rjags)

x <- mtcars$mpg[mtcars$am==0]
y <- mtcars$mpg[mtcars$am==1]

# Where is the JAGS model file?
setwd("~/Dropbox/Research/BayesReanalysis")

# Set up the priors 
mean_mu = mean(c(x, y)) # Set the means
precision_mu = 1 / (mad( c(x, y) )^2 * 1000000) # Precision is inverse of variance
sigmaLow = mad( c(x, y) ) / 1000 # mad is mean absolute deviation
sigmaHigh = mad( c(x, y) ) * 1000

inits_list <- list(
  mu_x = mean(x), mu_y = mean(y),
  sigma_x = mad(x), sigma_y = mad(y),
  nuMinusOne = 4)

data_list <- list(
  x = x, y = y,
  mean_mu = mean_mu,
  precision_mu = precision_mu,
  sigmaLow = sigmaLow,
  sigmaHigh = sigmaHigh)

# The parameters to monitor.
params <- c("mu_x", "mu_y", "mu_diff", "sigma_x", "sigma_y", "sigma_diff",
            "nu", "eff_size")

# Run the model
model <- jags.model("simple_2_indep_means.jags.txt", data = data_list,
                    inits = inits_list, n.chains = 3, n.adapt=1000)

update(model, 1000) # Length of the burn in samples
samples <- coda.samples(model, params, n.iter=10000)

# Inspecting the posterior
plot(samples)
summary(samples)

# The bandwidth is calculated by 1.06 times the 
# minimum of the standard deviation and the interquartile range 
# divided by 1.34 times the sample size to the negative one fifth power


plot(samples[,"mu_diff"])
