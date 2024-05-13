suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(stringr)
  library(grDevices)
})


#' Plot and Optionally Save Proportions by Gender for a Given Category
#'
#' This function creates a bar plot showing the proportions of a specified category,
#' split by gender. The plot is customized based on the provided ggplot2 theme.
#' It can optionally save the plot to a specified path if desired.
#'
#' @param data A dataframe containing the data to be plotted.
#' @param category The name of the categorical column to plot.
#' @param custom_theme A ggplot2 theme object to customize the plot aesthetics.
#' @param save Logical, whether to save the plot or not.
#' @param figure_path The file path where the plot should be saved, required if save is TRUE.
#' @import ggplot2
#' @import dplyr
#' @import grDevices
#' @return The plot object if not saved, or the path where the plot was saved if saved.
#' @examples
#' custom_theme <- theme_minimal() +
#'   theme(text = element_text(family = "Arial", color = "#333333"),
#'         plot.title = element_text(face = "bold", size = 14),
#'         legend.title = element_text(size = 12),
#'         legend.text = element_text(size = 10),
#'         axis.title = element_text(size = 12),
#'         axis.text = element_text(size = 10),
#'         panel.grid.major = element_line(color = "gray", linewidth = 0.5),
#'         panel.grid.minor = element_blank(),
#'         legend.position = "right")
#' # To display:
#' plot_category_proportions_by_gender(student_data, "study_time", custom_theme)
#' # To save:
#' plot_category_proportions_by_gender(student_data, "study_time", custom_theme, save = TRUE, figure_path = "path/to/save")
plot_category_proportions_by_gender <- function(data, category, custom_theme, save = FALSE, figure_path = NULL) {
  if (!category %in% names(data)) {
    stop("The specified category is not a column in the provided data frame.")
  }
  
  data <- data %>%
    group_by(gender, .data[[category]]) %>%
    summarise(count = n(), .groups = 'drop') %>%
    group_by(gender) %>%
    mutate(proportion = count / sum(count)) %>%
    ungroup()
  
  p <- ggplot(data, aes(x = !!sym(category), y = proportion, fill = gender)) +
    geom_bar(stat = "identity", position = "dodge", color = "black", alpha = 0.7, width = 0.7) +
    labs(title = paste("Distribution of", str_to_title(gsub("_", " ", category)), "by Gender"),
         x = str_to_title(gsub("_", " ", category)),
         y = "Proportion") +
    scale_fill_manual(values = c("Male" = "lightskyblue", "Female" = "indianred1")) +
    custom_theme
  
  # Print the plot
  print(p)
  
  if (save) {
    if (is.null(figure_path)) {
      stop("figure_path must be specified if save is TRUE.")
    }
    # Construct the full file path with a specified image name and save the plot
    file_path <- paste0(figure_path, "/", gsub(" ", "_", tolower(category)), "_by_gender.png")
    ggsave(file_path, plot = p, device = "png", width = 9, height = 5, units = "in")
    return(file_path)
  } else{
    return(p)
  }
}

