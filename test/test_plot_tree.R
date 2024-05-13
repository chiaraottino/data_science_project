suppressPackageStartupMessages({
library(testthat)
library(rpart)
library(rpart.plot)
})

# Set root directory correctly with here
here::i_am("README.md")

# Load the function script
source_path <- here::here("src", "plot_tree.R")
source(source_path)

# Create a mock decision tree using the rpart package on the iris dataset
data(iris)
tree_fit <- list(fit = rpart(Species ~ Sepal.Length + Sepal.Width, data = iris))

# Define the tests
test_that("plot_tree generates and prints a plot", {
  # Capture the output to test if a plot is created without errors
  expect_silent(plot_tree(tree_fit))
})

test_that("plot_tree saves the plot correctly", {
  # Create a temporary directory to save the plot
  temp_dir <- tempdir()
  temp_path <- file.path(temp_dir, "decision_tree_plot.png")
  
  # Call the function with saving option
  plot_path <- plot_tree(tree_fit, "tree_model_test", save = TRUE, figure_path = temp_dir)

  
  # Check if file was created
  expect_true(file.exists(plot_path))
  
  # Optionally clean up by removing the test file
  unlink(temp_path)
})


