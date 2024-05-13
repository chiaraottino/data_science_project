suppressPackageStartupMessages({
  library(testthat)
  library(ggplot2)
  library(dplyr)
  library(viridisLite)
  library(viridis)
  library(scales)
})

# Set root directory correctly with here
here::i_am("README.md")

# Load the function script
source_path <- here::here("src", "create_vip_plot.R")
source(source_path)

# Start test suite
test_that("create_vip_plot function works correctly", {
  
  # Mock model object for testing
  set.seed(123)
  mock_model <- lm(Sepal.Length ~ ., data = iris)
  
  # Test basic functionality
  vip_plot <- create_vip_plot(mock_model, num_features = 3)
  expect_is(vip_plot, "ggplot")
  
  # Test saving functionality
  temp_dir <- tempdir()
  saved_path <- create_vip_plot(mock_model, "mock_model", num_features = 3, save = TRUE, figure_path = temp_dir)
  expect_true(file.exists(saved_path))
})

# End test suite
