################################################################################
#
# 000: Data processing
# 
# Author(s): John Tazare
# Purpose: This script is to import the cohort dataset and perform descriptive
# statistics
#
# 
################################################################################


################################################################################
# 0.0 Import libraries + functions
################################################################################
# Define the required packages
required_packages <- c("tidyverse", "tableone")

# Function to check and install missing packages
install_load <- function(packages) {
  missing_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
  if (length(missing_packages) > 0) {
    install.packages(missing_packages)
  }
  invisible(lapply(packages, library, character.only = TRUE))
}

# Run the function
install_load(required_packages)

################################################################################
# 0.1 Import data
################################################################################
print("Import data")

cohort <- 
  read_csv("./data/cohort.csv") %>% 
  mutate(across(.cols = c(female, ses, smoke, alc, bmicat, nsaid_rx, cancer, hyper),
                .fns = as.factor))

# Inspect dataset
head(cohort)
view(cohort)

################################################################################
# 0.2 Descriptive analysis
################################################################################

# Let's summarise the characteristics by treatment group

# Specify the variables to include
vars <- c("age", "female", "ses", "smoke", "alc", "bmicat", "nsaid_rx", "cancer", "hyper")

# Specify which of the variables are categorical (factors)
factorVars <- c("female", "ses", "smoke", "alc", "bmicat", "nsaid_rx", "cancer", "hyper")

# Create the table stratified by the treatment variable 'trt'
table1 <- CreateTableOne(vars = vars, strata = "trt", data = cohort, factorVars = factorVars)

# Print the table with non-normal variables summarized as medians/IQRs, if needed
print(table1, showAllLevels = TRUE, quote = TRUE, noSpaces = TRUE)
