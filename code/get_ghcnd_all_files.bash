#!/usr/bin/env bash

echo "filename" > data/ghcnd_all_files.txt 
tar tf data/ghcnd_all.tar.gz | grep ".dly" >> data/ghcnd_all_files.txt