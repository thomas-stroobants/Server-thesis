#! /usr/bin/bash

# Activate virtual environment for Python
source $HOME/env/bin/activate

# Bash script to automate the data retrieval and conversion process, including loading data into Virtuoso
echo "----------------------------------------------"
start_time=$(date +%s) 
echo "$(date) | Start of data retrieval static data"
# Download the static data
$HOME/data/scripts/data-retrieval/get-data.sh


# Delete NMBS data from Virtuoso
isql 1111 dba dba ~/data/scripts/query/delete-nmbs-graph.sql &
pid_delete_nmbs=$!
echo "PID is $pid_delete_nmbs"

wait $pid_delete_nmbs

# Change departuretimes from time format to ISO dateTime
python3 $HOME/data/scripts/data-transformation/connect-datetime.py &
pid_nmbs=$!
python3 $HOME/data/scripts/data-transformation/connect-datetime-dl.py &
pid_dl=$!
echo "$(date) | Waiting for PID NMBS ($pid_nmbs) and De Lijn ($pid_dl) to finish"

wait $pid_nmbs $pid_dl
echo "$(date) | data transformation complete"

echo "$(date) | transforming iRail data"
python3 $HOME/data/scripts/data-transformation/replace-irail.py




stop_time=$(date +%s)

time_diff=$((stop_time - start_time))
echo "$(date) | Time taken to run the script: $time_diff seconds.."