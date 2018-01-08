library(tidyverse)
library(viridis)
library(scales)
library(hrbrthemes)

theme_set(
  theme_ipsum(
    base_family = "Roboto Condensed",
    plot_title_face = "plain",
    plot_title_size = "plain",
    plot_margin = margin(5, 5, 5, 5)) +
    theme(
      title = element_text(colour = "#444444"),
      panel.grid.major = element_line(colour = "grey90"),
      panel.grid.minor = element_line(colour = "grey90"),
      legend.position = "bottom"
    )
)

knitr::opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  echo = TRUE,
  dev = "svg",
  cache = TRUE
)