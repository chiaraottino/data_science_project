suppressPackageStartupMessages({
  library(ggplot2)
  library(viridisLite)
  library(viridis)  
  library(scales) 
})

#' Create and Optionally Save a Variable Importance Plot
#'
#' This function calculates the variable importance from a model and creates a plot
#' using a continuous color palette. The plot can be saved to a specified path if desired.
#'
#' @param model A model object from which variable importance will be calculated.
#' @param model_name A string that describes the model, used in the filename when saving the plot.
#' @param num_features The number of features to show in the plot.
#' @param save Logical, whether to save the plot or not (default = FALSE).
#' @param figure_path The directory where the plot should be saved, required if save is TRUE.
#' @return The plot object if not saved, or the path where the plot was saved if saved.
#' @examples
#' # Assuming 'model' is a fitted model object
#' create_vip_plot(model, num_features = 10, save = TRUE, figure_path = "path/to/save")
create_vip_plot <- function(model, model_name = NULL, num_features = 10, save = FALSE, figure_path = NULL) {
  # Calculate variable importance
  importance_data <- vip::vi(model, num_features = num_features)
  
  # Rank the variables based on importance
  importance_data <- importance_data %>%
    dplyr::mutate(Rank = rank(-Importance))
  
  # Create the plot
  p <- ggplot(importance_data, aes(x = reorder(Variable, Importance), y = Importance, fill = Rank)) +
    geom_col(show.legend = FALSE) +
    coord_flip() +
    scale_fill_gradientn(colors = viridis_pal(option = "D")(100)) +  # Using a continuous gradient
    labs(title = "Variable Importance Plot",
         x = "Variables",
         y = "Importance") +
    theme_minimal() +
    theme(text = element_text(size = 12),
          plot.title = element_text(hjust = 0.5, face = "bold"),
          axis.title = element_text(size = 10),
          axis.text = element_text(size = 9))
  
  # Print the plot 
  print(p)
  
  if (save) {
    if (is.null(figure_path)) {
      stop("figure_path must be specified if save is TRUE.")
    }
    file_path <- paste0(figure_path, "/", model_name, "_vip_plot.png")
    ggsave(file_path, plot = p, device = "png", width = 10, height = 6, units = "in")
    return(file_path)
  } else {
    return(p)
  }
}
