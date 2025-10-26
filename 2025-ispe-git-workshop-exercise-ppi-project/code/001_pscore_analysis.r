###################################################################################
#
# 001: Propensity score analysis
# 
# Author(s): John Tazare
# Purpose: This script is to import cohort data, estimate propensity scores
# and estimate treatment effects
#
# 
###################################################################################


################################################################################
# 0.0 Import libraries + functions
################################################################################
# Define the required packages
required_packages <- c("tidyverse", "tableone", "ggplot2", "survey", "cobalt")

# Function to check and install missing packages
install_load <- function(packages) {
  missing_packages <- packages[!(packages %in% installed.packages()[, "Package"])]
  if (length(missing_packages) > 0) {
    install.packages(missing_packages)
  }
  invisible(lapply(packages, library, character.only = TRUE))
}

install_load(required_packages)

################################################################################
# 0.1 Import data
################################################################################
print("Import data")

cohort <- 
  read_csv("~/Documents/GitHub/git-workshop-exercise-ppi-project/data/cohort.csv") %>% 
  mutate(across(.cols = c(female, ses, smoke, alc, bmicat, nsaid_rx, cancer, hyper),
                .fns = as.factor))

################################################################################
# 0.2 Estimate propensity score
################################################################################
# Define covariates used in the propensity score model
# Specify logistic regression model
# Note: treatment is the variable name defining treatment groups
psModel <- glm(trt ~ age + female + ses + smoke + alc + bmicat + nsaid_rx + cancer + hyper, family=binomial(), data= cohort)

# Append patient-level estimated propensity score (pscore) to cohort data
cohort$pscore <- predict(psModel, type = "response")

# Create inverse probability of treatment weights (IPTW) 
cohort$ps_weight <- ifelse(cohort$trt==1,
                                   1 / cohort$pscore,
                                   1 / (1 - cohort$pscore))


################################################################################
# 0.3 Propensity score diagnostics
################################################################################

# Basic density plot of propensity scores by treatment group
ggplot(cohort, aes(x = pscore, fill = as.factor(trt))) +
  geom_density(alpha = 0.4) +
  labs(title = "Propensity Score Distribution by Treatment Group",
       x = "Propensity Score",
       y = "Density",
       fill = "Treatment") +
  theme_minimal()


# Use cobalt to assess balance before and after weighting
bal.tab(trt ~ age + female + ses + smoke + alc + bmicat + nsaid_rx + cancer + hyper,
        data = cohort,
        weights = cohort$ps_weight)

# Make a love plot to compare balance before and after propensity score weighting
love.plot(bal.tab(trt ~ age + female + ses + smoke + alc + bmicat + nsaid_rx + cancer + hyper,
                  data = cohort,
                  weights = cohort$ps_weight),
          threshold = 0.1, stars = "raw" )


################################################################################
# 0.4 Estimate treatment effect
################################################################################

# Define survey design object
design_ps <- svydesign(ids = ~1, weights = ~ps_weight, data = cohort)

# Estimate average treatment effect using weighted logistic regression
ps_weighted_model <- svyglm(outcome ~ trt, design = design_ps, family = quasibinomial())

# Summary of the weighted model
summary(ps_weighted_model)

