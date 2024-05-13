suppressPackageStartupMessages({
  library(dplyr)
  library(tidyr)
  library(stats)
  library(stringr)
})

#' Analyze Grade Differences by Gender for Specified Grade Levels
#'
#' This function prepares data from a wide format, performs a normality test on grades for each gender,
#' and depending on the result, uses a T-test or a Mann-Whitney U test to analyze grade differences
#' between genders for the specified grade levels.
#'
#' @param data A dataframe containing 'gender' and various grade level columns.
#' @param grade_levels A character vector of column names in 'data' that contain the grades to be compared.
#' @import dplyr
#' @import tidyr
#' @import stats
#' @import stringr
#' @return None, prints the results directly to the console.
#' @examples
#' student_data <- data.frame(gender = c("Male", "Female", "Male", "Female"),
#'                            mark_10th = c(85, 88, 78, 92),
#'                            mark_12th = c(82, 90, 77, 89),
#'                            college_mark = c(75, 95, 70, 88))
#' analyze_grades_by_gender(student_data, c("mark_10th", "mark_12th", "college_mark"))
#' @export
analyze_grades_by_gender <- function(data, grade_levels) {
  data_long <- data %>%
    dplyr::select(gender, tidyselect::all_of(grade_levels)) %>%
    tidyr::pivot_longer(cols = tidyselect::all_of(grade_levels), names_to = "grade_level", values_to = "grade")
  
  # Loop through each grade level to analyze
  for (level in grade_levels) {
    cat("\n\nAnalysis of", str_to_title(gsub("_", " ", level)), "\n")
    cat("--------------------------------------------------\n")
    
    # Filter data for the current level
    data_level <- data_long %>% filter(grade_level == level)
    
    # Conduct Normality Tests
    cat("Normality Tests:\n")
    if (sum(data_level$gender == "Male") >= 3) {
      shapiro_test_male <- shapiro.test(data_level$grade[data_level$gender == "Male"])
      cat("Male: W = ", round(shapiro_test_male$statistic, 4), 
          ", p-value = ", format.pval(shapiro_test_male$p.value), "\n")
    } else {
      cat("Insufficient data for Male normality test\n")
    }
    
    if (sum(data_level$gender == "Female") >= 3) {
      shapiro_test_female <- shapiro.test(data_level$grade[data_level$gender == "Female"])
      cat("Female: W = ", round(shapiro_test_female$statistic, 4), 
          ", p-value = ", format.pval(shapiro_test_female$p.value), "\n")
    } else {
      cat("Insufficient data for Female normality test\n")
    }
    
    # Decide on the appropriate statistical test based on the results of the Shapiro tests
    if (exists("shapiro_test_male") && exists("shapiro_test_female") && shapiro_test_male$p.value > 0.05 && shapiro_test_female$p.value > 0.05) {
      cat("\nUsing T-test due to normality in both groups:\n")
      test_result <- t.test(grade ~ gender, data = data_level)
    } else {
      cat("\nUsing Mann-Whitney U test due to non-normality or insufficient data:\n")
      test_result <- wilcox.test(grade ~ gender, data = data_level, exact = FALSE)
    }
    
    # Output the results of the chosen test
    cat("Test result: ", test_result$method, "\n")
    cat("W or t statistic = ", round(test_result$statistic, 2), 
        ", p-value = ", format.pval(test_result$p.value), "\n")
    
    # Draw conclusions based on the p-value
    if (test_result$p.value < 0.05) {
      cat("Conclusion: There is a statistically significant difference in grades between genders at", str_to_title(gsub("_", " ", level)), "\n")
    } else {
      cat("Conclusion: There is no statistically significant difference in grades between genders at", str_to_title(gsub("_", " ", level)), "\n")
    }
  }
}

