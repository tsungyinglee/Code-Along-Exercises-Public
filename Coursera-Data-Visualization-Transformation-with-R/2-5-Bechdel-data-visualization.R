library(readr)
library(dplyr)
library(ggplot2)
library(scales)

# Load the Bechdel test dataset
bechdel_movies <- read_csv("~/Documents/Coding Projects/GitHub/Code-Along-Exercises-Public/Coursera-Data-Visualization-Transformation-with-R/bechdel_movies.csv")

# Clean and transform the dataset
bechdel_movies <- bechdel_movies %>%
  # Limit the scope of the data to movies released between 1990 and 2013
  filter(year >= 1990 & year <= 2013) %>%
  # Rename gross columns for clarity
  rename(domgross_2013 = `domgross_2013$`,
         intgross_2013 = `intgross_2013$`) %>%
  rename(budget_2013 = `budget_2013$`) %>%
  # Convert gross columns to numeric, handling "#N/A" values
  mutate(
    intgross_2013 = na_if(intgross_2013, "#N/A"),
    intgross_2013 = parse_number(intgross_2013),
    domgross_2013 = na_if(domgross_2013, "#N/A"),
    domgross_2013 = parse_number(domgross_2013)
  ) %>%
  # Create a gross variable that sums domestic and international gross
  mutate(gross_2013 = domgross_2013 + intgross_2013) %>%
  # Calculate ROI from gross and budget (following the formula in course materials, not standard ROI formula)
  mutate(roi = gross_2013 / budget_2013)

# View the first few rows of the dataset
glimpse(bechdel_movies)

# Display the first 10 rows of the cleaned dataset
slice(bechdel_movies, 1:10)

# Create a scatter plot of budget vs gross
ggplot(
  bechdel_movies,
  aes(x = budget_2013, y = gross_2013)
) + 
  geom_point(color = "deepskyblue3") +
  labs(
    title = "Gross Revenue vs Budget for Movies (1990-2013)",
    x = "Budget (2013$)",
    y = "Gross Revenue (2013$)"
  )

# Create a scatter plot of budget vs gross, colored by Bechdel test result
ggplot(
  bechdel_movies,
  aes(x = budget_2013, y = gross_2013,
      color = binary, size = roi)
) + 
  geom_point(alpha = 0.5) +
  labs(
    title = "Gross Revenue vs Budget for Movies (1990-2013)",
    x = "Budget (2013$)",
    y = "Gross Revenue (2013$)"
  )


# Facet by clean_test
ggplot(
  bechdel_movies,
  aes(x = budget_2013, y = gross_2013,
      color = binary, size = roi)
) + 
  geom_point(alpha = 0.5) +
  facet_wrap(~ clean_test) +
  labs(
    title = "Gross Revenue vs Budget for Movies (1990-2013)",
    x = "Budget (2013$)",
    y = "Gross Revenue (2013$)"
  )

# Make the axes more readable by formatting the dollar amounts
ggplot(
  bechdel_movies,
  aes(x = budget_2013, y = gross_2013,
      color = binary, size = roi)
) + 
  geom_point(alpha = 0.5) +
  scale_x_continuous(labels = dollar_format(scale = 1e-6, suffix = "M")) +
  scale_y_continuous(labels = dollar_format(scale = 1e-6, suffix = "M")) +
  labs(
    title = "Gross Revenue vs Budget for Movies (1990-2013)",
    x = "Budget (2013$)",
    y = "Gross Revenue (2013$)"
  )

# Display the association for different combincations of clean_test and binary
ggplot(
  bechdel_movies,
  aes(x = budget_2013, y = gross_2013,
      color = binary, size = roi)
) + 
  geom_point(alpha = 0.5) +
  scale_x_continuous(labels = dollar_format(scale = 1e-6, suffix = "M")) +
  scale_y_continuous(labels = dollar_format(scale = 1e-6, suffix = "M")) +
  facet_grid(clean_test ~ binary) +
  labs(
    title = "Gross Revenue vs Budget for Movies (1990-2013)",
    x = "Budget (2013$)",
    y = "Gross Revenue (2013$)"
  )
