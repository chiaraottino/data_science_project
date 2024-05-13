# ==============================================================================
# Script for Visualizing Distribution and Testing the Differences between
#             the Ordered Categorical Variables and Gender
# ==============================================================================

# ----- Load required libraries -----
suppressPackageStartupMessages({
  library(ggplot2)  # For advanced plotting
  library(dplyr)    # For data manipulation
  library(here)
  library(stringr)
})

# ----- Set root directory correctly with here -----
here::i_am("README.md")  # Ensures that all paths are relative to the project root

# ----- Source all functions from the source folder -----
source_path <- here::here("src")  # Path to the folder containing additional R scripts
files <- list.files(path = source_path, pattern = "\\.R$", full.names = TRUE)
for (file in files) {
  source(file)  # Load each R script to access custom functions
}

# ----- Load the cleaned dataset -----
file_path <- here("data", "derived_data", "corrected_student_data.rds")
student_data <- readRDS(file_path)  # Read the dataset from an RDS file

# Define custom theme for consistent and attractive visuals across all plots
custom_theme <- theme_minimal() +
  theme(text = element_text(family = "Arial", color = "#333333"),
        plot.title = element_text(face = "bold", size = 14),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 10),
        axis.title = element_text(size = 12),
        axis.text = element_text(size = 10),
        panel.grid.major = element_line(color = "grey", linewidth = 0.5),  # Updated to use 'linewidth'
        panel.grid.minor = element_blank())

# Categories to visualize
categories <- c("study_time", "social_media_time", "stress_level", "financial_status", 
                "bmi_category", "career_willingness", "travel_time")

# Construct the figure path using the 'here' package
figure_path <- here("figures")

# Loop through each category to create visualizations
for (category in categories) {
  
  # Generate a bar plot to show the proportion of the current category categorized by gender and save it
  plot_pat <- plot_category_proportions_by_gender(student_data, category, custom_theme, save=TRUE, figure_path)
  
}

# ----- Statistical Analysis --------------------------------------------

# Performing statistical analysis using the helper function 'compare_categorical_by_gender'
for (category in categories){
  cat(compare_categorical_by_gender(student_data, category))
}


