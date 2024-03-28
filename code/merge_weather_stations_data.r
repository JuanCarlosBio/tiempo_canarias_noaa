#!/usr/bin/env Rscript

library(tidyverse)
library(sf)

prcp_data <- read_tsv("data/ghcnd_tidy.tsv")
stations_data <- read_tsv("data/ghcnd_canary_regions_years.tsv")
islands <- read_sf("data/islands_shp/islas.shp")

islands_dd <- st_transform(islands, crs = 4326)

lat_lon_prcp <- inner_join(prcp_data, stations_data, by = "id") %>% 
    filter((year != first_year & year != last_year) | year == year(today())) %>%
    group_by(latitude, longitude, year) %>%
    summarise(mean_prcp = mean(prcp)) 

data <- lat_lon_prcp %>%
    group_by(longitude, latitude) %>%
    mutate(
        z_score = (mean_prcp - mean(mean_prcp)) / sd(mean_prcp),
        n = n(),
    ) %>%
    filter(year == 2022) %>%
    select(-n) 

ggplot() +
    geom_sf(data = islands_dd,
            fill = "#b5a078") +
    geom_point(data = data, 
               aes(x = longitude, y = latitude, fill = z_score), 
               size = 25,
               color = "black",
               stroke = 1.25,
               pch = 21) +
    scale_fill_gradient2(low = "red", 
                          mid = "white", 
                          high = "blue", midpoint = 0) +
    labs(
        x = NULL,
        y = NULL
    ) +
    coord_sf() +  # Usar coord_sf en lugar de coord_fixed
    theme(
        plot.background = element_rect(fill = "white", color = "white"),
        panel.background = element_rect(fill = "#ccfffd", color = "#ccfffd"),
        panel.grid = element_blank(),
        legend.position = c(.2, .8)
    )
