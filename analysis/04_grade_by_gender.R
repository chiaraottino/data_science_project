# ============================================================================
# Script for Analyse Grade Distributions overall and by gender
# ============================================================================

# ----- Load required libraries -----------------------------------------------
suppressPackageStartupMessages({
  library(ggplot2)  # For advanced plotting
  library(dplyr)    # For data manipulation
  library(tidyr)    # For data tidying
  library(gridExtra)  # For arranging multiple plots
  library(grid)      # For low-level grid graphics
  library(GGally)    # For pairs plots
  library(extrafont) # For new fonts
})

# ----- Set root directory correctly with here --------------------------------
here::i_am("README.md")  # Ensures that all paths are relative to the project root

# ----- Source all functions from the source folder ---------------------------
source_path <- here::here("src")  # Path to the folder containing additional R scripts
files <- list.files(path = source_path, pattern = "\\.R$", full.names = TRUE)
for (file in files) {
  source(file)  # Load each R script to access custom functions
}

# ----- Load the cleaned and corrected dataset ----------------------------
file_path <- here::here("data", "derived_data", "corrected_student_data.rds")
student_data <- readRDS(file_path)  # Read the dataset from an RDS file

# ----- Transform data for analysis ----------------------------------------
# Pivot the selected columns to a long format for easier aggregation and plotting
data_long <- student_data %>%
  select(mark_10th, mark_12th, college_mark) %>%
  pivot_longer(cols = everything(), names_to = "grade_level", values_to = "grade")

# ----- Define a custom theme for plots -------------------------------
# Create a theme for consistent and attractive visuals across all plots
custom_theme <- theme_minimal() +
  theme(text = element_text(family = "sans", color = "#333333"),
        plot.title = element_text(face = "bold", size = 14),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 10),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 10),
        panel.grid.major = element_line(color = "gray", linewidth = 0.5),
        panel.grid.minor = element_blank())

# ----- Visualize grade distributions across educational levels -----
# Generate a density plot to visualizse the distribution of grades
p <- ggplot(data_long, aes(x = grade, fill = grade_level)) +
  geom_density(alpha = 0.5) +
  scale_x_continuous(limits = c(0, 100), breaks = seq(0, 100, 20)) +
  scale_y_continuous(limits = c(0, 0.038), breaks = seq(0, 0.038, 0.01)) +
  custom_theme + theme(legend.position = "bottom") +
  labs(title = "Grade Distributions Across Different Educational Levels",
       x = "Grade",
       y = "Density") +
  scale_fill_manual(values = c("college_mark" = "gold", "mark_12th" = "coral", "mark_10th" = "steelblue"),
                    name = "Grade Level",
                    labels = c("College Marks", "12th Grade Marks", "10th Grade Marks"))

# Print the histogram plot
print(p)

ggsave(filename = here::here("figures", "grade_densities.png"), plot = p, width = 9, height = 5)


# ----- Analyze grade distributions between educational levels -----
# Perform statistical tests to compare grade distributions between different educational levels
compare_grade_distributions(student_data, c("mark_10th", "mark_12th", "college_mark"))

# ----- Create and customize pairs plots ---------------------------------------

# Custom function for density plots with specified x-axis limits and matching fill and line colors
density_custom <- function(data, mapping, ...){
  ggplot(data = data, mapping = mapping) + 
    geom_density(aes(fill = gender), color='black', ...) + # Set fill and line colors to match
    xlim(0, 100) # Set the x-axis limits
}

# Custom function for scatterplots with specified axis limits
scatter_custom <- function(data, mapping, ...){
  ggplot(data = data, mapping = mapping) + 
    geom_point(...) + 
    xlim(0, 100) + 
    ylim(0, 100)
}


# ----- Visualize grade distributions differentiating by gender -----

# Visualize grade distributions for the first three columns
p <- ggpairs(student_data, 
             columns = c("college_mark", "mark_12th", "mark_10th"), 
             columnLabels = c("College Mark", "12th Grade Mark", "10th Grade Mark"),
             mapping = aes(color = gender, alpha = 0.7),
             lower = list(continuous = wrap("cor", size = 5)),
             upper = list(continuous = wrap(scatter_custom, alpha = 0.7)),
             diag = list(continuous = wrap(density_custom, linewidth = 0.4, alpha = 0.7)))

# Enhance pairs plot aesthetics
p <- p + theme_bw() +
  theme(legend.position = "bottom", 
        plot.title = element_text(hjust = 0.5)) +
  ggtitle("Pairwise Relationships by Gender")

# Print the pairs plot
print(p)

# Save the plot
ggsave(filename = here::here("figures", "grade_by_gender_pairs.png"), plot = p, width = 10, height = 6)

# ----- Statistical tests by gender ------------------------------
# Conduct tests to analyze differences in grade distributions by gender for each grade level
analyze_grades_by_gender(student_data, c("mark_10th", "mark_12th", "college_mark"))

# Test hypotheses whether females score higher in grades at each educational level
assess_higher_female_grades(student_data, "mark_10th")
assess_higher_female_grades(student_data, "mark_12th")
assess_higher_female_grades(student_data, "college_mark")
