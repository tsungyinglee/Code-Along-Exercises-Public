# Anscombe's quartet
library(Tmisc)
quartet

# Summarizing Anscombe's quartet
quartet |>
  group_by(set) |>
  summarize(
    mean_x = mean(x),
    mean_y = mean(y),
    sd_x = sd(x),
    sd_y = sd(y),
    r_xy = cor(x, y)
  )

# Visualizing Anscombe's quartet
ggplot(quartet, aes(x = x, y = y)) +
  geom_point() +
  facet_wrap(~ set, ncol = 4)
