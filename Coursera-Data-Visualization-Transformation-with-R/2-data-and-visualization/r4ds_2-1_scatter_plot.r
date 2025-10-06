# Load the tidyverse package
library(tidyverse)

# View the data set starwars
starwars

# Get a glimpse of the data set
glimpse(starwars)

# View the first few rows of the data set
head(starwars)

nrow(starwars) # Number of rows
ncol(starwars) # Number of columns
dim(starwars)  # Dimensions of the data set

# Exploratory Data Analysis (EDA)
# Data Visualization
# "The simple grath has brought more information to the data analyst than any
# other method." - John Tukey
# Scatter plot
ggplot(data = starwars) +
  geom_point(mapping = aes(x = height, y = mass))
