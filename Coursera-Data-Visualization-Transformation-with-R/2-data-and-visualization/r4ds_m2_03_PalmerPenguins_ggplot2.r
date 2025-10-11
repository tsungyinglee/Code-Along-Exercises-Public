# setup
# install.packages("tidyverse")
# install.packages("palmerpenguins")
library(tidyverse)
library(palmerpenguins)


# take a look at the data
glimpse(penguins)


# plot
# note: can also omit the names of the first two arguments: data and mapping
# e.g., ggplot(penguins, aes(...)) + ...
ggplot(
  data = penguins,
  mapping = aes(
    x = bill_depth_mm,
    y = bill_length_mm,
    color = species
    )
  ) + 
  geom_point() +
  labs(
    title = "Bill depth vs. bill length",
    subtitle = "Dimensions for adelle, chinstrap, and gentoo penguins",
    x = "Bill depth (mm)",
    y = "Bill length (mm)",
    color = "Species",
    caption = "Data from the palmerpenguins package"
  ) +
  scale_color_viridis_d() 
      # discrete color scale from the viridis package for 
      # better color vision accessibility


# Narrative: 
# Start with the penguins data frame, then map bill depth to the x-axis, 
# bill length to the y-axis, and species to color. 
# Represent each observation as a point.
# Title the plot "Bill depth vs. bill length", add the subtitle 
# "Dimensions for adelle, chinstrap, and gentoo penguins", label the x-axis 
# "Bill depth (mm)", label the y-axis "Bill length (mm)", label the color legend 
# "Species", and caption the plot "Data from the palmerpenguins package".
# Use a discrete color scale that is designed for viewers with common forms of
# color blindness.


