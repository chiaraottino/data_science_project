# ======================================================
# Data Cleaning Script
# ======================================================

# ----- Load required libraries -----
suppressPackageStartupMessages({
  library(lubridate)
  library(dplyr)
  library(readr)
  library(yardstick)
  library(stringr)
  library(here)
})
# Set root directory correctly with here
here::i_am("README.md")  # Specify the root of your project here

# ----- Source all functions from the source folder -----
source_path <- here::here("src")  # Path to the folder containing the scripts to source
files <- list.files(path = source_path, pattern = "\\.R$", full.names = TRUE)
for (file in files) {
  source(file)  # Source each R script
}

# ----- Load the dataset -----
file_path <- here("data", "raw_data", "Student Attitude and Behavior.csv")
student_data <- read.csv(file_path, stringsAsFactors = TRUE)


# ----- Data Exploration -----
str(student_data)  # Structure of the dataset

# ----- Check for missing values -----
missing_values <- sum(is.na(student_data))
if (missing_values > 0) {
  print(paste("There are", missing_values, "missing values in the dataset."))
} else {
  print("There are no missing values in the dataset.")
}

# ----- Rename variables for consistency -----
names(student_data) <- tolower(names(student_data))
names(student_data) <- str_replace_all(names(student_data), "\\s+", "_")
names(student_data) <- c("certification", "gender", "department", "height_cm", "weight_kg", 
                         "mark_10th", "mark_12th", "college_mark", "hobbies", "study_time", 
                         "study_preference", "salary_expectation", "like_degree", 
                         "career_willingness", "social_media_time", "travel_time", 
                         "stress_level", "financial_status", "part_time_job")

# ----- Factor and Ordered Factor Conversions -----
# Convert "study_time" column to an ordered categorical variable
student_data$study_time <- factor(student_data$study_time, ordered = TRUE, 
                                  levels = c("0 - 30 minute", "30 - 60 minute", "1 - 2 Hour",
                                             "2 - 3 hour", "3 - 4 hour", "More Than 4 hour"))

# Convert "social_media_time" column to an ordered categorical variable
student_data$social_media_time <- factor(student_data$social_media_time, ordered = TRUE, 
                                         levels = c("0 Minute", "1 - 30 Minute", "30 - 60 Minute", 
                                                    "1 - 1.30 hour", "1.30 - 2 hour", "More than 2 hour"))

# Convert "travel_time" column to an ordered categorical variable
student_data$travel_time <- factor(student_data$travel_time, ordered = TRUE, 
                                   levels = c("0 - 30 minutes", "30 - 60 minutes",  "1 - 1.30 hour", 
                                              "1.30 - 2 hour", "2 - 2.30 hour",  "2.30 - 3 hour", "more than 3 hour"))

# Convert "stress_level" and "financial_status" columns to ordered categorical variables
student_data$stress_level <- factor(student_data$stress_level, ordered = TRUE, 
                                    levels = c("Awful", "Bad", "Good", "fabulous"))

student_data$financial_status <- factor(student_data$financial_status, ordered = TRUE, 
                                        levels = c("Awful", "Bad", "good", "Fabulous"))

# Rename the levels of "stress_level" and "financial_status" columns for consistency
levels(student_data$stress_level) <- c("Awful", "Bad", "Good", "Fabulous")
levels(student_data$financial_status) <- c("Awful", "Bad", "Good", "Fabulous")

# Convert "career_willingness" column to an ordered categorical variable
student_data$career_willingness <- factor(student_data$career_willingness, ordered = TRUE, 
                                          levels = c("0%", "25%",  "50%", "75%", "100%"))

# Rename the levels of "department"
levels(student_data$department) <- c("Accounting and Finance", "ISM", "BCA", "Commerce")

# ----- Extrapolate some new variables from the dataset -----

# Create a variable for BMI (Body Mass Index)
student_data$body_mass_index <- student_data$weight_kg/(student_data$height_cm/100)^2

# Now, create the BMI category variable
student_data$bmi_category <- cut(student_data$body_mass_index,
                                 breaks = c(-Inf, 18.5, 25, 30, Inf),
                                 labels = c("Underweight", "Normal Weight", "Overweight", "Obese"),
                                 right = FALSE,   # This means the intervals are right-open (e.g., [18.5, 25))
                                 ordered_result = TRUE)

# Create some variables to represent the changes in grades over the years
student_data <- student_data %>%
  mutate(
    # Calculate changes between each stage
    change_10th_to_12th = mark_12th - mark_10th,
    change_12th_to_college = college_mark - mark_12th,
    
    # Calculate percentage changes for more nuanced understanding
    pct_change_10th_to_12th = (change_10th_to_12th / mark_10th) * 100,
    pct_change_12th_to_college = (change_12th_to_college / mark_12th) * 100,
    
    # Create a composite score:
    # Weight more recent changes more heavily
    composite_score = (0.5 * pct_change_10th_to_12th) + (0.5 * pct_change_12th_to_college)
  )


# ----- Review and save cleaned dataset -----
head(student_data)
str(student_data)

# Save the cleaned dataset to an RDS file using 'here'
cleaned_file_path <- here("data", "derived_data", "cleaned_student_data.rds")
saveRDS(student_data, cleaned_file_path)

