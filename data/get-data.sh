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
            echo "mkdir $dir"
        else
            echo "Directory $dir already exists.."
        fi
    done

    echo "unzip ./de_lijn-gtfs.zip -d ${DIRS[0]}"
    echo "unzip ./latest.zip -d ${DIRS[1]}"
    echo "unzip ./mivb-gtfs.zip -d ${DIRS[2]}"
    echo "unzip ./tec-gtfs.zip -d ${DIRS[3]}"
}
# download_data
unzip_data
# for f in *txt; do mv -- "$f" "${f%.txt}.csv"; done