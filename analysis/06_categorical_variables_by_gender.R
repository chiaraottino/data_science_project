# ======================================================
# Script for Visualizing and Analyzing Categorical Data by Gender
# ======================================================

# ----- Load required libraries -----
suppressPackageStartupMessages({
  library(ggplot2)  # For advanced plotting
  library(dplyr)    # For data manipulation
  library(here)     # For path management
  library(stringr)  # For string operations
  library(extrafont) # For new fonts
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
custom_theme <- custom_theme <- theme_void() + theme(legend.position = "right") +
  theme(text = element_text(family = "sans", color = "#333333"),
        plot.title = element_text(face = "bold", size = 14),
        legend.title = element_text(size = 12),
        legend.text = element_text(size = 12),
        strip.text = element_text(size = 14))

# Categories to visualize
categories <- c("certification", "department", "hobbies", "like_degree", 
                "part_time_job", "study_preference")


# Construct the figure path using the 'here' package
figure_path <- here("figures")

# Loop through each category to create visualizations
for (category in categories) {
  
  # Generate a bar plot to show the proportion of the current category categorized by gender
  pie_chart_path <- plot_pie_chart_by_gender(student_data, category, custom_theme, save=TRUE, figure_path)

}

# ----- Statistical Analysis --------------------------------------------

# Performing statistical analysis using the helper function 'compare_categorical_by_gender'
for (category in categories){
  cat(compare_categorical_by_gender(student_data, category))
}

