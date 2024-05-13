suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(stringr)
  })

#' Plot Pie Chart of Proportions by Gender for a Given Category
#'
#' This function creates a pie chart showing the proportions of a specified category,
#' split by gender. The plot can be customized and saved to a specified path if desired.
#'
#' @param data A dataframe containing the data to be plotted.
#' @param category The name of the categorical column to plot.
#' @param custom_theme A ggplot2 theme object to customize the plot aesthetics.
#' @param save Logical, whether to save the plot or not (default = FALSE).
#' @param figure_path The directory where the plot should be saved, required if save is TRUE.
#' @import ggplot2
#' @import dplyr
#' @import stringr
#' @return The plot object if not saved, or the path where the plot was saved if saved.
#' @examples
#' custom_theme <- theme_void() + theme(legend.position = "right")
#' # To display:
#' plot_pie_chart_by_gender(student_data, "preference", custom_theme)
#' # To save:
#' plot_pie_chart_by_gender(student_data, "preference", custom_theme, save = TRUE, figure_path = "path/to/save")
plot_pie_chart_by_gender <- function(data, category, custom_theme, save = FALSE, figure_path = NULL) {
  if (!category %in% names(data)) {
    stop("The specified category is not a column in the provided data frame.")
  }
  
  # Preparing data: calculating counts and proportions
  pie_data <- data %>%
    group_by(gender, .data[[category]]) %>%
    summarise(count = n(), .groups = 'drop') %>%
    group_by(gender) %>%
    mutate(proportion = count / sum(count)) %>%
    ungroup()
  
  # Generate a pie chart for each category
  p <- ggplot(pie_data, aes(x = "", y = proportion, fill = .data[[category]])) +
    geom_col(color = "black") +
    geom_bar(stat = "identity", width = 1) +
    coord_polar(theta = "y") +
    geom_label(aes(label = scales::percent(proportion, accuracy = 1)),
               color = "black",
               position = position_stack(vjust = 0.5),
               show.legend = FALSE) +
    facet_wrap(~gender) +
    labs(title = paste("Distribution of", stringr::str_to_title(gsub("_", " ", category)), "by Gender"),
         x = "",
         y = "",
         fill = stringr::str_to_title(gsub("_", " ", category))) +
           custom_theme
  
  # Print the plot
  print(p)
  
  if (save) {
    if (is.null(figure_path)) {
      stop("figure_path must be specified if save is TRUE.")
    }
    file_path <- paste0(figure_path, "/", gsub(" ", "_", tolower(category)), "_by_gender_pie.png")
    ggsave(file_path, plot = p, device = "png", width = 10, height = 6, units = "in")
    return(file_path)
  } else {
    return(p)
  }
}
