#! /usr/bin/bash

DIR=( "./de-lijn-gtfs/" "./nmbs-gtfs/" "./mivb-gtfs/" "./tec-gtfs/" )


#download file
function download_data() {
    curl -O https://gtfs.irail.be/de-lijn/de_lijn-gtfs.zip
    curl -O https://gtfs.irail.be/mivb/mivb-gtfs.zip
    curl -o "./nmbs-gtfs.zip" https://sncb-opendata.hafas.de/gtfs/static/c21ac6758dd25af84cca5b707f3cb3de 
    curl -O https://gtfs.irail.be/tec/tec-gtfs.zip

    curl -O https://raw.githubusercontent.com/iRail/stations/master/stations.csv -d ./iRail
    curl -O https://raw.githubusercontent.com/iRail/stations/master/stops.csv -d ./iRail
    curl -O https://raw.githubusercontent.com/iRail/stations/master/facilities.csv -d ./iRail
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

    unzip -o ./de_lijn-gtfs.zip -d ${DIR[0]}
    unzip -o ./nmbs-gtfs.zip -d ${DIR[1]}
    unzip -o ./mivb-gtfs.zip -d ${DIR[2]}
    unzip -o ./tec-gtfs.zip -d ${DIR[3]}
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