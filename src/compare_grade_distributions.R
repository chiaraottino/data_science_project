suppressPackageStartupMessages({
  library(tidyr)
  library(dplyr)
  library(stats)
})

#' Compare Grade Distributions Across Different Educational Levels
#'
#' This function performs a Kruskal-Wallis test to check for differences in grade distributions
#' across specified educational levels. If the test indicates significant differences, it conducts
#' pairwise Wilcoxon tests to compare each pair of grade levels.
#'
#' @param data A dataframe containing the grades.
#' @param columns A vector of column names in 'data' that contain the grades to be compared.
#' @import dplyr
#' @import tidyr
#' @import stats
#' @return None, prints the results directly to the console.
#' @examples
#' data <- data.frame(grade10 = rnorm(50, 75, 10),
#'                    grade12 = rnorm(50, 77, 10),
#'                    college = rnorm(50, 80, 10))
#' compare_grade_distributions(data, c('grade10', 'grade12', 'college'))
#' @export
compare_grade_distributions <- function(data, columns) {
  # Verify the specified columns are in the dataframe
  if (!all(columns %in% names(data))) {
    stop("Data does not contain all the specified grade columns.")
  }
  
  # Restructure data for analysis
  data_long <- data %>%
    dplyr::select(tidyselect::all_of(columns)) %>%
    tidyr::pivot_longer(cols = everything(), names_to = "grade_level", values_to = "grade")
  
  # Perform Kruskal-Wallis Test
  kruskal_test <- kruskal.test(grade ~ grade_level, data = data_long)
  cat("\nKruskal-Wallis Test Results:\n")
  cat("Statistic: ", round(kruskal_test$statistic, 2), "\n")
  cat("P-value: ", format.pval(kruskal_test$p.value), "\n")
  
  # Perform pairwise comparisons if significant
  if (kruskal_test$p.value < 0.05) {
    cat("Conclusion: Significant differences found across grade levels.\n")
    cat("Performing pairwise comparisons...\n")
    
    # Corrected method to generate pair names
    pairs <- combn(columns, 2, simplify = FALSE)
    pair_names <- apply(combn(columns, 2), 2, function(x) paste(x[1], "vs", x[2]))
    
    for (i in seq_along(pairs)) {
      pair <- pairs[[i]]
      pair_name <- pair_names[i]
      test_result <- wilcox.test(data_long$grade[data_long$grade_level == pair[1]], 
                                 data_long$grade[data_long$grade_level == pair[2]],
                                 exact = FALSE, paired = FALSE)
      
      cat("\nPairwise Comparison: ", pair_name, "\n")
      cat("Wilcoxon rank sum test\n")
      cat("Statistic: ", round(test_result$statistic, 2), "\n")
      cat("P-value: ", format.pval(test_result$p.value), "\n")
      
      if (test_result$p.value < 0.05) {
        cat("Conclusion: Significant difference between ", pair[1], " and ", pair[2], ".\n")
      } else {
        cat("Conclusion: No significant difference between ", pair[1], " and ", pair[2], ".\n")
      }
    }
  } else {
    cat("Conclusion: No significant differences found across grade levels.\n")
  }
}

