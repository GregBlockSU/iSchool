# Modeled after problem at https://www.statology.org/predict-in-r-multiple-regression/

#Turn off Scientific notation
options(scipen = 50)

#create data frame
df <- data.frame(salary=c(670000, 750000, 790000, 850000, 900000, 960000, 970000),
                 points=c(8, 12, 16, 15, 22, 28, 24),
                 assists=c(4, 6, 6, 5, 3, 8, 7),
                 rebounds=c(1, 4, 3, 3, 2, 6, 7))


#------------------------------------------------------

# Plotting Data 
#install.packages("ggplot2")
library(ggplot2)

# Adds a linear regression line for points without confidence interval
qplot(df$salary, df$points) + 
    geom_smooth(method = "lm", se = FALSE) 

# Adds a linear regression line for assists without confidence interval
qplot(df$salary, df$assists) + 
  geom_smooth(method = "lm", se = FALSE) 

# Adds a linear regression line for rebounds without confidence interval
qplot(df$salary, df$rebounds) + 
  geom_smooth(method = "lm", se = FALSE) 


#Which dependent variable looks most closely correlated with salary?

#------------------------------------------------------

#fit multiple linear regression model
model <- lm(salary ~ points + assists + rebounds, data=df)
summary(model)


#Coefficients:
#  Estimate Std. Error t value Pr(>|t|)   
# (Intercept)   664355      66932   9.926  0.00218 **
#  points         12152       2788   4.359  0.02232 * 
#  assists       -25968      16263  -1.597  0.20860   
#  rebounds       28202      16118   1.750  0.17847   

#From the values in the Estimate column, we can write the fitted regression model:
#PredictedSalary = 664355 + 12152(points) – 25968(assists) + 28202(rebounds)

#------------------------------------------------------

#We can use the following code to predict the salary of a new player who has 20 points, 5 assists, and 2 rebounds:

#define new player
new <- data.frame(points=c(20), assists=c(5), rebounds=c(2))

#use the fitted model to predict the rating for the new player
predict(model, newdata=new)

# 833960.7
