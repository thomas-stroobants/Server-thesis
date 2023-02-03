#! /usr/bin/bash

# Activate virtual environment for Python
source $HOME/env/bin/activate
echo ""
# Bash script to automate the data retrieval and conversion process, including loading data into Virtuoso
echo "==================================================================="
echo ""
start_time=$(date +%s) 
echo "$(date) | Start of data retrieval static data"
# Download the static data
$HOME/data/scripts/data-retrieval/get-data.sh


# Delete NMBS data from Virtuoso
isql 1111 dba dba ~/data/scripts/query/clear-bulk-load-list.sql ~/data/scripts/query/delete-nmbs-graph.sql &
pid_delete_nmbs=$!
echo "$(date) | PID isql delete nmbs is $pid_delete_nmbs"

# Delete NMBS data from Virtuoso
isql 1111 dba dba ~/data/scripts/query/delete-delijn-graph.sql &
pid_delete_delijn=$!
echo "$(date) | PID isql delete delijn is $pid_delete_delijn"

# wait $pid_delete_nmbs $pid_delete_delijn

# Change departuretimes from time format to ISO dateTime
python3 $HOME/data/scripts/data-transformation/connect-datetime.py &
pid_nmbs=$!
python3 $HOME/data/scripts/data-transformation/connect-datetime-dl.py &
pid_dl=$!
echo "$(date) | Waiting for PID NMBS ($pid_nmbs) and De Lijn ($pid_dl) to finish"

wait $pid_nmbs $pid_dl $pid_delete_nmbs $pid_delete_delijn
echo "$(date) | data transformation complete"

echo "$(date) | transforming iRail data"
python3 $HOME/data/scripts/data-transformation/replace-irail.py


# Transforming the data to KG
echo "$(date) | Starting materialization of NMBS data using Morph-KGC"
python3 -m morph_kgc ~/graphs/config/config-nmbs.ini &
pid_morph_nmbs=$!

echo "$(date) | Starting materialization of NMBS data using Morph-KGC"
python3 -m morph_kgc ~/graphs/config/config-dl.ini &
pid_morph_delijn=$!


wait $pid_morph_nmbs $pid_morph_delijn
echo "$(date) | Materialization complete"

# Loading the data into Virtuoso
isql 1111 dba dba ~/data/scripts/query/nmbs-load.sql &
pid_load_nmbs=$!
isql 1111 dba dba ~/data/scripts/query/delijn-load.sql &
pid_load_delijn=$!

wait $pid_load_nmbs $pid_load_delijn
echo "$(date) | Loading data into Virtuoso complete"

stop_time=$(date +%s)

time_diff=$((stop_time - start_time))
echo "$(date) | Time taken to run the script: $time_diff seconds.."