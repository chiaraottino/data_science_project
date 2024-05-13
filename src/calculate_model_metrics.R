suppressPackageStartupMessages({
  library(dplyr)
  library(parsnip)
  library(yardstick)  # Assuming using yardstick for metric_set
})


#' Calculate and Print Model Performance Metrics for Decision Tree and Regression Models
#'
#' This function predicts outcomes using decision tree or regression models from the tidymodels framework,
#' appends these predictions to the test dataset, and calculates specified performance metrics.
#'
#' @param test_data A dataframe containing the test data.
#' @param model A trained model object from tidymodels compatible with `predict()`.
#' @param metrics A yardstick metric set to calculate various performance metrics.
#' @param target_variable The name of the target variable in `test_data`.
#' @return A dataframe containing the calculated metrics.
#' @examples
#' # Assuming model and test_data are already defined and appropriate for the model type
#' results <- calculate_model_metrics(test_data, model, metric_set(rmse, rsq), "outcome")
#' @import dplyr
#' @import parsnip
#' @import yardstick
#' @export
calculate_model_metrics <- function(test_data, model, metrics, target_variable) {
  # Predict on the test data
  predictions <- predict(model, new_data = test_data) %>%
    dplyr::pull(.pred)  # Adjust based on your model's predict() output column name
  
  # Calculate the metrics using the specified target variable
  results <- test_data %>%
    dplyr::mutate(predictions = predictions) %>%
    metrics(truth = !!rlang::sym(target_variable), estimate = predictions)
  
  # Return results
  return(results)
}

