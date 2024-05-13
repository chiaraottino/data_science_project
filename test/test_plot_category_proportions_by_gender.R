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

# Define a mock dataset and theme to use in testing
data <- data.frame(
  gender = rep(c("Male", "Female"), each = 50),
  preference = sample(c("A", "B"), 100, replace = TRUE)
)

custom_theme <- theme_minimal() +
  theme(text = element_text(family = "Arial", color = "#333333"),
        plot.title = element_text(face = "bold", size = 14),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 10),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 10),
        panel.grid.major = element_line(color = "gray", linewidth = 0.5),
        panel.grid.minor = element_blank(),
        legend.position = "right")

test_that("plot_category_proportions_by_gender works correctly", {
  p <- plot_category_proportions_by_gender(data, "preference", custom_theme, save = FALSE)
  
  # Check if it returns a ggplot
  expect_is(p, "ggplot")
  
})

test_that("plot_category_proportions_by_gender saves plot correctly", {
  temp_dir <- tempdir()
  
  # Call the function with saving option
  returned_path <- plot_category_proportions_by_gender(data, "preference", custom_theme, save = TRUE, figure_path = temp_dir)
  
  # Check if file was created
  expect_true(file.exists(returned_path))
  
})
