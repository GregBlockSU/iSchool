# IST777 - Demonstration of Metropolis-Hastings Algorithm
# Using a Markov chain to build a normal distribution.
# Modified from code developed by David Kaplan

# install.packages("pastecs")
# install.packages("coda")
require(pastecs) # For time series descriptives
require(coda)

# n Chooses the overall chain size. Should be in excess of 1000 for good results
# burnin Choose the initial length of the chain that will be ignored
# mu Sets the target mean of the distribution
MetroHastingsNormal <- function (n, burnin, mu, sigma) 
{
  
  # 1.  Define a numeric vector of length n and set the first value to the target center of the distribution 
  vec <- vector("numeric", n)
  x <- mu
  vec[1] <- x
  
  for (i in 2:n) {
    # Draw one value from a proposal normal distribution with mean 0 and sd as defined by the argument
    target <- rnorm(1, 0, sd=sigma)
    
    # Define a candidate value as the value of the target plus the previous value 
    can <- x + target # Candidate links to previous value: This is what makes it a time series 
    
    # Define the acceptance probability "aprob" as the minimum value of 1 or the 
    #      ratio of the density values of candidate value and x. To the extent that
    #      the candidate "fits better" into the target distribution, it will be kept.
    aprob <- min(1, dnorm(can, mean=mu, sd=sigma)/dnorm(x, mean=mu, sd=sigma)) 
   
    # Decide to accept or reject the candidate value by comparing aprob to a random  
    #      draw from a uniform(0, 1) distribution. Choose the candidate value if the 
    #      relative probability is higher than the random value.
    if (aprob >= runif(1)) { x <- can; print(can) } else {print(x)}
    
    vec[i] <- x # Either keep the old x or use the new value depending upon the previous test
  }
  
  summary <- stat.desc(vec[burnin:n], basic=F)
  print(summary)
  
  # Show a trace plot and a histogram of the chain        	
  hist(vec[burnin:n],30,main="Histogram of Post Burnin Values",xlab=NULL)
  plot(ts(vec[burnin:n]),main="Trace Plot of Post Burnin Values")

}

hist(iris$Sepal.Width)
swmean <- mean(iris$Sepal.Width)
swsd <- sd(iris$Sepal.Width)
swmean; swsd

MetroHastingsNormal(n=10000, burnin=1000, mu=swmean, sigma=swsd) 

