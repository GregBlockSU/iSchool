# Week 7 breakout 2 - Alternate measures of correlation

# this section creates the output file
install.packages("ltm")
library(ltm)
str(Science)

myScience <- Science[,c(1,2,3,4,7)]
sapply(myScience,table)
sapply(as.data.frame(sapply(myScience,as.numeric)), sd)
myScience$science <- rowSums(sapply(myScience,as.numeric))
hist(myScience$science)
myScience$optimist <- as.numeric(myScience$Comfort) > 2 &
  as.numeric(myScience$Benefit)

myTech <- Science[,c(5,6)]
sapply(myTech,table)
sapply(as.data.frame(sapply(myTech,as.numeric)), sd)
myTech$tech <- rowSums(sapply(myTech,as.numeric))
hist(myTech$tech)

altCorrData <- data.frame(myScience, myTech)
str(altCorrData)

set.seed(2)
altCorrSample <- altCorrData[sample(1:nrow(altCorrData), size=175), ]
str(altCorrSample)
altCorrSample$sciRank <- rank(altCorrSample$science, ties="random")
altCorrSample$techRank <- rank(altCorrSample$tech, ties="random")
str(altCorrSample)
#setwd("C:/Users/HQRGRS27/source/git/SU/iSchool/ist772/InClass/07")
write.csv(x=altCorrSample,file="altCorrSample.csv")

# 1. Read in the CSV file. Run str() to confirm that you have 175 observations of 12 variables.
# this section reads the CSV file
altCorrSample = read.csv("altCorrSample.csv")
altCorrSample = altCorrSample[, -1]
str(altCorrSample)

# 2. Display histograms of science, tech, sciRank, and techRank. Add comments indicating what you see.
# Ranks
hist(altCorrSample$sciRank)
hist(altCorrSample$techRank)
plot(altCorrSample$sciRank,altCorrSample$techRank)

# 3. Correlate the two rank order variables (sciRank and techRank) using three
# different correlation coefficients and compare the results. Make sure to test
# significance using cor.test(). The cor() and cor.test() functions both take an
# extra argument called method= which can be set to one of three correlation
# techniques: 
# . method= "pearson" - This produces the Pearson product moment
# correlation, suitable for normally distributed metric variables (also the
# default if method is not specified) 
# . method= "kendall" - This produces # Kendall's Tau, suitable for arbitrary 
# distributions with or without outliers 
# . # method= "spearman" - This produces Spearman's Rho, suitable for rank order
# variables (which are generally uniformly distributed)

ppmc2 <- cor(altCorrSample$sciRank, altCorrSample$techRank)
cor.test(altCorrSample$sciRank, altCorrSample$techRank)

kend2 <- cor(altCorrSample$sciRank, altCorrSample$techRank, method="kendall")
cor.test(altCorrSample$sciRank, altCorrSample$techRank, method="kendall")

spear2 <- cor(altCorrSample$sciRank, altCorrSample$techRank, method="spearman")
cor.test(altCorrSample$sciRank, altCorrSample$techRank, method="spearman")

# 4. Correlate the two metric variables (science and tech) using three different
# correlation coefficients and compare the results. Make sure to test
# significance using cor.test().

barplot(c(ppmc2, kend2, spear2), main="Rank Data", names.arg=c("ppmc","kend","spear"))

# Ordinal data
hist(as.numeric(as.factor(altCorrSample$Comfort)))
hist(as.numeric(as.factor(altCorrSample$Future)))
plot(as.numeric(as.factor(altCorrSample$Comfort)),as.numeric(as.factor(altCorrSample$Future))) 

ppmc1 <- cor(as.numeric(as.factor(altCorrSample$Comfort)), as.numeric(as.factor(altCorrSample$Future)))
cor.test(as.numeric(as.factor(altCorrSample$Comfort)), as.numeric(as.factor(altCorrSample$Future)))

kend1 <- cor(as.numeric(as.factor(altCorrSample$Comfort)), as.numeric(as.factor(altCorrSample$Future)), method="kendall")
cor.test(as.numeric(as.factor(altCorrSample$Comfort)), as.numeric(as.factor(altCorrSample$Future)), method="kendall")

spear1 <- cor(as.numeric(as.factor(altCorrSample$Comfort)), as.numeric(as.factor(altCorrSample$Future)), method="spearman")
cor.test(as.numeric(as.factor(altCorrSample$Comfort)), as.numeric(as.factor(altCorrSample$Future)), method="spearman")

barplot(c(ppmc1, kend1, spear1), main="Ordinal Data", names.arg=c("ppmc","kend","spear"))

# Regular metric correlation
hist(altCorrSample$science)
hist(altCorrSample$tech)
plot(altCorrSample$science,altCorrSample$tech)

ppmc3 <- cor(altCorrSample$science, altCorrSample$tech)
cor.test(altCorrSample$science, altCorrSample$tech)

kend3 <- cor(altCorrSample$science, altCorrSample$tech, method="kendall")
cor.test(altCorrSample$science, altCorrSample$tech, method="kendall")

spear3 <- cor(altCorrSample$science, altCorrSample$tech, method="spearman")
cor.test(altCorrSample$science, altCorrSample$tech, method="spearman")

barplot(c(ppmc1, kend1, spear1), main="Interval/Metric Data", names.arg=c("ppmc","kend","spear"))

# Point Biserial
cor(altCorrSample$science, as.numeric(altCorrSample$optimist))
cor.test(altCorrSample$science, as.numeric(altCorrSample$optimist))

cor(altCorrSample$science, as.numeric(altCorrSample$optimist), method="kendall")
cor.test(altCorrSample$science, as.numeric(altCorrSample$optimist), method="kendall")

cor(altCorrSample$science, as.numeric(altCorrSample$optimist), method="spearman")
cor.test(altCorrSample$science, as.numeric(altCorrSample$optimist), method="spearman")

library(ltm)
biserial.cor(altCorrSample$science, as.numeric(altCorrSample$optimist), level=2)


