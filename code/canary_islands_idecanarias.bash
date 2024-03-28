#!/usr/bin/env bash

#url_islands=https://opendata.sitcan.es/upload/unidades-administrativas/gobcan_unidades-administrativas_islas.zip
url_muni=https://opendata.sitcan.es/upload/unidades-administrativas/gobcan_unidades-administrativas_municipios.zip

wget -P data/ $url_muni 

mkdir -p data/islands_shp

unzip data/gobcan_unidades-administrativas_municipios.zip -d data/islands_shp