# ==============================================================================
# Script for Preparing and Visualizing the Decision Tree Models
# ==============================================================================

# ----- Load required libraries ------------------------------------------------
suppressPackageStartupMessages({
  library(rpart)
  library(MASS)            # For statistical methods
  library(tidyr)           # For data tidying
  library(here)            # For path management
  library(rpart.plot)      # For plotting decision trees
  library(stringr)         # For string operations
  library(viridisLite)
  library(viridis)
  library(tidymodels)      # For modeling and validation
})

# ----- Set root directory correctly with here ---------------------------------
here::i_am("README.md")  # Ensures that all paths are relative to the project root

# ----- Source all functions from the source folder ----------------------------
source_path <- here::here("src")  # Path to the folder containing additional R scripts
files <- list.files(path = source_path, pattern = "\\.R$", full.names = TRUE)
for (file in files) {
  source(file)  # Load each R script to access custom functions
}

# ----- Load the cleaned and corrected dataset ---------------------------------
file_path <- here("data", "derived_data", "corrected_student_data.rds")
student_data <- readRDS(file_path)  # Read the dataset from an RDS file

# ----- Data Selection for Regression Model ------------------------------------
# Select the columns to use for the regression analysis
selected_vars <- c("college_mark", "mark_12th", "mark_10th", "gender", "study_time", 
                   "salary_expectation", "department", "career_willingness", "social_media_time", 
                   "travel_time", "stress_level", "financial_status", 
                   "body_mass_index", "certification", "hobbies", 
                   "study_preference", "like_degree", "part_time_job")
regression_data <- student_data %>% dplyr::select(all_of(selected_vars))

# Apply friendly formatting to column names
names(regression_data)[-c(1)] <- str_to_title(gsub("_", " ", names(regression_data[-c(1)])))

# ----- Data Splitting into Training and Testing Sets ---------------------------
set.seed(123)
data_split <- initial_split(regression_data, prop = 0.8)
train_data_with_grades <- training(data_split)
test_data_with_grades <- testing(data_split)

# Remove grade columns for models that predict without prior grades
train_data_without_grades <- train_data_with_grades %>% dplyr::select(-"Mark 12th", -"Mark 10th")
test_data_without_grades <- test_data_with_grades %>% dplyr::select(-"Mark 12th", -"Mark 10th")

# ----- Save the Train and Test Datasets ---------------------------------------
saveRDS(train_data_with_grades, here("data", "derived_data", "train_data_with_grades.rds"))
saveRDS(test_data_with_grades, here("data", "derived_data", "test_data_with_grades.rds"))
saveRDS(train_data_without_grades, here("data", "derived_data", "train_data_without_grades.rds"))
saveRDS(test_data_without_grades, here("data", "derived_data", "test_data_without_grades.rds"))

# ----- Model Specification and Fitting ----------------------------------------
# Create a decision tree model specification
tree_spec <- decision_tree() %>%
  set_engine("rpart", model = TRUE) %>%
  set_mode("regression")

# Fit models with and without high school grades
tree_fit_with_grades <- tree_spec %>%
  fit(college_mark ~ ., data = train_data_with_grades)

tree_fit_without_grades <- tree_spec %>%
  fit(college_mark ~ ., data = train_data_without_grades)


# ----- Model Evaluation and Visualization -------------------------------------
# Calculate and print metrics for both models
metrics <- metric_set(rmse, rsq)
tree_with_grades_metrics <- calculate_model_metrics(test_data_with_grades, tree_fit_with_grades, metrics, "college_mark")
tree_without_grades_metrics <- calculate_model_metrics(test_data_without_grades, tree_fit_without_grades, metrics, "college_mark")

# Plot and save the decision trees
plot_tree(tree_fit_with_grades, "tree_fit_with_grades", save = TRUE, here("figures"), cex=1.3)
plot_tree(tree_fit_without_grades, "tree_fit_without_grades", save = TRUE, here("figures"), cex=1.3)

# Generate and save VIP for models with and without grades
figure_path_with_grades <- create_vip_plot(tree_fit_with_grades, model_name="tree_fit_with_grades", save = TRUE, figure_path= here("figures"))
figure_path_without_grades <- create_vip_plot(tree_fit_without_grades,  model_name="tree_fit_without_grades", save = TRUE, figure_path= here("figures"))


