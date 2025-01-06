#!/usr/bin/env bash

## Obtener los identificadores (HASH) de los cambios de la imágen
## figures/precipitaciones_canarias.png para crear el GIF
git log \
  --format="%h %ai %s" \
  --after "2024-03-30 00:00:00" \
  figures/precipitaciones_canarias.png | \
    ## De los datos anteriores, vamos a obtener el hash y fecha en un output
    ## para ello usamos este while loop. Posteriormente con git-cat vemos
    ## el contenido de cada imágen y lo transferimos a una carpeta destino
    while read h; do 
      HASH=$(echo $h | sed s'/^\(.*\) 20..-..-.. .*/\1/')
      DATE=$(echo $h | sed s'/.* \(20..-..-..\) .*/\1/')
      echo "Getting the PNG with HASH: $HASH from the DATE: $DATE" 
      mkdir -p png_tempdir/
      git cat-file -p ${HASH}:figures/precipitaciones_canarias.png > \
        png_tempdir/${DATE}.png
      echo "Operación realizada para $HASH $DATE"
    done

magick -delay 20 png_tempdir/*png precipitacion_canarias.gif