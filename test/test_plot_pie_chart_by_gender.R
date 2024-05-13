suppressPackageStartupMessages({
  library(testthat)
  library(ggplot2)
  library(dplyr)
  library(stringr)
  library(grDevices)
})

# Set root directory correctly with here
here::i_am("README.md")

# Load the function script
source_path <- here::here("src", "plot_category_proportions_by_gender.R")
source(source_path)

# Mock data for testing
set.seed(123)
gender <- sample(c("Male", "Female"), 100, replace = TRUE)
study_time <- sample(c("Short", "Medium", "Long"), 100, replace = TRUE)
student_data <- data.frame(gender, study_time)

# Start test suite
test_that("plot_category_proportions_by_gender function works correctly", {
  
  # Test basic functionality when not saving
  plot <- plot_category_proportions_by_gender(student_data, "study_time", custom_theme = theme_minimal())
  expect_is(plot, "ggplot")
  
  # Test saving functionality
  temp_dir <- tempdir()
  saved_path <- plot_category_proportions_by_gender(student_data, "study_time", custom_theme = theme_minimal(), save = TRUE, figure_path = temp_dir)
  expect_true(file.exists(saved_path))
  
  # Test for missing arguments when saving
  expect_error(plot_category_proportions_by_gender(student_data, "study_time", custom_theme = theme_minimal(), save = TRUE),
               "figure_path must be specified if save is TRUE.")
  
  # Test for non-existent category
  expect_error(plot_category_proportions_by_gender(student_data, "invalid_category", custom_theme = theme_minimal()), 
               "The specified category is not a column in the provided data frame.")
})

# End test suite


