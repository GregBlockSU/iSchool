# Step 0 - Reset R Studio
rm(list = ls()) # remove variables
graphics.off() # clear graphs

Sys.setenv(JAVA_HOME="C:/jdk-25.0.1")
# Install packages if needed --------------------------------
pkgs <- c("rJava", "glmulti", "leaps")
to_install <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
if (length(to_install) > 0) install.packages(to_install)
install.packages("rJava", type="binary")
library(glmulti)
library(leaps)
R.version$arch

# Step 2: Prepare Data  
# Load Movies Data set from LiveSession5 
load("C:/repos/iSchool/BUA-345-BusinessAnalytics/Week-05/LiveSession5(1)(1).RData")
# Step 3: Run glmulti  
glmulti(`REVENUE/M` ~ ., data = MOVIES, fitfunction = lm, level = 1) -> RESULTS

# Step 4: Examine Results  

summary(RESULTS)  
summary(RESULTS)$bestmodel

# What is this step showing us?

# Step 5: Construct lm using best results
lm(summary(RESULTS)$bestmodel, data = MOVIES) -> Best_Movie_Model

# What benefit does using the (RESULTS)$bestmodel provide ?


# Step 6: View Best_Movie_Model
summary(Best_Movie_Model)

# Step 7: View ANOVA Table
anova(Best_Movie_Model)

  # Which attribute has the most influence ?
  # What % of the models variability can be explained by the predictors and what % can not?
  # What are the 2 way you can determine this? 

# Step 8:What are the levels in GENRE
levels(MOVIES$GENRE1)
levels(MOVIES$GENRE2)

# What are both of these lists the same? 


# Step 9: Make an Automated Prediction
# Generate data frame to store indepentend values you wist to use in your prediction. 

data.frame(GENRE1="Action", GENRE2="Adventure", RATED="PG", RUNTIME=127, BUDGET_M=100) -> Predict_Revenue



# # Step 10:  Use the predict function to predict  
predict(Best_Movie_Model,Predict_Revenue)

# What is the predicted value? 


