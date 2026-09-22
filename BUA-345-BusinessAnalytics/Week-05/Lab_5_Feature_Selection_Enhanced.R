# =============================================================================
#  Lab 5 – Feature Selection  (Enhanced with Visualizations)
#  Added: EDA plots, prediction visualization, ANOVA bar chart,
#         goodness-of-fit diagnostics, and R² display
# =============================================================================

# Step 0 – Reset environment
rm(list = ls())
graphics.off()

# --------------------------------------------------------------------------
# Packages
# --------------------------------------------------------------------------
pkgs <- c("ggplot2", "gridExtra", "dplyr", "scales", "reshape2", "leaps")
to_install <- pkgs[!pkgs %in% installed.packages()[, "Package"]]
if (length(to_install) > 0) install.packages(to_install, repos = "https://cloud.r-project.org")

library(ggplot2)
library(gridExtra)
library(dplyr)
library(scales)
library(reshape2)

# NOTE: glmulti requires Java.  Set your JAVA_HOME before loading if needed:
Sys.setenv(JAVA_HOME = "C:/jdk-25.0.1")
library(glmulti)
library(leaps)

# --------------------------------------------------------------------------
# Shared theme for a clean, consistent look
# --------------------------------------------------------------------------
theme_lab <- function() {
  theme_minimal(base_size = 12) +
    theme(
      plot.title    = element_text(face = "bold", size = 13, hjust = 0.5),
      plot.subtitle = element_text(size = 10, hjust = 0.5, color = "grey40"),
      axis.title    = element_text(size = 11),
      legend.position = "bottom",
      panel.grid.minor = element_blank()
    )
}

# =============================================================================
#  STEP 1 – Load Data
# =============================================================================
setwd("C:/repos/iSchool/BUA-345-BusinessAnalytics")
file_path = file.path("C:/repos/iSchool/BUA-345-BusinessAnalytics/Week-05/LiveSession5(1)(1).RData")
load(file_path)   # adjust path as needed

# Quick look
cat("── Dataset dimensions:", nrow(MOVIES), "rows ×", ncol(MOVIES), "cols\n")

# 0── Dataset dimensions: 1016 rows × 8 cols

cat("── Column names:", paste(names(MOVIES), collapse = ", "), "\n\n")

# ── Column names: RUNTIME, BUDGET_M, LANGUAGE, GENRE1, GENRE2, RATED, RELEASED, REVENUE/M 
print(summary(MOVIES))


# RUNTIME       BUDGET_M          LANGUAGE         GENRE1   
# Min.   : 65   Min.   :  0.00   Chinese :  7   Action   :255  
# 1st Qu.: 95   1st Qu.:  5.00   English :929   Drama    :220  
# Median :103   Median : 12.00   French  : 17   Comedy   :183  
# Mean   :106   Mean   : 18.65   Hindi   : 24   Horror   : 88  
# 3rd Qu.:114   3rd Qu.: 25.00   Japanese: 14   Crime    : 85  
# Max.   :197   Max.   :200.00   Russian : 13   Adventure: 61  
# Spanish : 12   (Other)  :124  
# GENRE2      RATED       RELEASED     REVENUE/M     
# Drama    :245   G    : 22   Fall  :314   Min.   :  0.00  
# Comedy   :156   NR   :104   Spring:245   1st Qu.:  5.00  
# Thriller :133   PG   :104   Summer:225   Median : 20.00  
# Crime    : 94   PG-13:250   Winter:232   Mean   : 44.40  
# Romance  : 93   R    :536                3rd Qu.: 60.25  
# Adventure: 71                            Max.   :586.00  
# (Other)  :224 


# =============================================================================
#  STEP 2 – Exploratory Data Analysis (EDA) Visualizations
# =============================================================================

## 2a  Distribution of Revenue (response variable) ---------------------------
p_hist <- ggplot(MOVIES, aes(x = `REVENUE/M`)) +
  geom_histogram(bins = 40, fill = "#2c7bb6", color = "white", alpha = 0.85) +
  geom_vline(aes(xintercept = mean(`REVENUE/M`)),
             color = "firebrick", linewidth = 1, linetype = "dashed") +
  annotate("text",
           x = mean(MOVIES$`REVENUE/M`) + 20, y = Inf, vjust = 2,
           label = paste0("Mean = $", round(mean(MOVIES$`REVENUE/M`), 1), "M"),
           color = "firebrick", size = 3.5) +
  scale_x_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  labs(title = "Distribution of Movie Revenue",
       subtitle = "Dashed line = mean revenue",
       x = "Revenue ($M)", y = "Count") +
  theme_lab()

## 2b  Revenue by Rating -------------------------------------------------------
p_rated <- ggplot(MOVIES, aes(x = reorder(RATED, `REVENUE/M`, median),
                               y = `REVENUE/M`, fill = RATED)) +
  geom_boxplot(outlier.alpha = 0.3, alpha = 0.8) +
  scale_y_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  scale_fill_brewer(palette = "Set2") +
  labs(title = "Revenue by Rating",
       x = "Rating", y = "Revenue ($M)") +
  guides(fill = "none") +
  theme_lab()

## 2c  Revenue by Release Season ----------------------------------------------
p_season <- ggplot(MOVIES, aes(x = reorder(RELEASED, `REVENUE/M`, median),
                                y = `REVENUE/M`, fill = RELEASED)) +
  geom_violin(alpha = 0.7, trim = FALSE) +
  geom_boxplot(width = 0.15, fill = "white", outlier.size = 0.8) +
  scale_y_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  scale_fill_brewer(palette = "Pastel1") +
  labs(title = "Revenue by Release Season",
       x = "Season", y = "Revenue ($M)") +
  guides(fill = "none") +
  theme_lab()

## 2d  Budget vs Revenue scatter ----------------------------------------------
p_budget <- ggplot(MOVIES, aes(x = BUDGET_M, y = `REVENUE/M`, color = RATED)) +
  geom_point(alpha = 0.45, size = 1.5) +
  geom_smooth(method = "lm", se = TRUE, color = "black",
              linewidth = 0.9, linetype = "dashed") +
  scale_x_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  scale_y_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  scale_color_brewer(palette = "Set1") +
  labs(title = "Budget vs. Revenue",
       subtitle = "Dashed line = overall linear trend",
       x = "Budget ($M)", y = "Revenue ($M)", color = "Rating") +
  theme_lab()

## 2e  Average Revenue by Primary Genre ---------------------------------------
genre_summary <- MOVIES %>%
  group_by(GENRE1) %>%
  summarise(
    avg_rev = mean(`REVENUE/M`),
    med_rev = median(`REVENUE/M`),
    n       = n(),
    .groups = "drop"
  ) %>%
  arrange(desc(avg_rev))

p_genre <- ggplot(genre_summary,
                  aes(x = reorder(GENRE1, avg_rev), y = avg_rev, fill = avg_rev)) +
  geom_col(alpha = 0.9) +
  geom_text(aes(label = paste0("n=", n)),
            hjust = -0.15, size = 3, color = "grey30") +
  scale_fill_gradient(low = "#abd9e9", high = "#2c7bb6") +
  scale_y_continuous(labels = dollar_format(suffix = "M", prefix = "$"),
                     expand = expansion(mult = c(0, 0.15))) +
  coord_flip() +
  labs(title = "Average Revenue by Primary Genre",
       x = NULL, y = "Average Revenue ($M)") +
  guides(fill = "none") +
  theme_lab()

## 2f  Runtime vs Revenue -----------------------------------------------------
p_runtime <- ggplot(MOVIES, aes(x = RUNTIME, y = `REVENUE/M`)) +
  geom_point(alpha = 0.3, color = "#4dac26", size = 1.4) +
  geom_smooth(method = "lm", se = TRUE, color = "darkgreen", linewidth = 1) +
  scale_y_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  labs(title = "Runtime vs. Revenue",
       x = "Runtime (minutes)", y = "Revenue ($M)") +
  theme_lab()

# Print EDA plots
grid.arrange(p_hist, p_rated, ncol = 2,
             top = "EDA – Revenue Distribution & Ratings")

grid.arrange(p_season, p_budget, ncol = 2,
             top = "EDA – Seasonal Effects & Budget Relationship")

grid.arrange(p_genre, p_runtime, ncol = 2,
             top = "EDA – Genre Averages & Runtime Effect")


# =============================================================================
#  STEP 3 – Build Best Model
#  (glmulti result) Best model uses GENRE1, GENRE2, RATED, RUNTIME, BUDGET_M
#  Run glmulti if Java is available; otherwise we use the known best model.
# =============================================================================

# ── Option A: use glmulti (requires Java + rJava installed) ──────────────────
library(glmulti)
RESULTS <- glmulti(`REVENUE/M` ~ ., data = MOVIES, fitfunction = lm, level = 1)
summary(RESULTS)$bestmodel

# $bestmodel
# [1] "`REVENUE/M` ~ 1 + GENRE1 + GENRE2 + RATED + RUNTIME + BUDGET_M"

best_formula <- summary(RESULTS)$bestmodel
best_formula

# ── Option B: use the formula glmulti identifies (used below) ────────────────
#best_formula <- "`REVENUE/M` ~ 1 + GENRE1 + GENRE2 + RATED + RUNTIME + BUDGET_M"
Best_Movie_Model <- lm(as.formula(best_formula), data = MOVIES)
Best_Movie_Model

# =============================================================================
#  STEP 4 – Model Summary
# =============================================================================
cat("\n══════════════════════════════════════════\n")
cat(" BEST MODEL SUMMARY\n")
cat("══════════════════════════════════════════\n")
print(summary(Best_Movie_Model))

# Call:
#   lm(formula = as.formula(best_formula), data = MOVIES)
# 
# Residuals:
#   Min      1Q  Median      3Q     Max 
# -87.795 -18.305  -1.987  15.607 170.540 
# 
# Coefficients:
#   Estimate Std. Error t value Pr(>|t|)    
# (Intercept)      -2.23529   11.61996  -0.192 0.847495    
# GENRE1Adventure  13.58074    5.23829   2.593 0.009667 ** 
#   GENRE1Animation  46.13146    9.39097   4.912 1.05e-06 ***
#   GENRE1Comedy     14.39031    3.70056   3.889 0.000108 ***
#   GENRE1Crime       7.36356    4.51815   1.630 0.103470    
# GENRE1Drama      -0.60339    3.47617  -0.174 0.862232    
# GENRE1Fantasy    -4.04900    7.96938  -0.508 0.611518    
# GENRE1Horror     22.39987    4.52443   4.951 8.69e-07 ***
#   GENRE1Music     -51.12658   18.92228  -2.702 0.007013 ** 
#   GENRE1Mystery    19.88882    9.40050   2.116 0.034620 *  
#   GENRE1Romance    10.87058    6.86269   1.584 0.113513    
# GENRE1SciFi      -8.82760   12.18456  -0.724 0.468937    
# GENRE1Thriller   11.77417    5.80965   2.027 0.042967 *  
#   GENRE1War       -66.50891   23.20259  -2.866 0.004240 ** 
#   GENRE2Adventure -10.12881    6.48797  -1.561 0.118806    
# GENRE2Animation -13.97946   12.56337  -1.113 0.266103    
# GENRE2Comedy    -22.14566    5.39930  -4.102 4.44e-05 ***
#   GENRE2Crime     -21.28126    5.94274  -3.581 0.000359 ***
#   GENRE2Drama     -26.20466    5.39125  -4.861 1.36e-06 ***
#   GENRE2Fantasy     0.41230    8.67284   0.048 0.962093    
# GENRE2Horror    -11.67984    6.91605  -1.689 0.091574 .  
# GENRE2Music     -19.17916    9.57055  -2.004 0.045347 *  
#   GENRE2Mystery   -20.91200    6.86506  -3.046 0.002380 ** 
#   GENRE2Romance    -9.86303    5.97996  -1.649 0.099396 .  
# GENRE2SciFi     -21.53652    7.80553  -2.759 0.005903 ** 
#   GENRE2Thriller  -17.53452    5.63375  -3.112 0.001909 ** 
#   GENRE2War       -33.16473   11.37656  -2.915 0.003636 ** 
#   RATEDNR         -26.28956    8.02617  -3.275 0.001092 ** 
#   RATEDPG         -12.52140    7.80737  -1.604 0.109081    
# RATEDPG-13      -31.14222    7.65510  -4.068 5.12e-05 ***
#   RATEDR          -29.32743    7.50409  -3.908 9.94e-05 ***
#   RUNTIME           0.35972    0.06792   5.296 1.46e-07 ***
#   BUDGET_M          2.51458    0.05711  44.027  < 2e-16 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Residual standard error: 32.31 on 983 degrees of freedom
# Multiple R-squared:  0.7562,	Adjusted R-squared:  0.7483 
# F-statistic: 95.29 on 32 and 983 DF,  p-value: < 2.2e-16

# =============================================================================
#  STEP 5 – R² Visualization
# =============================================================================
model_sum  <- summary(Best_Movie_Model)
r2         <- model_sum$r.squared
adj_r2     <- model_sum$adj.r.squared
unexplained <- 1 - r2

r2_data <- data.frame(
  portion   = c("Explained by Model", "Unexplained (Residual)"),
  value     = c(r2, unexplained),
  pct_label = c(paste0(round(r2 * 100, 1), "%"), paste0(round(unexplained * 100, 1), "%"))
)

p_r2_pie <- ggplot(r2_data, aes(x = "", y = value, fill = portion)) +
  geom_col(width = 1, color = "white", linewidth = 0.8) +
  coord_polar("y", start = 0) +
  geom_text(aes(label = pct_label),
            position = position_stack(vjust = 0.5),
            size = 5, fontface = "bold", color = "white") +
  scale_fill_manual(values = c("#2c7bb6", "#d7191c")) +
  labs(title = "Goodness of Fit – R²",
       subtitle = paste0("R² = ", round(r2, 4),
                         "   |   Adjusted R² = ", round(adj_r2, 4)),
       fill = NULL) +
  theme_void(base_size = 12) +
  theme(
    plot.title    = element_text(face = "bold", hjust = 0.5, size = 13),
    plot.subtitle = element_text(hjust = 0.5, size = 10, color = "grey40"),
    legend.position = "bottom"
  )

# R² bar comparison (R² vs Adjusted R²)
r2_bar_data <- data.frame(
  metric = c("R²", "Adjusted R²"),
  value  = c(r2, adj_r2)
)

p_r2_bar <- ggplot(r2_bar_data, aes(x = metric, y = value, fill = metric)) +
  geom_col(width = 0.5, alpha = 0.9) +
  geom_text(aes(label = round(value, 4)),
            vjust = -0.4, fontface = "bold", size = 4.5) +
  scale_y_continuous(limits = c(0, 1), labels = percent_format()) +
  scale_fill_manual(values = c("#2c7bb6", "#4dac26")) +
  labs(title = "R² vs. Adjusted R²",
       x = NULL, y = "Value") +
  guides(fill = "none") +
  theme_lab()

grid.arrange(p_r2_pie, p_r2_bar, ncol = 2,
             top = "Model Goodness of Fit – R² Statistics")

cat(sprintf("\n R²         = %.4f  (%s of variance explained)\n",
            r2, percent(r2, accuracy = 0.1)))
cat(sprintf(" Adjusted R² = %.4f\n", adj_r2))
cat(sprintf(" Unexplained = %.4f  (%s residual variance)\n\n",
            unexplained, percent(unexplained, accuracy = 0.1)))

# R²         = 0.7562  (75.6% of variance explained)
# Adjusted R² = 0.7483
# Unexplained = 0.2438  (24.4% residual variance)

# =============================================================================
#  STEP 6 – ANOVA Table and Visualization
# =============================================================================
anova_tbl <- anova(Best_Movie_Model)

cat("\n══════════════════════════════════════════\n")
cat(" ANOVA TABLE\n")
cat("══════════════════════════════════════════\n")
print(anova_tbl)

# Analysis of Variance Table
# 
# Response: REVENUE/M
# Df  Sum Sq Mean Sq  F value    Pr(>F)    
# GENRE1     13  394173   30321   29.052 < 2.2e-16 ***
#   GENRE2     13  200826   15448   14.802 < 2.2e-16 ***
#   RATED       4  223930   55983   53.640 < 2.2e-16 ***
#   RUNTIME     1  340428  340428  326.183 < 2.2e-16 ***
#   BUDGET_M    1 2023012 2023012 1938.361 < 2.2e-16 ***
#   Residuals 983 1025929    1044                       
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# Analysis of Variance Table
# 
# Response: REVENUE/M
# Df  Sum Sq Mean Sq  F value    Pr(>F)    
# GENRE1     13  394173   30321   29.052 < 2.2e-16 ***
#   GENRE2     13  200826   15448   14.802 < 2.2e-16 ***
#   RATED       4  223930   55983   53.640 < 2.2e-16 ***
#   RUNTIME     1  340428  340428  326.183 < 2.2e-16 ***
#   BUDGET_M    1 2023012 2023012 1938.361 < 2.2e-16 ***
#   Residuals 983 1025929    1044                       
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# Prepare ANOVA data (exclude Residuals row)
anova_df <- data.frame(
  Predictor = rownames(anova_tbl),
  SumSq     = anova_tbl$`Sum Sq`,
  MeanSq    = anova_tbl$`Mean Sq`,
  Fvalue    = anova_tbl$`F value`,
  Pvalue    = anova_tbl$`Pr(>F)`
)
anova_df <- anova_df[anova_df$Predictor != "Residuals", ]
anova_df$sig <- ifelse(anova_df$Pvalue < 0.001, "***",
                 ifelse(anova_df$Pvalue < 0.01,  "**",
                  ifelse(anova_df$Pvalue < 0.05, "*", "")))

# Percent of total (non-residual) Sum of Squares
total_ss <- sum(anova_df$SumSq)
anova_df$pct_ss <- anova_df$SumSq / total_ss * 100

## 6a  F-values bar chart ------------------------------------------------------
p_anova_f <- ggplot(anova_df,
                    aes(x = reorder(Predictor, Fvalue), y = Fvalue, fill = Fvalue)) +
  geom_col(alpha = 0.9) +
  geom_text(aes(label = paste0("F=", round(Fvalue, 0), " ", sig)),
            hjust = -0.1, size = 3.5, fontface = "bold") +
  scale_fill_gradient(low = "#abd9e9", high = "#d7191c") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.25))) +
  coord_flip() +
  labs(title = "ANOVA – F-Values by Predictor",
       subtitle = "Higher F = stronger influence on Revenue",
       x = NULL, y = "F-Value") +
  guides(fill = "none") +
  theme_lab()

## 6b  Sum of Squares (% contribution) ----------------------------------------
p_anova_ss <- ggplot(anova_df,
                     aes(x = reorder(Predictor, pct_ss), y = pct_ss, fill = Predictor)) +
  geom_col(alpha = 0.9) +
  geom_text(aes(label = paste0(round(pct_ss, 1), "%")),
            hjust = -0.1, size = 3.5) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.18)),
                     labels = function(x) paste0(x, "%")) +
  scale_fill_brewer(palette = "Set2") +
  coord_flip() +
  labs(title = "ANOVA – % of Sum of Squares",
       subtitle = "Share of model-explained variance by predictor",
       x = NULL, y = "% of Total SS (excl. Residuals)") +
  guides(fill = "none") +
  theme_lab()

grid.arrange(p_anova_f, p_anova_ss, ncol = 2,
             top = "ANOVA – Predictor Influence")

# Identify top predictor
top_pred <- anova_df$Predictor[which.max(anova_df$Fvalue)]
cat(sprintf("\n Most influential predictor (highest F): %s (F = %.1f)\n\n",
            top_pred, max(anova_df$Fvalue)))

# Most influential predictor (highest F): BUDGET_M (F = 1938.4)

# =============================================================================
#  STEP 7 – Goodness-of-Fit Diagnostic Plots
# =============================================================================
fitted_vals <- fitted(Best_Movie_Model)
resid_vals  <- residuals(Best_Movie_Model)
std_resids  <- rstandard(Best_Movie_Model)
actual_vals <- MOVIES$`REVENUE/M`

diag_df <- data.frame(
  fitted   = fitted_vals,
  actual   = actual_vals,
  residual = resid_vals,
  std_resid = std_resids,
  obs      = seq_along(resid_vals)
)

## 7a  Actual vs. Fitted -------------------------------------------------------
p_fit <- ggplot(diag_df, aes(x = fitted, y = actual)) +
  geom_point(alpha = 0.3, color = "#2c7bb6", size = 1.4) +
  geom_abline(slope = 1, intercept = 0,
              color = "firebrick", linewidth = 1, linetype = "dashed") +
  geom_smooth(method = "loess", se = FALSE,
              color = "darkblue", linewidth = 0.8, alpha = 0.7) +
  scale_x_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  scale_y_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  labs(title = "Actual vs. Fitted Values",
       subtitle = "Red dashed = perfect fit (y = x)",
       x = "Fitted Revenue ($M)", y = "Actual Revenue ($M)") +
  theme_lab()

## 7b  Residuals vs. Fitted ----------------------------------------------------
p_res_fit <- ggplot(diag_df, aes(x = fitted, y = residual)) +
  geom_point(alpha = 0.3, color = "#4dac26", size = 1.4) +
  geom_hline(yintercept = 0, color = "firebrick",
             linewidth = 1, linetype = "dashed") +
  geom_smooth(method = "loess", se = FALSE,
              color = "darkgreen", linewidth = 0.8) +
  scale_x_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  labs(title = "Residuals vs. Fitted",
       subtitle = "Should be randomly scattered around 0",
       x = "Fitted Values ($M)", y = "Residuals") +
  theme_lab()

## 7c  Residuals histogram -----------------------------------------------------
p_res_hist <- ggplot(diag_df, aes(x = residual)) +
  geom_histogram(aes(y = after_stat(density)),
                 bins = 40, fill = "#abd9e9", color = "white", alpha = 0.85) +
  stat_function(fun = dnorm,
                args = list(mean = mean(resid_vals), sd = sd(resid_vals)),
                color = "firebrick", linewidth = 1) +
  labs(title = "Residual Distribution",
       subtitle = "Red curve = normal distribution",
       x = "Residuals", y = "Density") +
  theme_lab()

## 7d  Q-Q Plot ----------------------------------------------------------------
p_qq <- ggplot(diag_df, aes(sample = std_resid)) +
  stat_qq(alpha = 0.4, color = "#2c7bb6", size = 1.2) +
  stat_qq_line(color = "firebrick", linewidth = 1, linetype = "dashed") +
  labs(title = "Normal Q-Q Plot",
       subtitle = "Points should follow the dashed line",
       x = "Theoretical Quantiles", y = "Standardized Residuals") +
  theme_lab()

## 7e  Scale-Location (sqrt|residuals| vs fitted) ------------------------------
p_scale_loc <- ggplot(diag_df, aes(x = fitted, y = sqrt(abs(std_resid)))) +
  geom_point(alpha = 0.3, color = "#d7191c", size = 1.4) +
  geom_smooth(method = "loess", se = FALSE,
              color = "darkred", linewidth = 0.9) +
  scale_x_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  labs(title = "Scale-Location (Homoscedasticity)",
       subtitle = "Flat line = constant variance (ideal)",
       x = "Fitted Values ($M)", y = "√|Standardized Residuals|") +
  theme_lab()

## 7f  Residual vs. Observation Index (trend check) ----------------------------
p_res_idx <- ggplot(diag_df, aes(x = obs, y = residual)) +
  geom_point(alpha = 0.25, color = "#756bb1", size = 1.2) +
  geom_hline(yintercept = 0, color = "firebrick",
             linewidth = 1, linetype = "dashed") +
  geom_smooth(method = "loess", se = FALSE,
              color = "purple4", linewidth = 0.8) +
  labs(title = "Residuals by Observation Index",
       subtitle = "Checks for systematic patterns across rows",
       x = "Observation #", y = "Residuals") +
  theme_lab()

# Print diagnostic grids
grid.arrange(p_fit, p_res_fit, ncol = 2,
             top = "Goodness-of-Fit – Fit & Residual Patterns")

grid.arrange(p_res_hist, p_qq, ncol = 2,
             top = "Goodness-of-Fit – Residual Normality")

grid.arrange(p_scale_loc, p_res_idx, ncol = 2,
             top = "Goodness-of-Fit – Variance & Index Checks")


# =============================================================================
#  STEP 8 – Prediction with Visualization
# =============================================================================
Predict_Revenue <- data.frame(
  GENRE1   = "Action",
  GENRE2   = "Adventure",
  RATED    = "PG",
  RUNTIME  = 127,
  BUDGET_M = 100
)

pred_result <- predict(Best_Movie_Model, Predict_Revenue, interval = "prediction")
pred_point  <- pred_result[1, "fit"]
pred_lower  <- pred_result[1, "lwr"]
pred_upper  <- pred_result[1, "upr"]

cat("\n══════════════════════════════════════════\n")
cat(" PREDICTION RESULTS\n")
cat("══════════════════════════════════════════\n")
cat(sprintf("  Genre1:   %s\n", Predict_Revenue$GENRE1))
cat(sprintf("  Genre2:   %s\n", Predict_Revenue$GENRE2))
cat(sprintf("  Rated:    %s\n", Predict_Revenue$RATED))
cat(sprintf("  Runtime:  %d min\n", Predict_Revenue$RUNTIME))
cat(sprintf("  Budget:   $%dM\n", Predict_Revenue$BUDGET_M))
cat(sprintf("\n  Predicted Revenue:  $%.1fM\n", pred_point))
cat(sprintf("  95%% Prediction Interval: [$%.1fM, $%.1fM]\n\n",
            pred_lower, pred_upper))

## 8a  Prediction on Revenue distribution -------------------------------------
p_pred_dist <- ggplot(MOVIES, aes(x = `REVENUE/M`)) +
  geom_histogram(bins = 40, fill = "steelblue", color = "white", alpha = 0.6) +
  geom_vline(xintercept = pred_point,
             color = "#d7191c", linewidth = 1.5) +
  annotate("rect",
           xmin = pred_lower, xmax = pred_upper,
           ymin = 0, ymax = Inf,
           fill = "#fdae61", alpha = 0.25) +
  annotate("text",
           x = pred_point + 15, y = Inf, vjust = 2,
           label = paste0("Predicted: $", round(pred_point, 1), "M"),
           color = "#d7191c", fontface = "bold", size = 4) +
  scale_x_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  labs(title = "Predicted Revenue vs. Revenue Distribution",
       subtitle = paste0("Red line = point estimate ($", round(pred_point, 1),
                         "M)  |  Shaded = 95% prediction interval"),
       x = "Revenue ($M)", y = "Count") +
  theme_lab()

## 8b  Budget vs Revenue with prediction point highlighted --------------------
p_pred_scatter <- ggplot(MOVIES, aes(x = BUDGET_M, y = `REVENUE/M`)) +
  geom_point(alpha = 0.25, color = "steelblue", size = 1.3) +
  geom_smooth(method = "lm", se = TRUE,
              color = "darkblue", linewidth = 0.9, linetype = "dashed") +
  geom_point(data = Predict_Revenue,
             aes(x = BUDGET_M, y = pred_point),
             color = "#d7191c", size = 5, shape = 18) +
  geom_errorbar(data = Predict_Revenue,
                aes(x = BUDGET_M, ymin = pred_lower, ymax = pred_upper),
                color = "#fdae61", width = 3, linewidth = 1.2,
                inherit.aes = FALSE) +
  annotate("text",
           x = Predict_Revenue$BUDGET_M + 8,
           y = pred_point,
           label = paste0("$", round(pred_point, 1), "M"),
           color = "#d7191c", fontface = "bold", size = 4) +
  scale_x_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  scale_y_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  labs(title = "Budget vs. Revenue: Prediction Highlighted",
       subtitle = "Red diamond = predicted movie  |  Orange bar = 95% prediction interval",
       x = "Budget ($M)", y = "Revenue ($M)") +
  theme_lab()

## 8c  Side-by-side: prediction vs. comparable Action/PG movies ---------------
similar <- MOVIES %>%
  filter(GENRE1 == "Action", RATED == "PG") %>%
  mutate(label = "Similar Movies")

pred_row <- data.frame(
  `REVENUE/M` = pred_point,
  label = "Prediction",
  check.names = FALSE
)
names(pred_row)[1] <- "REVENUE/M"

p_pred_compare <- ggplot(similar, aes(x = label, y = `REVENUE/M`)) +
  geom_violin(fill = "steelblue", alpha = 0.5, trim = FALSE) +
  geom_boxplot(width = 0.12, fill = "white", outlier.alpha = 0.4) +
  geom_point(data = pred_row,
             aes(x = label, y = `REVENUE/M`),
             color = "#d7191c", size = 5, shape = 18) +
  geom_errorbar(data = data.frame(label = "Prediction",
                                  ymin = pred_lower, ymax = pred_upper),
                aes(x = label, ymin = ymin, ymax = ymax),
                color = "#fdae61", width = 0.15, linewidth = 1.3,
                inherit.aes = FALSE) +
  scale_y_continuous(labels = dollar_format(suffix = "M", prefix = "$")) +
  scale_x_discrete(limits = c("Similar Movies", "Prediction")) +
  labs(title = "Predicted vs. Similar Movies (Action / PG)",
       subtitle = "Red diamond = point estimate  |  Orange bar = 95% PI",
       x = NULL, y = "Revenue ($M)") +
  theme_lab()

grid.arrange(p_pred_dist, p_pred_scatter, ncol = 2,
             top = "Prediction – Point Estimate & Uncertainty")
print(p_pred_compare)


# =============================================================================
#  STEP 9 – Coefficient Plot (Feature Importance from lm)
# =============================================================================
coef_df <- as.data.frame(summary(Best_Movie_Model)$coefficients)
coef_df$term <- rownames(coef_df)
names(coef_df) <- c("estimate", "std_error", "t_value", "p_value", "term")

# Keep only non-intercept terms; add significance
coef_df <- coef_df[coef_df$term != "(Intercept)", ]
coef_df$sig <- ifelse(coef_df$p_value < 0.001, "p<0.001",
                ifelse(coef_df$p_value < 0.01,  "p<0.01",
                 ifelse(coef_df$p_value < 0.05, "p<0.05", "p≥0.05")))
coef_df$direction <- ifelse(coef_df$estimate >= 0, "Positive", "Negative")

p_coef <- ggplot(coef_df,
                 aes(x = reorder(term, estimate),
                     y = estimate, color = sig, shape = direction)) +
  geom_point(size = 2.5) +
  geom_errorbar(aes(ymin = estimate - 1.96 * std_error,
                    ymax = estimate + 1.96 * std_error),
                width = 0.3, linewidth = 0.7) +
  geom_hline(yintercept = 0, color = "grey40",
             linetype = "dashed", linewidth = 0.8) +
  coord_flip() +
  scale_color_manual(values = c("p<0.001" = "#d7191c",
                                "p<0.01"  = "#fdae61",
                                "p<0.05"  = "#2c7bb6",
                                "p≥0.05"  = "grey60")) +
  labs(title = "Coefficient Plot with 95% Confidence Intervals",
       subtitle = "Error bars = ±1.96 × SE  |  Color = significance level",
       x = NULL, y = "Coefficient Estimate ($M change in Revenue)",
       color = "Significance", shape = "Direction") +
  theme_lab() +
  theme(legend.position = "right",
        axis.text.y = element_text(size = 8))

print(p_coef)


# =============================================================================
#  STEP 10 – Summary Report (console)
# =============================================================================
cat("\n")
cat("╔══════════════════════════════════════════════════════╗\n")
cat("║           MODEL PERFORMANCE SUMMARY                 ║\n")
cat("╠══════════════════════════════════════════════════════╣\n")
cat(sprintf("║  R²                   = %-6.4f  (%.1f%% explained)  ║\n",
            r2, r2 * 100))
cat(sprintf("║  Adjusted R²          = %-6.4f                    ║\n", adj_r2))
cat(sprintf("║  Unexplained variance = %-6.4f  (%.1f%% residual)   ║\n",
            unexplained, unexplained * 100))
cat(sprintf("║  Most influential var = %-22s       ║\n", top_pred))
cat("╠══════════════════════════════════════════════════════╣\n")
cat(sprintf("║  Prediction (Action/PG/127min/$100M budget)          ║\n"))
cat(sprintf("║    Point estimate     = $%-6.1fM                   ║\n", pred_point))
cat(sprintf("║    95%% PI lower      = $%-6.1fM                   ║\n", pred_lower))
cat(sprintf("║    95%% PI upper      = $%-6.1fM                   ║\n", pred_upper))
cat("╚══════════════════════════════════════════════════════╝\n\n")

# R²                   = 0.7562  (75.6% explained) 
# Adjusted R²          = 0.7483
# Unexplained variance = 0.2438  (24.4% residual) 
