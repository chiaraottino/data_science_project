# ==============================================================================
# Script for Preparing, Analyzing, and Visualizing Random Forest Regression Models
# ==============================================================================

# ----- Load required libraries ------------------------------------------------
suppressPackageStartupMessages({
  library(randomForest)  # For random forest models
  library(tidymodels)    # For modeling and validation
  library(here)          # For path management
  library(vip)           # For variable importance plots
  library(ggplot2)       # For plotting
  library(viridis)       # For color palettes
  library(scales)        # For formatting scales
})
  
# ----- Set root directory correctly with here ---------------------------------
here::i_am("README.md")  # Ensures that all paths are relative to the project root

# ----- Source all functions from the source folder ----------------------------
source_path <- here::here("src")  # Path to the folder containing additional R scripts
files <- list.files(path = source_path, pattern = "\\.R$", full.names = TRUE)
for (file in files) {
  source(file)  # Load each R script to access custom functions
}

# ----- Load the train and test datasets ---------------------------------------
train_data_with_grades <- readRDS(here("data", "derived_data", "train_data_with_grades.rds"))
test_data_with_grades <- readRDS(here("data", "derived_data", "test_data_with_grades.rds"))
train_data_without_grades <- readRDS(here("data", "derived_data", "train_data_without_grades.rds"))
test_data_without_grades <- readRDS(here("data", "derived_data", "test_data_without_grades.rds"))

# ----- Model Specification and Fitting ----------------------------------------
rf_spec <- rand_forest(trees = 500, mode = "regression") %>%
  set_engine("randomForest") %>%
  set_mode("regression")

# Fit models with and without high school grades
rf_fit_with_grades <- rf_spec %>%
  fit(college_mark ~ ., data = train_data_with_grades)
rf_fit_without_grades <- rf_spec %>%
  fit(college_mark ~ ., data = train_data_without_grades)

# ----- Model Evaluation and Visualization -------------------------------------
# Calculate and print metrics for both models
metrics <- metric_set(rmse, rsq)
rf_with_grades_metrics <- calculate_model_metrics(test_data_with_grades, rf_fit_with_grades, metrics, "college_mark")
rf_without_grades_metrics <- calculate_model_metrics(test_data_without_grades, rf_fit_without_grades, metrics, "college_mark")

# Generate and save VIP for models with and without grades
figure_path_with_grades <- create_vip_plot(rf_fit_with_grades, model_name="rf_with_grades", num_features = 10, save = TRUE, figure_path = here("figures"))
figure_path_without_grades <-create_vip_plot(rf_fit_without_grades, model_name="rf_without_grades", num_features = 10, save = TRUE, figure_path = here("figures"))
