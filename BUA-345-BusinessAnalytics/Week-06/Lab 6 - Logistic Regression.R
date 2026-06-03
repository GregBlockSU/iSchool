# Step 1: Install and Load Packages  
#install.packages("glmulti")
library(glmulti)


# Load and inspect data  
library(readr)
Telco_Churn <- read_csv("BUA 345/Week 6/Telco_Churn.csv")
View(Telco_Churn)

# running a logistic regression via a general linear model. Describe model
Pred_Churn <- glm(Churn ~ ., family="binomial", data = Telco_Churn)
summary(Pred_Churn)

# Run glmulti. What is this function doing >  
glmulti(Churn ~ ., data=Telco_Churn, fitfunction = glm, level = 1) -> RESULTS

#Examine Results  - What is this step showing us?, How many iterations did it take? why so many?

summary(RESULTS)  
summary(RESULTS)$bestmodel


#Construct using best results. What benefit does using the (RESULTS)$bestmodel provide ?
glm(summary(RESULTS)$bestmodel, data = Telco_Churn) -> Best_Model

#View Best_Model
summary(Best_Model)

# View ANOVA Table
anova(Best_Model)

#Make an Automated Prediction
# Generate data frame to store indepentend values you wist to use in your prediction. 

data.frame(Dependents="Yes", Contract="One year", PaymentMethod = "Electronic check", MonthlyCharges=90, TotalCharges=2000) -> Predict_Churn

# Use the predict function to predict  
predict(Best_Model,Predict_Churn)


