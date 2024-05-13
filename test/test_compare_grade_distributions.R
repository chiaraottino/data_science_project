suppressPackageStartupMessages({
  library(testthat)
  library(dplyr)
  library(tidyr)
  library(stats)
})

# ----- Set root directory correctly with here ---------------------------------
here::i_am("README.md")  # Ensures that all paths are relative to the project root

# Load the function script
source_path <- here::here("src", "compare_grade_distributions.R")
source(source_path)

# Test data setup
test_data <- data.frame(
  grade10 = rnorm(50, 75, 10),
  grade12 = rnorm(50, 77, 10),
  college = rnorm(50, 80, 10)
)

# Test that the function correctly handles missing columns
test_that("Function handles missing columns", {
  expect_error(compare_grade_distributions(test_data, c("grade10", "nonexistent_column")),
               "Data does not contain all the specified grade columns.")
})

# Test that correct statistical output is produced
test_that("Function prints correct statistical information", {
  # Capture the output to check its content
  output <- capture.output(compare_grade_distributions(test_data, c("grade10", "grade12", "college")))
  
  # Print captured output for debugging
  cat("Captured Output:\n", paste(output, collapse = "\n"), "\n")
  
  # Check for key phrases in the output that indicate correct function operation
  expect_true(any(grepl("Kruskal-Wallis Test Results:", output)), "Should display Kruskal-Wallis test results")
  expect_true(any(grepl("Wilcoxon rank sum test", output)), 
              "Should display pairwise comparison results")
})


