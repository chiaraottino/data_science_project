#' Plot and Optionally Save a Decision Tree with Dynamic Naming
#'
#' @param tree_fit An object containing a fitted tree model (expected to have a 'fit' attribute).
#' @param model_name A string that describes the model, used in the filename when saving the plot.
#' @param save Logical, whether to save the plot or not (default = FALSE).
#' @param figure_path The directory where the plot should be saved, required if save is TRUE.
#' @param cex Controls the size of the labels, set to 0.75 by default.
#' @return Doesnt return anything.
plot_tree <- function(tree_fit, model_name = NULL, save = FALSE, figure_path = NULL, cex = 0.75) {
  split.fun <- function(x, labs, digits, varlen, faclen) {
    labs <- gsub(" = ", ":\n", labs)
    labs <- gsub(" < ", ":\n<", labs)
    labs <- gsub(" > ", ":\n>", labs)
    labs <- gsub(" >= ", ":\n>=", labs)
    labs <- gsub(" <= ", ":\n<=", labs)
    labs
  }

  if (save) {
    if (is.null(figure_path) || is.null(model_name)) {
      stop("Both 'figure_path' and 'model_name' must be specified if save is TRUE.")
    }
    # Construct the file path with model name included
    file_path <- paste0(figure_path, "/", model_name, "_plot.png")
    # Open PNG device
    png(file_path, width = 1200, height = 700)
    # Generate the plot inside the PNG device
    rpart.plot(tree_fit$fit, type = 2, extra = 100, under = TRUE, cex = cex, box.palette = "auto", 
               fallen.leaves = TRUE, split.fun = split.fun, branch.lty = 3)
    # Close the PNG device
    dev.off()
  } 
  # Print the plot outside the saving condition
  rpart.plot(tree_fit$fit, type = 2, extra = 100, under = TRUE, cex = 0.75, box.palette = "auto", 
             fallen.leaves = TRUE, split.fun = split.fun, branch.lty = 3)
  if (save) {
    return(file_path)
  } 
  
}
