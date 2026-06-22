# Step 0 - Reset R Studio
rm(list = ls()) # remove variables
graphics.off() # clear graphs

# To use the missForest and amelia package, you first need to install and load 1st
# Install packages if needed --------------------------------
pkgs <- c("missForest", "Amelia")
to_install <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
if (length(to_install) > 0) install.packages(to_install)

library(missForest)
library(Amelia)

library(ggplot2)


# Load titanic data set
setwd("C:/repos/iSchool/BUA-345-BusinessAnalytics/Week-07")
titanic <- read.csv("titanic.csv")


# See age value count 
titanic$Age

# Count missing age values 
sum(is.na(titanic))

str(titanic)

# Convert categorical values to factors
titanic$Survived  <- as.factor(titanic$Survived)
titanic$Sex  <- as.factor(titanic$Sex)

# Create a missingness map
missmap(titanic)

################################################################
#Begin Clean-up

# overwrite origional data frame, but this is dangerouse so be careful !!!
titanic$Age <- missForest(titanic)$ximp$Age 

# Count missing age values 
sum(is.na(titanic))

# Create a missingness map
missmap(titanic)
