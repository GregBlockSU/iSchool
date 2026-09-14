############################################################
# Full R script: EDA, regression, interaction, ggiraphExtra
# Dataset: ggplot2::diamonds (n = 53,940)
# Quantitative predictor: carat
# Categorical predictor: cut
# Response: price
############################################################

# Step 0 - Reset R Studio
rm(list = ls()) # remove variables
graphics.off() # clear graphs

# Install packages if needed --------------------------------
pkgs <- c("ggplot2", "dplyr", "ggiraphExtra")
to_install <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
to_install
if (length(to_install) > 0) install.packages(to_install)

library(ggplot2)
library(dplyr)
library(ggiraphExtra)

# Load data -------------------------------------------------
data("diamonds", package = "ggplot2")
df <- diamonds
df$cut <- factor(df$cut)
# Keep a subset (optional, for speed) -----------------------
# Comment this out if you want full 53,940 rows
set.seed(123)
df <- df %>% sample_n(5000)

# Basic EDA -------------------------------------------------

# Structure and summary
str(df)

summary(df[, c("price", "carat", "cut")])

# price           carat               cut      
# Min.   :  335   Min.   :0.2200   Fair     : 139  
# 1st Qu.:  942   1st Qu.:0.4000   Good     : 463  
# Median : 2428   Median :0.7100   Very Good:1130  
# Mean   : 3941   Mean   :0.7984   Premium  :1289  
# 3rd Qu.: 5292   3rd Qu.:1.0400   Ideal    :1979  
# Max.   :18795   Max.   :3.0200  

# Distribution of cut with absolute values
table(df$cut)

# Fair      Good Very Good   Premium     Ideal 
# 139       463      1130      1289      1979 

# Distribution of cut with proportions
prop.table(table(df$cut))

# Fair      Good Very Good   Premium     Ideal 
# 0.0278    0.0926    0.2260    0.2578    0.3958

# Price distribution
ggplot(df, aes(x = price)) +
  geom_histogram(bins = 50, fill = "steelblue", color = "white") +
  labs(title = "Histogram of Price")

# Carat distribution
ggplot(df, aes(x = carat)) +
  geom_histogram(bins = 50, fill = "darkorange", color = "white") +
  labs(title = "Histogram of Carat")

# Price by cut (boxplot)
ggplot(df, aes(x = cut, y = price)) +
  geom_boxplot(fill = "lightgreen") +
  labs(title = "Price by Cut")

# Scatter: price vs carat, colored by cut
ggplot(df, aes(x = carat, y = price, color = cut)) +
  geom_point(alpha = 0.4) +
  labs(title = "Price vs Carat by Cut")

# Regression models -----------------------------------------

# Model 1: no interaction (parallel slopes)
m1 <- lm(price ~ carat + cut, data = df)
summary(m1)

# Residuals:
#   Min      1Q  Median      3Q     Max 
# -9514.0  -838.4   -42.3   537.7 11514.8 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -2802.59      50.99 -54.966  < 2e-16 ***
#   carat        7973.57      46.04 173.191  < 2e-16 ***
#   cut.L        1310.82      88.12  14.875  < 2e-16 ***
#   cut.Q        -516.12      77.92  -6.624 3.88e-11 ***
#   cut.C         306.00      66.78   4.582 4.71e-06 ***
#   cut^4         126.62      53.15   2.382   0.0172 *  
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 1510 on 4994 degrees of freedom
# Multiple R-squared:  0.859,	Adjusted R-squared:  0.8589 
# F-statistic:  6086 on 5 and 4994 DF,  p-value: < 2.2e-16

# Model 2: with interaction (different slopes by cut)
m2 <- lm(price ~ carat * cut, data = df)
summary(m2)

# Residuals:
#   Min      1Q  Median      3Q     Max 
# -6904.5  -827.8   -23.9   559.5 11396.0 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept) -2258.32      73.69 -30.645  < 2e-16 ***
#   carat        7433.59      70.06 106.101  < 2e-16 ***
#   cut.L        -497.49     205.10  -2.426  0.01532 *  
#   cut.Q         394.25     179.90   2.191  0.02846 *  
#   cut.C         -57.42     147.51  -0.389  0.69709    
# cut^4         -95.42     111.45  -0.856  0.39195    
# carat:cut.L  1901.72     189.96  10.011  < 2e-16 ***
#   carat:cut.Q  -824.57     168.64  -4.890 1.04e-06 ***
#   carat:cut.C   325.00     143.57   2.264  0.02364 *  
#   carat:cut^4   312.84     114.18   2.740  0.00617 ** 
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 1493 on 4990 degrees of freedom
# Multiple R-squared:  0.8624,	Adjusted R-squared:  0.8621 
# F-statistic:  3475 on 9 and 4990 DF,  p-value: < 2.2e-16

# Model 2 is better because the slope of price vs. carat is not constant 
# across cut categories, and the interaction terms are highly significant, 
# meaning the data demands different slopes.
# Model 1 incorrectly forces parallel lines, which is contradicted 
# by the evidence.


# Why Model 2 wins (the real reasons)
# 1. Residual standard error improves
# Model 1 RSE: 1510
# Model 2 RSE: 1493

# A drop of 17 points may look small, but with ~5000 observations, 
# that’s meaningful.
# Lower RSE = better fit.

# 2. Adjusted R² improves
# Model 1: 0.8589
# Model 2: 0.8621

#Adjusted R² penalizes extra parameters.
# Model 2 still improves → the added complexity is justified.

# Compare models
anova(m1, m2)

# Analysis of Variance Table

# Model 1: price ~ carat + cut
# Model 2: price ~ carat * cut
# Res.Df        RSS Df Sum of Sq      F    Pr(>F)    
# 1   4994 1.1389e+10                                  
# 2   4990 1.1117e+10  4 271866169 30.508 < 2.2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# Model 1 assumes:
# “Cut only shifts the intercept; the slope of price vs. carat is 
# the same for all cuts.”
# Model 2 allows:
# “Cut changes both the intercept and the slope.”
# The ANOVA shows that letting slopes differ across cut categories 
# dramatically improves the model.

# Conclusion
# Model 2 is statistically, structurally, and practically better.
# The ANOVA confirms that the interaction terms explain a large 
# amount of additional variance.
# The improvement is far too big to be random.
# The simpler model (parallel slopes) is rejected.

# Add fitted values from interaction model
df$pred_m2 <- fitted(m2)

# Interaction visualization (static) ------------------------

# Regression lines by cut (from m2)
ggplot(df, aes(x = carat, y = price, color = cut)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Interaction: Price ~ Carat * Cut")

# Another view: predicted vs actual
ggplot(df, aes(x = pred_m2, y = price, color = cut)) +
  geom_point(alpha = 0.4) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(title = "Predicted vs Actual (Interaction Model)",
       x = "Predicted price", y = "Actual price")

# Interactive visualization with ggiraphExtra ---------------

