
############################################################
# Wine Quality (Kaggle combined) – interactions & ggiraphExtra
# Assumes a CSV with a 'type' column: "red"/"white"
# e.g., winequality_combined.csv
############################################################

# Packages -------------------------------------------------
pkgs <- c("dplyr", "ggplot2", "ggiraphExtra")
to_install <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
if (length(to_install) > 0) install.packages(to_install)

library(dplyr)
library(ggplot2)
library(ggiraphExtra)

# 1. Load data ---------------------------------------------

folder_path = "C:/repos/iSchool/BUA-345/Week-04"
red_file_path = file.path(folder_path, "winequality-red.csv")
white_file_path = file.path(folder_path, "winequality-white.csv")
red  <- read.csv(red_file_path,sep = ";")
white <- read.csv(white_file_path, sep = ";")

# Add categorical variable
red$type   <- "red"
white$type <- "white"

# Combine
df <- bind_rows(red, white)


# Make sure type is a factor
df$type <- factor(df$type)

# Quick sanity check
str(df)
summary(df)
table(df$quality)
names(df)
# 2. Basic EDA ---------------------------------------------

# Quality by type
ggplot(df, aes(x = type, y = quality, fill = type)) +
  geom_boxplot(alpha = 0.7) +
  labs(title = "Wine Quality by Type")

# Alcohol vs quality by type
ggplot(df, aes(x = alcohol, y = quality, color = type)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Quality vs Alcohol by Type")

# Residual sugar vs quality by type
ggplot(df, aes(x = residual.sugar, y = quality, color = type)) +
  geom_point(alpha = 0.3) +
  geom_smooth(method = "lm", se = FALSE) +
  labs(title = "Quality vs Residual Sugar by Type")

# 3. Models: without vs with interactions ------------------

# Model 0: baseline (no type, no interactions)
m0 <- lm(quality ~ alcohol + residual.sugar + volatile.acidity, data = df)

# Model 1: add type, no interactions (parallel slopes)
m1 <- lm(quality ~ alcohol + residual.sugar + volatile.acidity + type, data = df)

# Model 2: add interactions with type (different slopes)
m2 <- lm(
  quality ~ alcohol * type +
    residual.sugar * type +
    volatile.acidity * type,
  data = df
)

cat("\n=== Model 0 (no type, no interactions) ===\n")
summary(m0)

cat("\n=== Model 1 (add type, no interactions) ===\n")
summary(m1)

cat("\n=== Model 2 (with interactions) ===\n")
summary(m2)

# 4. Compare models ----------------------------------------

cat("\n=== ANOVA comparisons ===\n")
cat("\nM0 vs M1:\n")
print(anova(m0, m1))

cat("\nM1 vs M2:\n")
print(anova(m1, m2))

cat("\n=== AIC comparison ===\n")
print(AIC(m0, m1, m2))

# 5. Predicted values & slopes -----------------------------

df$pred_m1 <- fitted(m1)
df$pred_m2 <- fitted(m2)

# Predicted vs actual (interaction model)
ggplot(df, aes(x = pred_m2, y = quality, color = type)) +
  geom_point(alpha = 0.3) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed") +
  labs(
    title = "Predicted vs Actual Quality (Interaction Model)",
    x = "Predicted quality",
    y = "Actual quality"
  )

# 6. ggiraphExtra interactive visualizations ---------------

# Alcohol * type interaction
ggPredict(
  m2,
  se = TRUE,
  interactive = TRUE,
  terms = c("alcohol", "type")
)

# Residual sugar * type interaction
ggPredict(
  m2,
  se = TRUE,
  interactive = TRUE,
  terms = c("residual.sugar", "type")
)

# Volatile acidity * type interaction
ggPredict(
  m2,
  se = TRUE,
  interactive = TRUE,
  terms = c("volatile.acidity", "type")
)

############################################################
# End of script
############################################################
