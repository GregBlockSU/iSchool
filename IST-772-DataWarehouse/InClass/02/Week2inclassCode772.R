# Week 2 IST777 In Class Code

hist(rbinom(100000,100,.5), main="What Distribution?", xlab = "X")

#----------------------------
# Breakout 1

lapply(0:7, function(i) choose(i, 0:i)) # Pascal's triangle out to 7 coins
sum(choose(7, 0:7)) # Total trials for the bottom row
length(choose(7, 0:7)) - 1 # Number of coins
choose(7, 0:7)/128 # Probabilities for entries in the bottom row
rbinom(10,7,.5) # 10 throws of seven coins
table(rbinom(100000,7,.5)) # 100,000 throws, summarized in a table
table(rbinom(100000,7,.5))/100000 # Same expressed as proportions

dbinom(x=0:7, size=7, prob=0.5) # Density function

# Bonus: Calculate how much error between 100,000 and theory
(table(rbinom(1000000,7,.5))/1000000) - dbinom(x=0:7, size=7, prob=0.5)


#----------------------------
# Breakout 2

# Set up the matrix
accMatrix <- matrix(data=c(0,6,4,6,0,6,6,4,5,4,9,0),
                    nrow=4,byrow=T, 
                    dimnames=list(c("Vehicle","Spill","Equipment","Injury"),
                                  c("Factory 1", "Factory 2", "Factory 3")))

rowSums(accMatrix) # Demonstrate rowSums()
accPropMatrix <- accMatrix/sum(accMatrix) # Proportions for each cell
accPropMatrix # Echo to console
as.matrix(accPropMatrix[which.max(accPropMatrix)]) # What's the largest proportion?

rowSums(accPropMatrix) # Calculate row and col sums from proportions
colSums(accPropMatrix)

#############################
# First analyze by column
which.max(colSums(accPropMatrix)) # Factory 2 has the most

# Normalized likelihood of all accidents, factory 2
accMatrix[,2]/sum(accMatrix[,2])
# Same thing, but using the prop matrix
accPropMatrix[,2]/sum(accPropMatrix[,2])

# Vehicle accidents are the first element
(accMatrix[,2]/sum(accMatrix[,2]))[1]

# Check that normalization worked properly: All probs in a set should add to 1
sum(accPropMatrix[,2]/sum(accPropMatrix[,2]))

#############################
# Now analyze by row

which.max(rowSums(accPropMatrix)) # Equipment (row 3)

# Normalized likelihood of equipment accidents, all factories
accMatrix[3,]/sum(accMatrix[3,])
# Same thing, but using the prop matrix
accPropMatrix[3,]/sum(accPropMatrix[3,])
# Check that normalization worked properly: All probs in a set should add to 1
sum(accPropMatrix[3,]/sum(accPropMatrix[3,]))
