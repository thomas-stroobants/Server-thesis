#! /usr/bin/bash

DIR=( "./de-lijn-gtfs/" "./nmbs-gtfs/" "./mivb-gtfs/" "./tec-gtfs/" )


#download file
function download_data() {
    wget https://gtfs.irail.be/de-lijn/de_lijn-gtfs.zip
    wget https://gtfs.irail.be/mivb/mivb-gtfs.zip
    wget https://gtfs.irail.be/nmbs/gtfs/latest.zip
    wget https://gtfs.irail.be/tec/tec-gtfs.zip

    wget https://raw.githubusercontent.com/iRail/stations/master/stations.csv
    wget https://raw.githubusercontent.com/iRail/stations/master/stops.csv
    wget https://raw.githubusercontent.com/iRail/stations/master/facilities.csv
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

    unzip ./de_lijn-gtfs.zip -d ${DIR[0]}
    unzip ./latest.zip -d ${DIR[1]}
    unzip ./mivb-gtfs.zip -d ${DIR[2]}
    unzip ./tec-gtfs.zip -d ${DIR[3]}
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