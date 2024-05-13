suppressPackageStartupMessages({
library(testthat)
library(dplyr)
library(parsnip)
library(yardstick)
})

# Set root directory 
here::i_am("README.md")  


# Load the function script
source_path <- here::here("src", "calculate_model_metrics.R")
source(source_path)

# Sample data
set.seed(123)
test_data <- data.frame(
  x1 = rnorm(100),
  x2 = rnorm(100),
  outcome = rnorm(100)
)

# Train a model (just for testing purposes, you might have a different way to train your model)
model <- decision_tree() %>%
  set_engine("rpart", model = TRUE) %>%
  set_mode("regression")

model_fit <- model %>%
  fit(outcome ~ ., data = test_data)

# Test cases
test_that("calculate_model_metrics calculates metrics correctly", {
  # Test with rmse and rsq metrics
  result <- calculate_model_metrics(test_data, model_fit, metric_set(rmse, rsq), "outcome")
  
  # Check if all expected columns are present
  expect_true(all(c(".metric", ".estimator", ".estimate") %in% colnames(result)))
  
  # Check if all .metric values are rmse or rsq
  expect_true(all(result$.metric %in% c("rmse", "rsq")))
  
  # Check if .estimator column contains "standard"
  expect_true(all(result$.estimator == "standard"))
  
  # Check if .estimate column contains numeric values
  expect_true(all(is.numeric(result$.estimate)))
})
