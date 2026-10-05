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

# 177

str(titanic)

# 'data.frame':	891 obs. of  4 variables:
#   $ PassengerId: int  2 3 4 9 10 11 12 16 18 20 ...
# $ Survived   : chr  "Yes" "Yes" "Yes" "Yes" ...
# $ Sex        : chr  "female" "female" "female" "female" ...
# $ Age        : num  38 26 35 27 14 4 58 55 NA NA ...

summary(titanic)

# PassengerId         Survived          Sex           Age       
# Min.   :  1.0   Length   :891   Length   :891   Min.   : 0.42  
# 1st Qu.:223.5   N.unique :  2   N.unique :  2   1st Qu.:20.12  
# Median :446.0   N.blank  :  0   N.blank  :  0   Median :28.00  
# Mean   :446.0   Min.nchar:  2   Min.nchar:  4   Mean   :29.70  
# 3rd Qu.:668.5   Max.nchar:  3   Max.nchar:  6   3rd Qu.:38.00  
# Max.   :891.0                                   Max.   :80.00  
# NAs    :177

# Convert categorical values to factors
titanic$Survived  <- as.factor(titanic$Survived)
titanic$Sex  <- as.factor(titanic$Sex)

summary(titanic)

# PassengerId    Survived      Sex           Age       
# Min.   :  1.0   No :549   female:314   Min.   : 0.42  
# 1st Qu.:223.5   Yes:342   male  :577   1st Qu.:20.12  
# Median :446.0                          Median :28.00  
# Mean   :446.0                          Mean   :29.70  
# 3rd Qu.:668.5                          3rd Qu.:38.00  
# Max.   :891.0                          Max.   :80.00  
# NAs    :177

# Create a missingness map
missmap(titanic)

# see plot

################################################################
#Begin Clean-up

# overwrite origional data frame, but this is dangerouse so be careful !!!
titanic$Age <- missForest(titanic)$ximp$Age 

# Count missing age values 
sum(is.na(titanic))

# Create a missingness map
missmap(titanic)

