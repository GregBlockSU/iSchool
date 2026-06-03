# -----------------------------
# 1. Load libraries
# -----------------------------

pkgs <- c("caret", "glmnet", "ggplot2", "reshape2", "corrplot")
to_install <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
if (length(to_install) > 0) install.packages(to_install)
library(caret)
library(glmnet)
library(ggplot2)
library(reshape2)
library(corrplot)
set.seed(123)

# -----------------------------
# 2. Generate synthetic dataset
# -----------------------------
n <- 500
p <- 12

X <- matrix(rnorm(n * p), nrow = n, ncol = p)
colnames(X) <- paste0("X", 1:p)

# True relationship uses only X3, X5, X7
y <- 3*X[,3] - 2*X[,5] + 1.5*X[,7] + rnorm(n)

data <- data.frame(y, X)

# -----------------------------
# 3. Correlation-based filtering
# -----------------------------
cor_vals <- cor(data)[1, -1]  # correlation of y with each X
cor_df <- data.frame(
  Feature = names(cor_vals),
  Correlation = as.numeric(cor_vals)
)

# Visualization: correlation barplot
ggplot(cor_df, aes(x = reorder(Feature, Correlation), y = Correlation)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  ggtitle("Correlation of Features with Target")

# -----------------------------
# 4. Correlation heatmap
# -----------------------------
corrplot(cor(data), method = "color", tl.cex = 0.8)

# -----------------------------
# 5. Recursive Feature Elimination (RFE)
# -----------------------------
control <- rfeControl(functions = lmFuncs, method = "cv", number = 5)

rfe_results <- rfe(
  x = data[, -1],
  y = data$y,
  sizes = 1:p,
  rfeControl = control
)

print(rfe_results)
predictors(rfe_results)

# Visualization: RFE performance
plot(rfe_results, type = c("g", "o"))

# -----------------------------
# 6. LASSO Feature Selection
# -----------------------------
X_mat <- as.matrix(data[, -1])
y_vec <- data$y

lasso_fit <- glmnet(X_mat, y_vec, alpha = 1)

# Visualization: LASSO coefficient paths
plot(lasso_fit, xvar = "lambda", label = TRUE)

# Best lambda via cross-validation
cv_fit <- cv.glmnet(X_mat, y_vec, alpha = 1)
best_lambda <- cv_fit$lambda.min
best_lambda

coef(cv_fit, s = "lambda.min")

# Visualization: CV curve
plot(cv_fit)

selected_features <- rownames(coef(cv_fit))[coef(cv_fit)[,1] != 0][-1]
selected_features

formula <- as.formula(paste("y ~", paste(selected_features, collapse = " + ")))
final_model <- lm(formula, data = data)
summary(final_model)

pred <- predict(final_model, data)

ggplot(data.frame(actual = data$y, predicted = pred),
       aes(x = actual, y = predicted)) +
  geom_point(alpha = 0.5, color = "darkred") +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  ggtitle("Regression Fit: Actual vs Predicted") +
  theme_minimal()
