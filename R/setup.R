library(tidyverse)
library(viridis)
library(scales)
library(hrbrthemes)
library(gridExtra)
library(ggbeeswarm)

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

theme_null <- function(...) {
  theme(...,
        axis.line=element_blank(),
        axis.text.x=element_blank(),
        axis.text.y=element_blank(),
        axis.ticks=element_blank(),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        legend.position = "none",
        panel.background=element_blank(),
        panel.border=element_blank(),
        panel.grid.major=element_blank(),
        panel.grid.minor=element_blank(),
        plot.background=element_blank())
}

knitr::opts_chunk$set(
  message = FALSE,
  warning = FALSE,
  echo = FALSE,
  dev = "svg",
  cache = TRUE,
  cache.path = ".cache/",
  fig.path = "img/"
)

# datasets ----------------------------------------------------------------
n <- 3500

dfdist <- bind_rows(
  data_frame(key = "Simetrica", value = rnorm(n)),
  data_frame(key = "Bimodal", value =  rnorm(n) + ifelse(runif(n) < 0.45, 4, 0)),
  data_frame(key = "Uniforme", value =  runif(n)),
  data_frame(key = "Asimetrica", value = rchisq(n, 3))
) %>%
  mutate(key = factor(key, levels = unique(key))) %>% 
  group_by(key) %>% 
  mutate(value = (value - min(value))/(max(value) - min(value))) %>% 
  ungroup()

dfstats <- dfdist %>% 
  group_by(key) %>% 
  summarise(media = mean(value), mediana = median(value)) %>% 
  gather(stat, value, -key)

gg_dists <- function(k = "Simetrica", color = "#673AB7") {
  
  dfdist2 <- dfdist %>% 
    filter(key == k) %>% 
    sample_n(1500)
  gg <- ggplot(dfdist2) + coord_flip() + theme_null()
  
  grid.arrange(
    ggplot(dfdist2) + geom_histogram(aes(value), fill = color) + theme_null() + ggtitle("Histograma"),
    gg + geom_beeswarm(aes(x = factor(1), y = value), color = color, cex = 1.1, alpha = 0.2) + ggtitle("Beeswarm"),
    gg + geom_boxplot(aes(x = factor(1), y = value), color = color) + ggtitle("Boxplot"),
    gg + geom_violin(aes(x = factor(1), y = value), color = color) + ggtitle("Violin")
  )
}
