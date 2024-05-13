suppressPackageStartupMessages({
  library(testthat)
  library(dplyr)
  library(tidyr)
  library(stats)
  library(stringr)
})
  
# ----- Set root directory correctly with here ---------------------------------
here::i_am("README.md")  # Ensures that all paths are relative to the project root

# Source the function using 'here' to specify the path
source_path <- here::here("src", "analyze_grades_by_gender.R")
source(source_path)




test_that("Function handles a basic case correctly", {
  data <- data.frame(
    gender = c("Male", "Female", "Male", "Female"),
    mark_10th = c(85, 88, 78, 92),
    mark_12th = c(82, 90, 77, 89),
    college_mark = c(75, 95, 70, 88)
  )
  expect_output(print(analyze_grades_by_gender(data, c("mark_10th", "mark_12th", "college_mark"))),
                "Conclusion")
})


test_that("Function handles non-normal distributions correctly", {
  set.seed(123)
  data <- data.frame(
    gender = rep(c("Male", "Female"), each = 50),
    mark_10th = c(rnorm(50, mean = 50, sd = 5), runif(50, min = 45, max = 55))  # Mixed distribution
  )
  expect_output(print(analyze_grades_by_gender(data, c("mark_10th"))),
                "Using Mann-Whitney U test due to non-normality")
})

# Add more tests as needed for other scenarios, like empty data, all male/female, large datasets, etc.



