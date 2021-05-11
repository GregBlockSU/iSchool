# Jags Tutorial - For IST772/777

# Where is the JAGS model file?
#setwd("C:/Users/HQRGRS27/OneDrive/Courses/Syracuse/2020/03-Summer/772/WeekByWeekLive/Week 05")

# Make sure JAGS is installed for native OS
# along with these packages:
install.packages("rjags")
install.packages("MCMCvis")
library("rjags")

####################################################
# Model the difference between two independent means

# Here's where we set up the data that we want to model.
# You can change this to contain two independent groups
# from any data source.
x <- mtcars$mpg[mtcars$am==0]
y <- mtcars$mpg[mtcars$am==1]


####################################################
# JAGS model setup begins here:

# Set up the priors 
mean_mu = mean(c(x, y)) # Set the means
precision_mu = 1 / (mad( c(x, y) )^2 * 1000000) # Precision is inverse of variance
sigmaLow = mad( c(x, y) ) / 1000 # mad is mean absolute deviation
sigmaHigh = mad( c(x, y) ) * 1000

# This makes a list and then provides initial
# values for all of the elements in the JAGS
# model. Compare with the model file.
inits_list <- list(
  mu_x = mean(x), mu_y = mean(y),
  sigma_x = mad(x), sigma_y = mad(y),
  nuMinusOne = 4)

# This makes a list and then copies in all of 
# the data elements that the JAGS model needs
# in order to run. 
data_list <- list(
  x = x, y = y,
  mean_mu = mean_mu,
  precision_mu = precision_mu,
  sigmaLow = sigmaLow,
  sigmaHigh = sigmaHigh)

# These are the parameters we want to monitor.
# JAGS will create code to maintain a record of each of
# these variables for every MCMC sample drawn.
params <- c("mu_x", "mu_y", "mu_diff", "sigma_x", "sigma_y", "sigma_diff",
            "nu", "eff_size", "x_pred", "y_pred")

# Run the model using the JAGS code from the text file.
model <- jags.model("two_indep_means.jags.txt", data = data_list,
                    inits = inits_list, n.chains = 3, n.adapt=1000)

View(model) # Optionally review the contents of the model object.

# This first step runs the burn-in samples, while
# the second step continues the model run with the 
# post burn-in iterations.
update(model, 1000) # You can change the length of the burn-in samples
samples <- coda.samples(model, params, n.iter=10000) # You can increase the MCMC iterations.

# Inspecting the posterior
par(mar=c(1,1,1,1))
plot(samples, trace=F) # Give a density plot
plot(samples, density=F) # Give a trace plot; takes a while!
summary(samples) # Summrize the run

# The bandwidth is calculated by 1.06 times the 
# minimum of the standard deviation and the interquartile range 
# divided by 1.34 times the sample size to the negative one fifth power
plot(samples[,"mu_diff"]) # Give the trace and density plots for mu_diff

# Compare these results to a t-test
