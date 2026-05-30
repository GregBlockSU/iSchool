#####################################
# Chapter 2

table(rbinom(n=100,size=6,prob=0.5))

hist(rbinom(n=100,size=6,prob=0.5))

#png("Figure02_1.png", width = 6, height = 6,help units = 'in', res = 300)
hist(rbinom(n=1000,size=6,prob=0.5), main=NULL)
#dev.off()

#png("Figure02_2.png", width = 6, height = 6, units = 'in', res = 300)
barplot(table(rbinom(n=1000,size=6,prob=0.5)), main=NULL)
#dev.off()

table(rbinom(n=1000,size=6,prob=0.5))/1000
#png("Figure02_3.png", width = 6, height = 6, units = 'in', res = 300)
barplot(table(rbinom(n=1000,size=6,prob=0.5))/1000, main=NULL)
#dev.off()

probTable <- table(rbinom(n=1000,size=6,prob=0.5))/1000
probTable
cumsum(probTable)

probTable <- table(rbinom(n=1000,size=6,prob=0.5))/1000
#png("Figure02_4.png", width = 6, height = 6, units = 'in', res = 300)
barplot(cumsum(probTable),main=NULL)
#dev.off()

probTable <- table(rbinom(n=10000,size=100,prob=0.5))/10000
barplot(probTable)
barplot(cumsum(probTable))

# Sidebar 2.1: Create Your Own Tables with R
#
toast <- matrix(c(2,1,3,4),ncol=2,byrow=TRUE) # Create a two column structure using the matrix() command
colnames(toast) <- c("Down","Up") # Label the columns
rownames(toast) <- c("Jelly","Butter") # Label the rows
toast <- as.table(toast) # Convert from metric to table
toast # Show the table on the console
margin.table(toast) # This is the grand total of toast drops
margin.table(toast,1) # These are the marginal totals for rows
margin.table(toast,2) # These are the marginal totals for columns
toastProbs <- toast/margin.table(toast) # Calculate probabilities
toastProbs # Report probabilities to console
