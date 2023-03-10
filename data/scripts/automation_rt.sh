#! /usr/bin/bash

# Activate virtual environment for Python
source $HOME/env/bin/activate
echo ""
# Bash script to automate the data retrieval and conversion process, including loading data into Virtuoso
echo "==================================================================="
echo ""
start_time=$(date +%s) 
echo "$(date) | Start of data retrieval static data"
# Download the realtime data bluebike

echo "$(date) | Downloading BlueBike Data"
curl -o "$HOME/data/BlueBike/bluebike.ttl" https://www.pieter.pm/Blue-Bike-to-Linked-GBFS/history/bluebike.ttl


# Delete NMBS data from Virtuoso
isql 1111 dba dba ~/data/scripts/query/clear-bulk-load-list.sql ~/data/scripts/query/delete-nmbs-graph.sql &
pid_delete_nmbs=$!
echo "$(date) | PID isql delete nmbs is $pid_delete_nmbs"

# Delete NMBS data from Virtuoso
isql 1111 dba dba ~/data/scripts/query/delete-delijn-graph.sql &
pid_delete_delijn=$!
echo "$(date) | PID isql delete delijn is $pid_delete_delijn"

# wait $pid_delete_nmbs $pid_delete_delijn

echo "$(date) | transforming iRail data"
python3 $HOME/data/scripts/data-transformation/replace-irail.py &
pid_irail_transf=$!

# Change departuretimes from time format to ISO dateTime
echo "$(date) | transforming departure times"
python3 $HOME/data/scripts/data-transformation/connect-datetime.py &
pid_nmbs=$!
python3 $HOME/data/scripts/data-transformation/connect-datetime-dl.py &
pid_dl=$!
echo "$(date) | Waiting for PID NMBS ($pid_nmbs) and De Lijn ($pid_dl) to finish"

wait $pid_nmbs $pid_dl $pid_delete_nmbs $pid_delete_delijn $pid_irail_transf
echo "$(date) | data transformation complete"


# Transforming the data to KG


echo "$(date) | Starting materialization of NMBS data using Morph-KGC"
python3 -m morph_kgc ~/graphs/config/config-nmbs-rt.ini &
pid_morph_nmbs=$!

echo "$(date) | Starting materialization of De Lijn data using Morph-KGC"
python3 -m morph_kgc ~/graphs/config/config-dl-rt.ini &
pid_morph_delijn=$!


wait $pid_morph_nmbs $pid_morph_delijn $pid_morph_irail
echo "$(date) | Materialization complete"

# Loading the data into Virtuoso
echo "$(date) | Loading data into Virtuoso..."
isql 1111 dba dba ~/data/scripts/query/nmbs-rt-load.sql &
pid_load_nmbs=$!
isql 1111 dba dba ~/data/scripts/query/delijn-rt-load.sql &
pid_load_delijn=$!

# TODO: loading blue-bike data into Virtuoso

wait $pid_load_nmbs $pid_load_delijn
echo "$(date) | Loading data into Virtuoso complete"

stop_time=$(date +%s)
# Calculate duration of script
time_diff=$((stop_time - start_time))
echo "$(date) | Time taken to run the script: $time_diff seconds.."
echo ""