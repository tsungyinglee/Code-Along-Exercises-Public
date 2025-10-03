# arithmetic
2+2

# assignment
x <- 2

# use the variable x
x * 3

# space is optional, but makes code more readable
x*4

# packages are installed by using the install.packages() function
# only need to install a package once
install.packages("palmerpenguins")

# load the package by using the library() function
# need to load the package every time you start a new R session
library(palmerpenguins)

# view the data set penguins in the console
# penguins is a dataframe included in the palmerpenguins package
penguins

# view the data set in a spreadsheet-like viewer
View(penguins)

# columns/variables in dataframe are accessed with the $ operator
# dataframe$column_name
penguins$body_mass_g

# calculate the mean of the body_mass_g column
mean(penguins$body_mass_g)

# get help on the mean function
?mean

# handle missing values with the na.rm argument
# na.rm = TRUE means to remove NA values before calculating the mean
mean(penguins$body_mass_g, na.rm = TRUE)
