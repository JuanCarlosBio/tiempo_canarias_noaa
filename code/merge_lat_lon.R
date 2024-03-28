#!/usr/bin/env Rscript

library(tidyverse)

canarias_box <- data.frame(
  latitude = c(29.68374429, 29.73653255, 27.22072549, 27.29312474),
  longitude = c(-18.81624366, -13.02475776, -18.67278517, -13.06979070)
)

read_fwf("data/ghcnd-stations.txt",
         col_positions = fwf_cols(
            id = c(1,11),
            latitude = c(13,20),
            longitude = c(22,30),
            elevation = c(32,37),
            state = c(39,40),
            name = c(42,71),
            gsn_flag = c(73,75),
            hcn_flag = c(77,79),
            wmo_id = c(81,85) 
         )) %>%
    select(id, latitude, longitude) %>%
    mutate(inside_canarias = case_when(
            latitude >= min(canarias_box$latitude) & latitude <= max(canarias_box$latitude) &
            longitude >= min(canarias_box$longitude) & longitude <= max(canarias_box$longitude) ~ TRUE,
            TRUE ~ FALSE
           )) %>% 
    filter(inside_canarias) %>%
    group_by(longitude, latitude) %>%
    mutate(region = cur_group_id()) %>%
    count(region) %>%
    arrange(-n) %>%
    write_tsv("data/ghcnd_canary_regions.tsv")
    