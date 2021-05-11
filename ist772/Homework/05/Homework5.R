# Homework 5, exercises 6, 7, 9 & 10

#Exercise 6
data("PlantGrowth")
(ctrl <- PlantGrowth$weight[PlantGrowth$group=="ctrl"])
(trt1 <- PlantGrowth$weight[PlantGrowth$group=="trt1"])

t.test(PlantGrowth$weight[PlantGrowth$group=="ctrl"] ,PlantGrowth$weight[PlantGrowth$group=="trt1"])

#Exercise 7
library(BEST)
PGBest <- BESTmcmc(PlantGrowth$weight[PlantGrowth$group=="ctrl"] ,PlantGrowth$weight[PlantGrowth$group=="trt1"])
plot(PGBest, main=NULL)

#Exercise 9
t.test(PlantGrowth$weight[PlantGrowth$group=="ctrl"] ,PlantGrowth$weight[PlantGrowth$group=="trt2"])
PGBest2 <- BESTmcmc(PlantGrowth$weight[PlantGrowth$group=="ctrl"] ,PlantGrowth$weight[PlantGrowth$group=="trt2"])
plot(PGBest2, main=NULL)

#Exercise 10
t.test(rnorm(100000,mean=17.1,sd=3.8),rnorm(100000,mean=17.2,sd=3.8))
