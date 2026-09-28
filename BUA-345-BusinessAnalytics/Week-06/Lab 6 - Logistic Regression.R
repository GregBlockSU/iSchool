# Step 0 - Reset R Studio
rm(list = ls()) # remove variables
graphics.off() # clear graphs

# ignore the warning:
# WARNING: Rtools is required to build R packages but is not currently 
# installed. Please download and install the appropriate version of 
# Rtools before proceeding:
#  
#  https://cran.rstudio.com/bin/windows/Rtools/

Sys.setenv(JAVA_HOME="C:/jdk-25.0.1")
# Install packages if needed --------------------------------
pkgs <- c("glmulti", "readr")
to_install <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
if (length(to_install) > 0) install.packages(to_install)

# Step 1: Install and Load Packages  
#install.packages("glmulti")
library(glmulti)
library(readr)

# Load and inspect data  
setwd("C:/repos/iSchool/BUA-345-BusinessAnalytics/Week-06")
getwd()
Telco_Churn <- read_csv("Telco_Churn.csv")
str(Telco_Churn)

# spc_tbl_ [999 × 12] (S3: spec_tbl_df/tbl_df/tbl/data.frame)
# $ Churn           : num [1:999] 0 0 1 0 1 1 0 0 1 0 ...
# $ gender          : chr [1:999] "Female" "Male" "Male" "Male" ...
# $ SeniorCitizen   : num [1:999] 0 0 0 0 0 0 0 0 0 0 ...
# $ Partner         : chr [1:999] "Yes" "No" "No" "No" ...
# $ Dependents      : chr [1:999] "No" "No" "No" "No" ...
# $ tenure          : num [1:999] 1 34 2 45 2 8 22 10 28 62 ...
# $ PhoneService    : chr [1:999] "No" "Yes" "Yes" "No" ...
# $ Contract        : chr [1:999] "Month-to-month" "One year" "Month-to-month" "One year" ...
# $ PaperlessBilling: chr [1:999] "Yes" "No" "Yes" "No" ...
# $ PaymentMethod   : chr [1:999] "Electronic check" "Mailed check" "Mailed check" "Bank transfer (automatic)" ...
# $ MonthlyCharges  : num [1:999] 29.9 57 53.9 42.3 70.7 ...
# $ TotalCharges    : num [1:999] 29.9 1889.5 108.2 1840.8 151.7 ...
# - attr(*, "spec")=
#   .. cols(
#     ..   Churn = col_double(),
#     ..   gender = col_character(),
#     ..   SeniorCitizen = col_double(),
#     ..   Partner = col_character(),
#     ..   Dependents = col_character(),
#     ..   tenure = col_double(),
#     ..   PhoneService = col_character(),
#     ..   Contract = col_character(),
#     ..   PaperlessBilling = col_character(),
#     ..   PaymentMethod = col_character(),
#     ..   MonthlyCharges = col_double(),
#     ..   TotalCharges = col_double()
#     .. )

# running a logistic regression via a general linear model. Describe model
Pred_Churn <- glm(Churn ~ ., family="binomial", data = Telco_Churn)
summary(Pred_Churn)

# Call:
#   glm(formula = Churn ~ ., family = "binomial", data = Telco_Churn)
# 
# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)                          -0.8694788  0.4671378  -1.861 0.062703 .  
# genderMale                            0.0993947  0.1733482   0.573 0.566386    
# SeniorCitizen                         0.1329217  0.2194046   0.606 0.544628    
# PartnerYes                            0.0397037  0.2124106   0.187 0.851724    
# DependentsYes                        -0.3496872  0.2479756  -1.410 0.158490    
# tenure                               -0.0481394  0.0170266  -2.827 0.004694 ** 
#   PhoneServiceYes                      -0.7860173  0.3387047  -2.321 0.020305 *  
#   ContractOne year                     -1.1061937  0.3008525  -3.677 0.000236 ***
#   ContractTwo year                     -2.1615768  0.5189170  -4.166 3.11e-05 ***
#   PaperlessBillingYes                   0.1726637  0.1956491   0.883 0.377497    
# PaymentMethodCredit card (automatic) -0.4953962  0.3052938  -1.623 0.104656    
# PaymentMethodElectronic check         0.5509493  0.2381433   2.314 0.020694 *  
#   PaymentMethodMailed check            -0.0915648  0.2958577  -0.309 0.756949    
# MonthlyCharges                        0.0218014  0.0054779   3.980 6.89e-05 ***
#   TotalCharges                          0.0002054  0.0001902   1.080 0.280221    
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 1135.29  on 995  degrees of freedom
# Residual deviance:  819.97  on 981  degrees of freedom
# (3 observations deleted due to missingness)
# AIC: 849.97
# 
# Number of Fisher Scoring iterations: 6

# ❌ Non-Significant Predictors (p > 0.05)
# gender, SeniorCitizen, Partner, Dependents, PaperlessBilling, 
# PaymentMethodCredit card, PaymentMethodMailed check, and TotalCharges 
# all fail to reach significance. These are candidates for removal to 
# simplify the model.

# ⚠️ Key Issues to Address
# 1. Multicollinearity — TotalCharges, tenure, MonthlyCharges
# This is the most important red flag. 
# TotalCharges ≈ tenure × MonthlyCharges by definition — they are 
# mathematically related, which inflates standard errors and suppresses 
# significance. This likely explains why TotalCharges is non-significant 
# despite the obvious business logic.
library(car)
vif(Pred_Churn)

# GVIF Df GVIF^(1/(2*Df))
# gender            1.015783  1        1.007861
# SeniorCitizen     1.107539  1        1.052397
# Partner           1.435050  1        1.197936
# Dependents        1.352022  1        1.162765
# tenure           15.257956  1        3.906143
# PhoneService      1.346119  1        1.160224
# Contract          1.479582  2        1.102897
# PaperlessBilling  1.157490  1        1.075867
# PaymentMethod     1.438243  3        1.062442
# MonthlyCharges    2.820367  1        1.679395
# TotalCharges     18.410427  1        4.290737
# VIF > 5–10 confirms multicollinearity. Consider dropping TotalCharges 
# since it's largely redundant.

# Run glmulti. What is this function doing >  
RESULTS <- glmulti(Churn ~ ., data=Telco_Churn, fitfunction = glm, level = 1)
                   #plotty = TRUE, report = "vweights")

#Examine Results  - What is this step showing us?, How many iterations did it take? why so many?

# 🧠 In short
# The IC profile graph is a ranked plot of model quality, showing how each candidate model compares in terms of 
# AIC/AICc/BIC. It tells you:
#   
#   Which model is best
# 
# How much better it is than the others
# 
# Whether many models are competitive
# 
# Whether model averaging is justified
# After 2100 models:
#  Best model: Churn~1+Dependents+Contract+PaymentMethod+MonthlyCharges+TotalCharges
# Crit= 887.910652515504
# Mean crit= 891.156874794013
# Completed.

summary(RESULTS)  
summary(RESULTS)$bestmodel

# [1] "Churn ~ 1 + Dependents + Contract + PaymentMethod + MonthlyCharges + "
# [2] "    TotalCharges" 

# It evaluated 2,100 different model combinations of your predictor variables —
# every different subset it could construct — before converging on a winner.
#
# Best model:
# Churn~1+Dependents+Contract+PaymentMethod+MonthlyCharges+TotalCharges This is
# the single best-performing model found across all 2,100 candidates. The 1 is
# just the intercept. It selected 5 predictors, dropping: gender, SeniorCitizen,
# Partner, tenure, PhoneService, PaperlessBilling.
#
# Crit= 887.91 This is the AIC of the best model. Lower AIC = better model
# (penalizes complexity while rewarding fit).
#
# Mean crit= 891.16 The average AIC across all 2,100 models tested. The best
# model beats the average by ~3.25 AIC points — a modest but meaningful margin,
# suggesting the winning model is genuinely better than most candidates but not
# dramatically so.

#Construct using best results. What benefit does using the (RESULTS)$bestmodel provide ?
Best_Model <- glm(summary(RESULTS)$bestmodel, family = "binomial", data = Telco_Churn)

#View Best_Model
summary(Best_Model)

# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)    
# (Intercept)                          -1.855e+00  3.317e-01  -5.592 2.24e-08 ***
#   DependentsYes                        -4.045e-01  2.140e-01  -1.890  0.05875 .  
# ContractOne year                     -1.243e+00  2.906e-01  -4.276 1.90e-05 ***
#   ContractTwo year                     -2.389e+00  4.991e-01  -4.787 1.69e-06 ***
#   PaymentMethodCredit card (automatic) -4.360e-01  3.015e-01  -1.446  0.14813    
# PaymentMethodElectronic check         6.715e-01  2.343e-01   2.866  0.00416 ** 
#   PaymentMethodMailed check            -4.138e-02  2.823e-01  -0.147  0.88345    
# MonthlyCharges                        2.555e-02  4.316e-03   5.920 3.22e-09 ***
#   TotalCharges                         -2.835e-04  6.639e-05  -4.270 1.95e-05 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 1135.29  on 995  degrees of freedom
# Residual deviance:  834.17  on 987  degrees of freedom
# (3 observations deleted due to missingness)
# AIC: 852.17

# McFadden's Pseudo-R²: 1 − (834.17 / 1135.29) = 0.265 — solid fit for logistic
# regression.

# With tenure removed from the model, TotalCharges now absorbs the tenure
# signal: customers with high total charges (controlling for monthly charges)
# have simply been around longer — and longer-tenured customers are less likely
# to churn. MonthlyCharges captures the cost burden, while TotalCharges captures
# loyalty/tenure. The two predictors cleanly partition what was previously
# muddled by multicollinearity.

# Compare AIC to your original full model
AIC(Pred_Churn, Best_Model)

# df      AIC
# Pred_Churn 15 849.9682
# Best_Model  9 852.1738

# The best model costs only +2.2 AIC points to gain 6 fewer parameters — an
# excellent parsimony trade-off. Every coefficient is now more reliable because
# multicollinearity from tenure, gender, SeniorCitizen, etc. has been removed.
# This is the preferred model for inference and deployment. The glmulti "best"
# model actually has a higher (worse) AIC than your original full model.

# View ANOVA Table
anova(Best_Model)

# Model: binomial, link: logit
# 
# Response: Churn
# 
# Terms added sequentially (first to last)
# 
# 
# Df Deviance Resid. Df Resid. Dev  Pr(>Chi)    
# NULL                             995    1135.29              
# Dependents      1   35.277       994    1100.01 2.859e-09 ***
#   Contract        2  184.188       992     915.83 < 2.2e-16 ***
#   PaymentMethod   3   43.610       989     872.22 1.827e-09 ***
#   MonthlyCharges  1   19.045       988     853.17 1.277e-05 ***
#   TotalCharges    1   18.997       987     834.17 1.309e-05 ***
  
# Key Insights 
# 1. Contract is dominant. At 61.2% of all explained deviance with
# the largest chi-square by a wide margin, contract type is the single most
# powerful driver of churn in this dataset. The deviance reduction of 184.19 on
# just 2 df is exceptional.
#
# 2. PaymentMethod and Dependents are meaningful secondary drivers. Together
# they contribute another ~26% of explained deviance, far outpacing the
# charge-related variables.
#
# 3. MonthlyCharges and TotalCharges are nearly identical contributors. Both
# remove ~19 deviance units — almost exactly equal. This reflects their shared
# but complementary roles: MonthlyCharges captures current cost burden while
# TotalCharges proxies tenure. Despite their correlation, each contributes
# independent signal.

# Make an Automated Prediction Generate data frame to store independent values
# you wist to use in your prediction.

Predict_Churn <- data.frame(Dependents="Yes", Contract="One year", PaymentMethod = "Electronic check", MonthlyCharges=90, TotalCharges=200)

# Use the predict function to predict  
log_odds <- predict(Best_Model,Predict_Churn)
log_odds

# -0.5880827  

# Convert to probability (two equivalent ways)
probs <- plogis(log_odds)                    # cleanest R-native way
probs
# 0.3570749

probs <- 1 / (1 + exp(-log_odds))           # manual sigmoid formula
probs
# 0.3570749


# 🎯 Interpretation in logistic regression terms
# The log‑odds are negative, so the event is less likely than not.
# 
# Probability ≈ 0.36.
# 
# Corresponding odds:
#   
#   0.3579
# 1
# −
# 0.3579
# ≈
# 0.557
# Meaning roughly 0.56:1 (about one chance of happening for every two chances of not happening).
# 
# 🧠 Intuition
# Log‑odds 0 → probability 0.5
# 
# Log‑odds –0.588 → probability 0.36
# 
# Log‑odds +0.588 → probability 0.64

