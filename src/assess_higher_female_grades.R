suppressPackageStartupMessages({
  library(tidyr)
  library(dplyr)
  library(stats)
})

#' Test if Female Grades Are Higher for Specified Grade Levels
#'
#' This function reshapes the data from wide to long format and performs a Mann-Whitney U test to determine
#' if female grades are statistically higher than male grades for the specified grade levels.
#'
#' @param data A dataframe containing 'gender' and various grade level columns.
#' @param grade_levels A character vector of column names in 'data' that contain the grades to be analyzed.
#' @import dplyr
#' @import tidyr
#' @import stats
#' @return None, prints the results directly to the console.
#' @examples
#' student_data <- data.frame(
#'   gender = c("Male", "Female", "Male", "Female", "Male", "Female"),
#'   mark_10th = c(85, 88, 78, 92, 84, 90),
#'   mark_12th = c(82, 90, 77, 89, 85, 87),
#'   college_mark = c(75, 95, 70, 88, 83, 91))
#' assess_higher_female_grades(student_data, c("mark_10th", "mark_12th", "college_mark"))
#' @export
assess_higher_female_grades <- function(data, grade_levels) {
  library(dplyr)
  library(tidyr)
  library(stats)
  
  data_long <- data %>%
    dplyr::select(gender, tidyselect::all_of(grade_levels)) %>%
    tidyr::pivot_longer(cols = tidyselect::all_of(grade_levels), names_to = "grade_level", values_to = "grade")
  
  for (level in grade_levels) {
    cat("\n\nTesting if female grades are higher for the variable", level, "\n")
    cat("--------------------------------------------------\n")
    
    data_level <- filter(data_long, grade_level == level)
    
    # Perform Mann-Whitney U test
    test_result <- wilcox.test(grade ~ gender, data = data_level,
                               alternative = "greater", # 'greater' tests if the first group (female) is higher
                               exact = FALSE)
    
    # Output the test results
    cat("Mann-Whitney U Test Results:\n")
    cat("U statistic = ", round(test_result$statistic, 2), 
        ", p-value = ", format.pval(test_result$p.value), "\n")
    
    # Conclusion based on p-value
    if (test_result$p.value < 0.05) {
      cat("Conclusion: There is statistically significant evidence that female grades are higher for", level, ".\n")
    } else {
      cat("Conclusion: There is no statistically significant evidence that female grades are higher for", level, ".\n")
    }
  }
}

