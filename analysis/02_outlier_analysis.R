# ======================================================
# Outlier Analysis Script
# ======================================================

# ----- Load required libraries -----
suppressPackageStartupMessages({
  library(dplyr)
  library(ggplot2)  # For visualization
})

# Set root directory correctly with here
here::i_am("README.md")  # Specify the root of your project here

# ----- Source all functions from the source folder -----
source_path <- here::here("src")  # Path to the folder containing the scripts to source
files <- list.files(path = source_path, pattern = "\\.R$", full.names = TRUE)
for (file in files) {
  source(file)  # Source each R script
}

# ----- Load the cleaned dataset -----
cleaned_file_path <- here::here("data", "derived_data", "cleaned_student_data.rds")
student_data <- readRDS(cleaned_file_path)

# ----- Outlier Identification and Correction -----

# Outlier 1: Correcting height and weight outlier
# Inspecting the data, we noticed a person with height 4.5 cm and weight 42 kg, which is clearly unrealistic.
# We assumed that the height was entered incorrectly, as other people with weight 42 kg had heights around 145 cm.
# Therefore, we replaced the height value with 145 cm.


# ----- Visualize height and weight distribution -----
height_weight_plot <- ggplot(student_data, aes(x = height_cm, y = weight_kg)) +
  geom_point(alpha = 0.6, color = "#0073C2FF") +  # Adjust color and transparency
  labs(title = "Height vs. Weight Distribution",
       x = "Height (cm)",  # Adding units to axis labels for clarity
       y = "Weight (kg)") +
  theme_minimal() +  # Minimal theme for a cleaner look
  theme(plot.title = element_text(face = "bold", hjust = 0.5),  # Center the plot title
        axis.title.x = element_text(face = "bold"),
        axis.title.y = element_text(face = "bold"),
        panel.grid.minor = element_blank(),  # Remove minor grid lines for a cleaner look
        panel.grid.major.x = element_line(color = "gray", linetype = "dotted"),  # Customize major grid lines
        panel.grid.major.y = element_line(color = "gray", linetype = "dotted"),
        legend.position = "none")  # Hide legend as it's unnecessary

# Save the height and weight plot
ggsave(filename = here::here("figures", "height_vs_weight.png"), plot = height_weight_plot, width = 9, height = 5)

# Print the plot
print(height_weight_plot)


# Identify and correct the outlier based on logical assumptions
student_data$height_cm[student_data$height_cm == 4.5 & student_data$weight_kg == 42] <- 145

# Outlier 2: Correcting 10th grade marks outlier
# Plotting the distribution of composite scores for grades, we noticed that almost all students had 10th grade marks >= 40,
# except for one student whose marks were 7.4, while the 12th grade and college marks were reasonably high.
# We assumed that this observation was stored incorrectly, and the real grade was likely 74.
# Therefore, we corrected the 10th grade mark to 74.

# Visualize distribution of 10th grade marks
marks_plot <- ggplot(student_data, aes(x = mark_10th)) +
        geom_histogram(binwidth = 5, fill = "#3498db", color = "#1f2d3d", alpha = 0.7) +  # Adjust colors and transparency
        labs(title = "Distribution of 10th Grade Marks",
             x = "10th Grade Marks",
             y = "Count of Students") +  # Adding label for y-axis
        theme_minimal() +  # Using minimal theme for a cleaner look
        theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 16),  # Enhance and center the title
              axis.title.x = element_text(face = "bold", size = 14),  # Bold x-axis label
              axis.title.y = element_text(face = "bold", size = 14),  # Bold y-axis label
              axis.text = element_text(color = "#2c3e50"),  # Darken axis text for better readability
              panel.grid.major = element_line(color = "gray", linetype = "dotted"),  # Customize major grid lines
              panel.grid.minor = element_blank())  # Remove minor grid lines for a cleaner look

# Save the marks distribution plot
ggsave(filename = here::here("figures", "marks_10th_distribution.png"), plot = marks_plot, width = 9, height = 5)

# Print the plot
print(marks_plot)

# Identify the outlier
outlier_index <- which(student_data$mark_10th == 7.4)

# Print relevant information about the outlier
cat("Observation with outlier 10th grade marks:\n")
print(student_data[outlier_index, c("mark_10th", "mark_12th", "college_mark")])

# Correct the 10th grade mark to 74
student_data$mark_10th[outlier_index] <- 74

# ----- Review and save corrected dataset -----
head(student_data)
str(student_data)

# Save the corrected dataset to an RDS file using 'here'
corrected_file_path <- here::here("data", "derived_data", "corrected_student_data.rds")
saveRDS(student_data, corrected_file_path)

