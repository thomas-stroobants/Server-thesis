#! /usr/bin/bash

DIR=( "./data/de-lijn-gtfs-$(date +'%d-%m-%Y')/" "./data/nmbs-gtfs-$(date +'%d-%m-%Y')/" "./data/mivb-gtfs-$(date +'%d-%m-%Y')/" "./data/tec-gtfs-$(date +'%d-%m-%Y')/" )


#download file
function download_data() {
    curl -o "./data/de_lijn-gtfs.zip" https://gtfs.irail.be/de-lijn/de_lijn-gtfs.zip
    curl -o "./data/mivb-gtfs.zip" https://gtfs.irail.be/mivb/mivb-gtfs.zip
    curl -o "./data/nmbs-gtfs.zip" https://sncb-opendata.hafas.de/gtfs/static/c21ac6758dd25af84cca5b707f3cb3de 
    curl -o "./data/tec-gtfs.zip" https://gtfs.irail.be/tec/tec-gtfs.zip

    curl -o "./data/iRail/stations-$(date +'%d-%m-%Y').csv" https://raw.githubusercontent.com/iRail/stations/master/stations.csv 
    curl -o "./data/iRail/stops-$(date +'%d-%m-%Y').csv" https://raw.githubusercontent.com/iRail/stations/master/stops.csv
    curl -o "./data/iRail/facilities-$(date +'%d-%m-%Y').csv" https://raw.githubusercontent.com/iRail/stations/master/facilities.csv
}

function unzip_data() {
    for dir in ${DIR[@]}; do
        if [ ! -d "$dir" ];
        then 
            mkdir $dir
        else
            echo "Directory $dir already exists.."
        fi
    done

    unzip -o ./data/de_lijn-gtfs.zip -d ${DIR[0]}
    unzip -o ./data/nmbs-gtfs.zip -d ${DIR[1]}
    unzip -o ./data/mivb-gtfs.zip -d ${DIR[2]}
    unzip -o ./data/tec-gtfs.zip -d ${DIR[3]}
}

function txt_to_csv() {
    for dir in ${DIR[@]}; do
        for file in $dir/*.txt; do 
            mv -- "$file" "${file%.txt}.csv"
        done
    done
}

download_data
unzip_data
txt_to_csv
# for f in *txt; do mv -- "$f" "${f%.txt}.csv"; done