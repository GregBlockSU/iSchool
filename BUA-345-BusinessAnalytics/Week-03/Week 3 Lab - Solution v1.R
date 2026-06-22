# Step 1 - Load Week 3 Data Set


# Step 2 - Explore Data Frame 
head(NASHVILLE)

# Step 3 - Name and describe data elements in Data Set


# Step 4 - Identify Dependent and Independent variables for Linear model


# Step 5 - Construct and run Simple regression model 


# Step 6 - Identify intercept and coefficients


# Step 7 - Predict the price of a home for the following cases:


# 1. Home with .25 Acres, 1200 SF, 2 baths, and built in 1960

# 2. Home with .4 Acres, 1350 SF, 3 baths, and built in 1940
head(NASHVILLE)


#fit multiple linear regression model
model <- lm(PRICE ~ AREA + BATHS + YEAR, data=NASHVILLE)
summary(model)


#PREDICT New HOME
new <- data.frame(AREA=c(.25), BATHS=c(3), YEAR=c(1960))

#use the fitted model to predict the rating for the new player
predict(model, newdata=new)
