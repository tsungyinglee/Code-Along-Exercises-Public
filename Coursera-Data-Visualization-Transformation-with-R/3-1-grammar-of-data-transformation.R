# Grammar of Data Transformation

# NYC Flights Dataset Exploration
# Use the nycflights13 package to explore the flights dataset.
# The dataset contains information about all flights that departed from NYC (RFK, LGA, EWR) in 2013.

# Load necessary libraries
library(tidyverse)
library(nycflights13)
flights

# ---------------------- dimensions of the data ----------------------
# number of rows
nrow(flights)

# number of columns
ncol(flights)

# ---------------------- first look at the data ----------------------
# structure and type of the data
glimpse(flights)

# list of variable names
names(flights)

# first few rows of the data
head(flights)

# last few rows of the data
tail(flights)

# ---------------------- compare tibble vs data.frame ----------------------
# tibble (as part of tidyverse) is an opinionated data frame (data.frame is the base R version)
# tibble prints the first 10 rows and all columns that fit on the screen
flights

# data frame (attempt to) prints all rows and columns or crash trying if too many
cars

# stricter subsetting with tibbles vs data.frames
# Informative Warning + NULL with tibbles if the column doesn't exist (unlike data frames which return only NULL)
flights$apple
cars$apple

# -------------------- transforming with dplyr package: row operation --------------------

# choose rows based on location
slice(flights, 3:5)

# choose rows based on condition (column values)
filter(flights, month == 1, day == 1) # January 1st

