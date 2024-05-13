# ======================================================
# Script to Plot a Correlation Matrix of Ordered Variables
# ======================================================

# ----- Load required libraries -----
suppressPackageStartupMessages({
  library(dplyr)         # For data manipulation
  library(ggplot2)       # For visualization (unused directly but typically paired with dplyr)
  library(corrplot)      # For generating correlation plots
  library(readr)         # For reading data
  library(here)          # For constructing reliable file paths
  library(stringr)       # For string manipulation 
})


# Set root directory correctly with here
here::i_am("README.md")  # Specify the root of your project here

# ----- Load the cleaned dataset -----
# Assuming the final cleaning script has been run and dataset is saved as RDS
file_path <- here::here("data", "derived_data", "corrected_student_data.rds")
student_data <- readRDS(file_path)  # Read the dataset into R

# ----- Convert ordered factors to numeric ranks for correlation analysis -----
# This allows for the computation of correlations among ordinal and numeric variables
numeric_vars <- student_data %>%
  mutate(across(where(is.ordered), as.numeric))

# ----- Select relevant numeric and ordered variables -----
# Ensure that key variables such as academic marks and personal metrics are included
selected_vars <- c("college_mark", "mark_12th", "mark_10th",
                   "study_time", "salary_expectation", "career_willingness",
                   "social_media_time", "travel_time", "stress_level", 
                   "financial_status", "body_mass_index")

# Filter the data to only include the selected variables
cor_data <- numeric_vars %>% select(all_of(selected_vars))

# ----- Update column names for readability -----
# Replace underscores with spaces and capitalize each word for better presentation in plots
colnames(cor_data) <- str_replace_all(colnames(cor_data), "_", " ")
colnames(cor_data) <- str_to_title(colnames(cor_data))

# ----- Calculate the correlation matrix -----
# Use 'pairwise.complete.obs' to handle missing values appropriately
cor_matrix <- cor(cor_data, use = "pairwise.complete.obs")

# ----- Visualize the correlation matrix using corrplot -----
# Print the correlation plot for better visual interpretation
corrplot(cor_matrix, method = "color", type = "lower", order = "original",
         addCoef.col = 'white',  # Add correlation coefficients in white color for visibility
         tl.col = "black",  # Text label color
         tl.srt = 1,        # Text label angle
         title = "Correlation Matrix of Ordered Variables",
         tl.cex = 0.8,      # Font size for variable labels
         number.cex = 1,  # Font size for correlation coefficients
         mar = c(0, 0, 2, 0))  # Margin adjustments (bottom, left, top, right)

# ----- Saving the correlation matrix plot as a PNG -----
# Open a PNG file for saving the plot
png(filename = here::here("figures", "corr_matrix_plot.png"), width = 10*300, height = 7*300, res = 300)
# Customize the correlation plot for better visual interpretation
corrplot(cor_matrix, method = "color", type = "lower", order = "original", 
         addCoef.col = 'white',  # Add correlation coefficients in white color for visibility
         tl.col = "black",  # Text label color
         tl.srt = 1,        # Text label angle
         title = "Correlation Matrix of Ordered Variables", 
         tl.cex = 0.8,      # Font size for variable labels
         number.cex = 1,    # Font size for correlation coefficients
         mar = c(0, 0, 2, 0))  # Margin adjustments (bottom, left, top, right)
# Close the PNG device
dev.off()





