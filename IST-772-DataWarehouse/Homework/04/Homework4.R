cat('\014')  # Clear the console
rm(list=ls()) # Clear user objects from the environment

# Load the Plant Growth dataset
data(PlantGrowth)
? PlantGrowth

# Print a summary of the Plant Growth data
summary(PlantGrowth)

# Break the weights down by group
ctrl.weights = PlantGrowth$weight[PlantGrowth$group == 'ctrl']
trt1.weights = PlantGrowth$weight[PlantGrowth$group == 'trt1']
trt2.weights = PlantGrowth$weight[PlantGrowth$group == 'trt2']

# Plot a histogram of the control group weights
hist(ctrl.weights, main="Histogram of Control Group Plant Weights"
     , ylab = "frequency"
     , xlab="weight (gms)"
     , col="darkgreen"
     , border = "white")

# Plot a histogram of the trt1 diet weights
hist(trt1.weights, main="Histogram of TRT1 Group Plant Weights"
     , ylab = "frequency"
     , xlab="weight (gms)"
     , col="darkslateblue"
     , border = "white")

# Plot a histogram of the trt2 weights
hist(trt2.weights, main="Histogram of TRT2 Group Plant Weights"
     , ylab = "frequency"
     , xlab="weight (gms)"
     , col="darkgoldenrod"
     , border = "white")

# Create a boxplot of weights by group
boxplot(weight ~ group, PlantGrowth
        , main="Boxplot Chart of Plant Weights by Group"
        , xlab="group"
        , ylab="weight (g)"
        , col = "palevioletred"
        , border = "violetred4")

# Generate a t test on the means between the control group and diet trt1
t.test(ctrl.weights, trt1.weights)

# Generate a t test on the means between the control group and diet trt2
t.test(ctrl.weights, trt2.weights)


