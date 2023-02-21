#!/usr/bin/bash

#URL of .zip file to download
url="https://data.stib-mivb.brussels/api/datasets/1.0/gtfs-files-production/alternative_exports/gtfszip/"

# Desired name for file after download 
name="gtfs-mivb"

# Download file
wget $url -O $name.zip

# Unzip the file
unzip $name.zip -d $name

# Change extension of all .txt files inside the folder to .csv
find $name -name '*.txt' -exec sh -c 'mv "$1" "${1%.txt}.csv"' _ {} \;

# remove the zip file
rm $name.zip
