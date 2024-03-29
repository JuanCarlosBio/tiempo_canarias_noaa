#!/usr/bin/env Rscript

library(tidyverse)
library(lubridate)
library(glue)
library(sf)

prcp_data <- read_tsv("data/ghcnd_tidy.tsv")
stations_data <- read_tsv("data/ghcnd_canary_regions_years.tsv")
muni <- read_sf("data/islands_shp/municipios.shp")

muni_dd <- st_transform(muni, crs = 4326)

lat_lon_prcp <- inner_join(prcp_data, stations_data, by = "id") %>% 
    filter((year != first_year & year != last_year) | year == year(today())) %>%
    group_by(latitude, longitude, year) %>%
    summarise(mean_prcp = mean(prcp)) 

end <- format(today(), "%d/%m/%Y")
start <- format(today() - 30, "%d/%m/%Y")

lat_lon_prcp %>%
    group_by(longitude, latitude) %>%
    mutate(
        z_score = (mean_prcp - mean(mean_prcp)) / sd(mean_prcp),
        n = n(),
    ) %>%
    ungroup() %>%
    filter(n >= 30 & year == year(today())
) %>%
    select(-n, -mean_prcp, -year) %>%
    mutate(z_score = if_else(z_score > 1, 1, z_score),
           z_score = if_else(z_score < -1, -1, z_score)) %>%
ggplot() +
    geom_sf(data = muni_dd,
            fill = "#b5a078") +
    geom_point(aes(x = longitude, y = latitude, fill = z_score), 
               size = 10,
               color = "black",
               pch = 21) +
    scale_fill_gradient2(low = "red", 
                         mid = "white", 
                         high = "forestgreen",
                         midpoint=0,
                         limits = c(-1.1,1.1),
                         breaks = c(-1, -0.5, 0, 0.5, 1),
                         labels = c("<-1", "-0.5", "0", "0.5", ">1")) +
    labs(
        title = glue("Cantidad de precipitaciones en Canarias del {start} al {end}"),
        subtitle = "Z-score estandarizado para al menos los últimos 30 años",
        caption = 'Datos de las precipitaciones obtenidos de la colección GHCDN diaria de las estaciones NOAA.\nBasado en el proyecto "Drought Index" del canal Riffomonas Project.',
        x = NULL,
        y = NULL,
        fill = NULL
    ) +
    coord_sf() +  # Usar coord_sf en lugar de coord_fixed
    theme_test() +
    theme(
        plot.background = element_rect(fill = "#ffffff", color = "#ffffff"),
        panel.background = element_rect(fill = "#ccfffd", color = "#ccfffd"),
        plot.title = element_text(size = 12, face = "bold"),
        plot.caption = element_text(hjust=0),
        panel.grid = element_blank(),
        axis.text = element_text(color = "black", size = 6),
        axis.text.y = element_text(angle = 90, hjust = .5),
        axis.ticks = element_line(linewidth = .5),
        legend.position = c(.9, .15),
        legend.direction = "horizontal",
        legend.key.height = unit(.25, "cm"),
        legend.text = element_text(size=6),
        legend.background = element_rect(fill="transparent")
    )

ggsave("figures/precipitaciones_canarias.png",
       width = 9,
       height = 4.25)
