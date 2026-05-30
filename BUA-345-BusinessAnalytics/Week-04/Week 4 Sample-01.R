# ============================================================
# 1. Create a large, meaningful dataset with interaction
# ============================================================

set.seed(42)

n <- 600
Department <- factor(sample(c("Sales", "Engineering", "HR"), n, replace = TRUE))
Experience <- runif(n, 0, 20)

# Different slopes + intercepts for each department
Performance <- ifelse(
  Department == "Sales",
  60 + 1.8 * Experience + rnorm(n, 0, 5),
  ifelse(
    Department == "Engineering",
    55 + 2.6 * Experience + rnorm(n, 0, 5),
    65 + 1.2 * Experience + rnorm(n, 0, 5)
  )
)

df <- data.frame(Department, Experience, Performance)

# ============================================================
# 2. Fit a model with an interaction term
# ============================================================

model <- lm(Performance ~ Experience * Department, data = df)
summary(model)
# Residuals:
#   Min       1Q   Median       3Q      Max 
# -16.8584  -3.0790  -0.0636   3.3290  17.6835 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)                55.38336    0.66206  83.653  < 2e-16 ***
#   Experience                  2.59260    0.06126  42.320  < 2e-16 ***
#   DepartmentHR               10.02800    0.98496  10.181  < 2e-16 ***
#   DepartmentSales             5.17338    0.95314   5.428 8.33e-08 ***
#   Experience:DepartmentHR    -1.43885    0.08694 -16.549  < 2e-16 ***
#   Experience:DepartmentSales -0.86912    0.08537 -10.180  < 2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 5.073 on 594 degrees of freedom
# Multiple R-squared:  0.8349,	Adjusted R-squared:  0.8335 
# F-statistic: 600.6 on 5 and 594 DF,  p-value: < 2.2e-16

# ============================================================
# 3. Generate predicted values
# ============================================================

df$Predicted <- predict(model)

# ============================================================
# 4. Interactive visualization using ggiraphExtra
# ============================================================

library(ggplot2)
library(ggiraphExtra)

ggPredict(model, se = TRUE, interactive = TRUE)
