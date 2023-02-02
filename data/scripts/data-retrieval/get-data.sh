#! /usr/bin/bash

# DIR=( "$HOME/data/de-lijn-gtfs-$(date +'%d-%m-%Y')/" "$HOME/data/nmbs-gtfs-$(date +'%d-%m-%Y')/" "$HOME/data/mivb-gtfs-$(date +'%d-%m-%Y')/" "$HOME/data/tec-gtfs-$(date +'%d-%m-%Y')/" )
DIR=(   "$HOME/data/de-lijn-gtfs-$(date +'%d-%m-%Y')/" 
        "$HOME/data/nmbs-gtfs-$(date +'%d-%m-%Y')/" 
        # "$HOME/data/mivb-gtfs-$(date +'%d-%m-%Y')/" 
        # "$HOME/data/tec-gtfs-$(date +'%d-%m-%Y')/" 
    )


#download file
function download_data() {
    # Download gtfs data from de lijn, mivb, nmbs and tec
    curl -o "$HOME/data/de_lijn-gtfs.zip" https://gtfs.irail.be/de-lijn/de_lijn-gtfs.zip
    curl -o "$HOME/data/nmbs-gtfs.zip" https://sncb-opendata.hafas.de/gtfs/static/c21ac6758dd25af84cca5b707f3cb3de 
    # curl -o "$HOME/data/mivb-gtfs.zip" https://gtfs.irail.be/mivb/mivb-gtfs.zip
    # curl -o "$HOME/data/tec-gtfs.zip" https://gtfs.irail.be/tec/tec-gtfs.zip

    # Download NMBS station information from iRail
    curl -o "$HOME/data/iRail/stations-$(date +'%d-%m-%Y').csv" https://raw.githubusercontent.com/iRail/stations/master/stations.csv 
    curl -o "$HOME/data/iRail/stops-$(date +'%d-%m-%Y').csv" https://raw.githubusercontent.com/iRail/stations/master/stops.csv
    curl -o "$HOME/data/iRail/facilities-$(date +'%d-%m-%Y').csv" https://raw.githubusercontent.com/iRail/stations/master/facilities.csv
}

# Unzip data from gtfs zip folders 
function unzip_data() {
    for dir in ${DIR[@]}; do
        if [ ! -d "$dir" ];
        then 
            mkdir $dir
        else
            echo "Directory $dir already exists.."
        fi
    done

    unzip -o $HOME/data/de_lijn-gtfs.zip -d ${DIR[0]}
    unzip -o $HOME/data/nmbs-gtfs.zip -d ${DIR[1]}
    # unzip -o $HOME/data/mivb-gtfs.zip -d ${DIR[2]}
    # unzip -o $HOME/data/tec-gtfs.zip -d ${DIR[3]}
}

# Convert all .txt files to .csv
function txt_to_csv() {
    # loop over all different sources
    for dir in ${DIR[@]}; do
        # loop over all files
        for file in $dir/*.txt; do 
            mv -- "$file" "${file%.txt}.csv"
        done
    done
}

# Process
echo "Starting process of data retrieval and transformation of GTFS static data.."
echo "Downloading data from servers.."
# download_data
echo "Extract files from ZIP folders.."
# unzip_data
echo "Changing file extensions from .txt to .csv.."
txt_to_csv

# Activate virtual environment for Python
source $HOME/env/bin/activate

# Change departuretimes from time format to ISO dateTime
python3 $HOME/data/scripts/data-transformation/connect-datetime.py &
pid_nmbs=$!
python3 $HOME/data/scripts/data-transformation/connect-datetime-dl.py &
pid_dl=$!
echo "PID NMBS is $pid_nmbs and delijn $pid_dl"

wait $pid_nmbs $pid_dl

echo "data transformation complete?"

echo "transforming iRail data"
python3 $HOME/data/scripts/data-transformation/replace-irail.py