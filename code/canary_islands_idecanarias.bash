#!/usr/bin/env bash

url=https://opendata.sitcan.es/upload/unidades-administrativas/gobcan_unidades-administrativas_islas.zip

wget -P data/ $url

mkdir -p data/islands_shp

unzip data/gobcan_unidades-administrativas_islas.zip -d data/islands_shp