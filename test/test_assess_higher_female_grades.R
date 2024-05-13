suppressPackageStartupMessages({
library(testthat)
library(dplyr)
library(tidyr)
library(stats)
library(here)
})

# ----- Set root directory correctly with here ---------------------------------
here::i_am("README.md")  # Ensures that all paths are relative to the project root


# Source the function using 'here' to specify the path
source(here("src", "assess_higher_female_grades.R"))


test_that("Test correct processing with balanced data", {
  data <- data.frame(
    gender = c("Male", "Female", "Male", "Female", "Male", "Female"),
    mark_10th = c(85, 88, 78, 92, 84, 90),
    mark_12th = c(82, 90, 77, 89, 85, 87),
    college_mark = c(75, 95, 70, 88, 83, 91)
  )
  expect_output(print(assess_higher_female_grades(data, c("mark_10th", "mark_12th", "college_mark"))),
                "Conclusion")
})

test_that("Test with non-normal distributions", {
  set.seed(123)
  data <- data.frame(
    gender = rep(c("Male", "Female"), each = 50),
    mark_10th = c(rnorm(50, mean = 70, sd = 10), rnorm(50, mean = 75, sd = 10))
  )
  expect_output(print(assess_higher_female_grades(data, c("mark_10th"))),
                "female grades are higher")
})

test_that("Test function handles small sample sizes", {
  data <- data.frame(
    gender = c("Male", "Female", "Male"),
    mark_10th = c(85, 88, 78)
  )
  expect_output(print(assess_higher_female_grades(data, c("mark_10th"))),
                "Conclusion")
})

test_that("Test function with skewed data", {
  data <- data.frame(
    gender = c("Male", "Female", "Male", "Female", "Male"),
    mark_10th = c(50, 90, 52, 95, 51)
  )
  expect_output(print(assess_higher_female_grades(data, c("mark_10th"))),
                "female grades are higher")
})

test_that("Test handling of identical data", {
  data <- data.frame(
    gender = c("Male", "Female", "Male", "Female"),
    mark_10th = c(85, 85, 85, 85)
  )
  expect_output(print(assess_higher_female_grades(data, c("mark_10th"))),
                "no statistically significant evidence")
})



