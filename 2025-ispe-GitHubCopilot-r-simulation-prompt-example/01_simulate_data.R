# 01_simulate_data.R
# Simulate a fictional randomized clinical trial baseline dataset
# Step-by-step approach as requested

# Load required packages
library(gtsummary)

# Step 1: Set parameters and random seed
set.seed(123)
n_total <- 400  # Total sample size

# Step 2: Generate treatment arms (1:1 randomization)
arm <- sample(c("Control", "Treatment"), size = n_total, replace = TRUE)

# Step 3: Generate baseline covariates

# Age: continuous with mean 65
age <- rnorm(n_total, mean = 65, sd = 10)

# Sex: categorical - Male (40%), Female (60%)
sex <- sample(c("Male", "Female"), size = n_total, replace = TRUE, prob = c(0.40, 0.60))

# Disease stage: ordinal I, II, III, IV (each 25% prevalence)
disease_stage <- sample(c("I", "II", "III", "IV"), size = n_total, replace = TRUE, prob = rep(0.25, 4))

# Biomarker status: binary - TRUE (30%), FALSE (70%)
biomarker_status <- sample(c(TRUE, FALSE), size = n_total, replace = TRUE, prob = c(0.30, 0.70))

# Step 4: Create data frame
# Display the first few rows and basic structure of the dataset

temp_data <- data.frame(
  arm = factor(arm, levels = c("Control", "Treatment")),
  age = age,
  sex = factor(sex, levels = c("Male", "Female")),
  disease_stage = factor(disease_stage, levels = c("I", "II", "III", "IV"), ordered = TRUE),
  biomarker_status = biomarker_status
)

# Show first few rows
print("First 10 rows of simulated dataset:")
print(head(temp_data, 10))

# Show structure
print("\nDataset structure:")
str(temp_data)

# Step 5: Illustrate baseline characteristics using tbl_summary()
# Create summary table by treatment arm
baseline_table <- temp_data %>%
  select(arm, age, sex, disease_stage, biomarker_status) %>%
  tbl_summary(
    by = arm,
    statistic = list(
      age ~ "{mean} ({sd})",
      all_categorical() ~ "{n} ({p}%)"
    ),
    digits = list(
      age ~ 1
    ),
    label = list(
      age ~ "Age (years)",
      sex ~ "Sex",
      disease_stage ~ "Disease Stage",
      biomarker_status ~ "Biomarker Status"
    )
  ) %>%
  add_overall() %>%
  add_p(
    test = list(
      age ~ "t.test"
    )
  ) %>%
  modify_caption("**Baseline characteristics by treatment arm**") %>%
  modify_header(label ~ "**Characteristic**") %>%
  bold_labels()

# Display the summary table
print(baseline_table)
